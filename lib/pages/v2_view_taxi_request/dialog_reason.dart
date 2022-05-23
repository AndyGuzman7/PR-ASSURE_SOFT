import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/components/buttons/CustomButtonWithLinearBorder.dart';

import 'package:taxi_segurito_app/pages/v2_view_taxi_request/view_taxi_request_functionality.dart';

class DialogReason extends StatefulWidget {
  const DialogReason({Key? key}) : super(key: key);

  @override
  _DialogReasonState createState() => _DialogReasonState();
}

class _DialogReasonState extends State<DialogReason> {
  late String values = "";
  late bool _isVisible = false;

  Color colorMain = Color.fromRGBO(255, 193, 7, 1);
  Color colorMainDanger = Color.fromRGBO(242, 78, 30, 1);

  final _formKey = GlobalKey<FormState>();
  late ViewTaxiRequestFunctionality viewTaxiRequestFunctionality =
      new ViewTaxiRequestFunctionality();

  _setRcVisible(bool status) {
    this.setState(() {
      _isVisible = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool statusRd = false;
    String reason = "";

    final btnRegister = new CustomButtonWithLinearBorder(
      onTap: () {
        if (values == "4") {
          if (_formKey.currentState!.validate()) {
            viewTaxiRequestFunctionality.sendReasonCancel(reason);
            Navigator.pop(context);
          }
        } else {
          String reasonR = "Accidente";
          switch (values) {
            case "1":
              reasonR = "Accidente";
              break;
            case "2":
              reasonR = "Robo";
              break;
            case "3":
              reasonR = "Sin combustible";
              break;
          }

          viewTaxiRequestFunctionality.sendReasonCancel(reasonR);
          Navigator.pop(context);
        }
      },
      buttonText: "ENVIAR MOTIVO",
      buttonColor: Color.fromRGBO(255, 193, 7, 1),
      buttonTextColor: Color.fromARGB(255, 255, 255, 255),
      marginBotton: 0,
      buttonBorderColor: Color.fromRGBO(255, 193, 7, 1),
      marginLeft: 0,
      marginRight: 0,
      marginTop: 10,
    );

    TextFormField textFormField = TextFormField(
      maxLines: null, //wrap text
      maxLength: 70,
      keyboardType: TextInputType.text,
      validator: (value) {
        reason = value.toString();
        print(value);
        return value!.isNotEmpty ? null : "Espacio requerido.";
      },
      autofocus: true,
      autocorrect: true,
      cursorColor: colorMain,
      decoration: new InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromRGBO(255, 193, 7, 1), width: 0.0),
        ),
        focusedBorder: new OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(255, 193, 7, 1)),
        ),
        border: const OutlineInputBorder(),
        labelStyle: new TextStyle(color: Colors.black),
        labelText: 'Motivo (Maximo 70 caracteres)',
      ),
    );

    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Text(
                    'Cancelando solicitud',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w800),
                  ),
                  alignment: Alignment.center,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Text(
                    'Motivo:',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  alignment: Alignment.topLeft,
                ),
                CustomRadioButton(
                  horizontal: true,
                  unSelectedBorderColor: colorMain,
                  unSelectedColor: Theme.of(context).canvasColor,
                  buttonLables: [
                    'Accidente',
                    'Robo',
                    'Sin combustible',
                    'Otro...',
                  ],
                  buttonValues: ["1", "2", "3", "4"],
                  defaultSelected: "1",
                  radioButtonValue: (value) {
                    values = value.toString();
                    if (values.toString() == "4") {
                      statusRd = true;
                    } else {
                      statusRd = false;
                    }
                    setState(() {
                      _setRcVisible(statusRd);
                    });
                  },
                  selectedColor: colorMain,
                  selectedBorderColor: colorMain,
                ),
                Visibility(
                  visible: _isVisible,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: textFormField,
                  ),
                ),
                btnRegister
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*Widget to activate dialog and cancel the request

  final btnActive = new CustomButton(
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => const DialogReason());
      },
      buttonText: "Cancelar Solicitud",
      buttonColor: Color.fromRGBO(255, 193, 7, 1),
      buttonTextColor: Colors.white,
      marginBotton: 0,
      marginLeft: 0,
      marginRight: 0,
      marginTop: 0,
    );

*/