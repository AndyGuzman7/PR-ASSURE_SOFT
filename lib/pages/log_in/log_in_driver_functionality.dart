import 'package:taxi_segurito_app/services/auth_service.dart';
import 'package:taxi_segurito_app/components/toast/toats_glo.dart';
import 'package:taxi_segurito_app/models/user.dart';
import 'package:flutter/material.dart';

import '../../models/driver.dart';

class LoginDriverFuctionality {
  late BuildContext context;
  late AuthService authService;

  LoginDriverFuctionality(this.context) {
    authService = AuthService();
  }

  void validateLogIn(Driver driver) async {
    Driver? driverRes = await authService.logInDriver(driver);

    if (driverRes != null) {
      /*GlobalToast.displayToast(
          Text("Bienvenido"), Colors.greenAccent, Icon(Icons.check), 2);*/

      if (driverRes.role.toString() == "driver") {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacementNamed(
          context,
          'driverMenu',
          arguments: driverRes.fullName,
        );
      }
    } else {
      GlobalToast.displayToast(
        Text("Datos Incorrectos"),
        Colors.redAccent,
        Icon(Icons.error),
        2,
      );
      print("No se logueo");
    }
  }
}
