import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:taxi_segurito_app/bloc/validators/blocValidate.dart';
import 'package:taxi_segurito_app/components/buttons/CustomButton.dart';
import 'package:taxi_segurito_app/components/inputs/CustomTextField.dart';
import 'package:taxi_segurito_app/models/sesions/sesion.dart';
import 'package:taxi_segurito_app/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taxi_segurito_app/pages/login/login_fuctionality.dart';
import 'package:taxi_segurito_app/validators/TextFieldValidators.dart';

class UserLoginPage extends StatefulWidget {
  User user = new User.login("", "");

  UserLoginPage({Key? key}) : super(key: key);

  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  Color colorMain = Color.fromRGBO(255, 193, 7, 1);
  FToast fToast = FToast();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  Widget build(BuildContext context) {
    LoginFuctionality loginFuctionality = new LoginFuctionality(context);

    CustomTextField txtNameOR = new CustomTextField(
      value: widget.user.email,
      hint: 'Ingrese su celular o e-mail',
      multiValidator: MultiValidator(
        [
          RequiredValidator(errorText: "Campo vacio"),
        ],
      ),
      assignValue: (value) {
        widget.user.email = value;
      },
    );

    CustomTextField txtPassword = new CustomTextField(
      value: widget.user.password,
      hint: 'Contraseña',
      obscureText: true,
      multiValidator: MultiValidator(
        [
          RequiredValidator(errorText: "Campo vacio"),
        ],
      ),
      assignValue: (value) {
        widget.user.password = value;
      },
    );
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Taxi Segurito"),
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Iniciar Sesión",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      txtNameOR,
                      SizedBox(
                        height: 20,
                      ),
                      txtPassword,
                      SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            loginFuctionality.loginValidate(widget.user);
                          }
                        },
                        buttonText: "Ingresar",
                        buttonColor: colorMain,
                        buttonTextColor: Colors.white,
                      ),
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Column(
                            children: [
                              Container(
                                child: TextButton(
                                  onPressed: () async {
                                    Sessions sessions = new Sessions();
                                    await sessions
                                        .removeValuesSession("iduser");
                                    await sessions.removeValuesSession("rol");
                                  },
                                  child: Text("Olvidaste tu contraseña?",
                                      style:
                                          TextStyle(color: Colors.blueAccent)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}