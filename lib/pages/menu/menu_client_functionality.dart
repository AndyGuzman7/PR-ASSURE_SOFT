

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taxi_segurito_app/pages/emergencyContact/contact_list_page.dart';
import 'package:taxi_segurito_app/services/auth_service.dart';
import 'package:taxi_segurito_app/utils/call_panic.dart';

var toastError = Fluttertoast.showToast(
    msg: "Debes Presionar 5 segundos",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.red,
    textColor: Colors.yellow);

var toastErrorCall = Fluttertoast.showToast(
    msg: "Hubo un Error al enviar alerta",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.red,
    textColor: Colors.yellow);

class MenuClientFunctionality {
  BuildContext context;
  MenuClientFunctionality(this.context);

  onPressedbtnContactEmergency() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListContactPage()),
    );
  }

  onPressedbtnCallPanic() async {
    try {
      await CallPanic().btnpanic().then((value) => {
            if (value == true)
              {showDialog(context: context, builder: alertDialog)}
            else
              {toastErrorCall}
          });
    } catch (e) {
      log(e.toString());
      toastErrorCall;
    }
  }

  onPressedTimePressedFault() {
    toastError;
    log("Debes presionar 5 segundos");
    showDialog(context: context, builder: infoDialog);
  }

  onPressedLogOut() async {
    try {
      final loggedOut = await AuthService().logOut();
      if (loggedOut) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacementNamed(context, 'firstScreen');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  AlertDialog infoDialog(BuildContext context) {
    return AlertDialog(
      title: new Text("Presiona!"),
      content: new Text("Presiona 5 segundos por favor."),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FloatingActionButton(
          backgroundColor: Colors.amberAccent,
          child: new Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  AlertDialog alertDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.amber.shade50,
      title: new Text("ALERTA PANICO!!"),
      content: new Text("Mesaje de Alerta Enviado Con Exito."),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FloatingActionButton(
          backgroundColor: Colors.amberAccent,
          child: new Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
