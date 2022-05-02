import 'dart:math';
import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/components/toast/toats_glo.dart';
import 'package:taxi_segurito_app/models/client_user.dart';
import 'package:taxi_segurito_app/services/sign_up_service.dart';

class RegisterFunctionality {
  late BuildContext context;

  RegisterFunctionality();
  RegisterFunctionality.cont(this.context);

  String generateCode() {
    String code = "";
    var rng = new Random();
    for (var i = 0; i < 6; i++) {
      code = code + rng.nextInt(9).toString();
    }
    return code;
  }

  registerClient(Clientuser clientUser) async {
    final signUpService = SignUpService();
    final success = await signUpService.registerClientThroughEmail(clientUser);
    if (success) {
      // GlobalToast.displayToast(
      //     Text("Registro Exitoso"), Colors.green, Icon(Icons.check), 2);
      Navigator.pushNamed(context, 'loginUser');
    } else {
      // GlobalToast.displayToast(
      //     Text("Registro no completado"), Colors.red, Icon(Icons.error), 2);
    }
  }
}
