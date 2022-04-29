import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:taxi_segurito_app/bloc/validators/blocValidate.dart';
import 'package:taxi_segurito_app/components/inputs/CustomTextField.dart';
import 'package:taxi_segurito_app/models/driver.dart';
import 'package:taxi_segurito_app/providers/ImagesFileAdapter.dart';
import 'package:taxi_segurito_app/validators/TextFieldValidators.dart';

class DriverRegisterForm extends StatefulWidget {
  GlobalKey<FormState> formKey;
  DriverRegisterForm(this.formKey);
  DriverRegisterFormState _state = DriverRegisterFormState();

  @override
  DriverRegisterFormState createState() => _state;

  Driver? getDriverIfIsValid() {
    bool isImageValid = _state.fieldImage.validate();
    bool isFormValid = formKey.currentState!.validate();
    if (isImageValid && isFormValid) {
      return _state.getDriver();
    }
    return null;
  }
}

class DriverRegisterFormState<T extends DriverRegisterForm> extends State<T> {
  late CustomTextField fieldName, fieldLastname, fieldSecondLastname;
  late CustomTextField fieldCi, fieldLicense, fieldCellphone, fieldEmail, fieldPassword;
  late ImagesFileAdapter fieldImage = ImagesFileAdapter(
    imagePathDefaultUser: "assets/images/user_default.png",
    isShapeCircle: true,
  );

  @override
  void initState() {
    super.initState();

  }

  String? validatePassword(value) {
    if (value.isEmpty) {
      return "Confirme su contraseña";
    }
    if (value != fieldPassword.getValue()) {
      return "La contraseña no coincide";
    }
    return null;
  }

  Driver getDriver() {
    return new Driver.insertV2(
      fullName: fullname,
      cellphone: fieldCellphone.getValue(),
      license: fieldLicense.getValue(),
      ci: fieldCi.getValue(),
      pictureStr: fieldImage.getImageBase64AsString(),
      email: fieldEmail.getValue(),
      password: fieldPassword.getValue()
    );
  }

  String get fullname {
    final name = fieldName.getValue();
    final lastname = fieldLastname.getValue();
    final secondLastname = fieldSecondLastname.getValue();
    return '$name $lastname $secondLastname';
  }

  Widget get nameFields {
    return Column(
      children: [
        fieldName,
        fieldLastname,
        fieldSecondLastname,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    fieldName = CustomTextField(
      hint: "Nombre",
      multiValidator: MultiValidator([
        RequiredValidator(errorText: 'El nombre es requerido'),
        StringValidator(errorText: 'No puede ingresar valores numéricos')
      ]),
      marginLeft: 0,
      marginRight: 0,
      heightNum: 42,
    );

    fieldLastname = CustomTextField(
      hint: "Primer apellido",
      multiValidator: MultiValidator([
        RequiredValidator(errorText: 'El apellido es requerido'),
        StringValidator(errorText: 'No puede ingresar valores numéricos')
      ]),
      marginLeft: 0,
      marginRight: 0,
      heightNum: 42,
    );

    fieldSecondLastname = CustomTextField(
      hint: "Segundo apellido",
      multiValidator: MultiValidator([
        StringValidator(errorText: 'No puede ingresar valores numéricos'),
      ]),
      marginLeft: 0,
      marginRight: 0,
      heightNum: 42,
    );

    fieldImage = ImagesFileAdapter(
      imagePathDefaultUser: "assets/images/user_default.png",
      isShapeCircle: true,
    );

    fieldCi = CustomTextField(
      hint: "Número de carnet",
      multiValidator: MultiValidator([
        RequiredValidator(errorText: 'Número de carnet requerido'),
        NumberValidator(errorText: 'No puede ingresar letras')
      ]),
      marginLeft: 0,
      marginRight: 0,
      heightNum: 42,
    );

    fieldLicense = CustomTextField(
      hint: "Nivel de licencia de conducir",
      multiValidator: MultiValidator([
        RequiredValidator(errorText: 'Nivel de licencia de conducir requerido'),
        StringValidator(errorText: 'No puede ingresar valores numéricos'),
      ]),
      marginLeft: 0,
      marginRight: 0,
      heightNum: 42,
    );

    fieldCellphone = CustomTextField(
      hint: "Número de celular",
      multiValidator: MultiValidator([
        RequiredValidator(errorText: 'Número de celular requerido'),
        NumberValidator(errorText: 'No puede ingresar letras')
      ]),
      marginLeft: 0,
      marginRight: 0,
      heightNum: 42,
    );

    fieldEmail = new CustomTextField(
      hint: "Correo Electrónico",
      multiValidator: MultiValidator([
        RequiredValidator(errorText: 'Correo Electrónico requerido')
      ]),
      marginLeft: 0,
      marginRight: 0,
      heightNum: 42,
    );

    fieldPassword = new CustomTextField(
      hint: "Contraseña",
      obscureText: true,
      multiValidator: MultiValidator([
        RequiredValidator(errorText: 'Contraseña requerido')
      ]),
      marginLeft: 0,
      marginRight: 0,
      heightNum: 42,
    );

    /*fieldRePassword = new CustomTextField(
      hint: "Confirmar Contraseña",
      obscureText: true,
      multiValidator: MultiValidator([
        RequiredValidator(errorText: 'Confirmacion de Contraseña requerido'),
      ]),
      marginLeft: 0,
      marginRight: 0,
      heightNum: 42,
    );*/

    

    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: widget.formKey,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 110),
            child: Row(
              children: [
                Expanded(child: fieldImage),
              ],
            ),
          ),
          SizedBox(height: 18),
          nameFields,
          fieldCi,
          fieldLicense,
          fieldCellphone,
          fieldEmail,
          fieldPassword,
          TextFormField(
            validator: validatePassword,//((val) => MatchValidator(errorText: 'diferente').validateMatch(fieldPassword.value,val.toString())),
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 13),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              hintText: 'Confirmar Contraseña',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(width: 2, color: Colors.amber),
              ),
              fillColor: Colors.yellow,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 0.0),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}
