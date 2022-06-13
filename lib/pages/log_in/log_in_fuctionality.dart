import 'package:taxi_segurito_app/services/auth_service.dart';
import 'package:taxi_segurito_app/components/toast/toats_glo.dart';
import 'package:taxi_segurito_app/models/user.dart';
import 'package:flutter/material.dart';

class LoginFuctionality {
  late BuildContext context;
  late AuthService authService;

  LoginFuctionality(this.context) {
    authService = AuthService();
  }

  void validateLogIn(User user) async {
    User? userRes = await authService.logIn(user);

    if (userRes != null) {
      /*GlobalToast.displayToast(
          Text("Bienvenido"), Colors.greenAccent, Icon(Icons.check), 2);*/

      if (userRes.role.toString() == 'admin') {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacementNamed(
          context,
          'adminMenu',
          arguments: userRes.fullName,
        );
      }

      if (userRes.role.toString() == 'client') {
        Navigator.pushReplacementNamed(
          context,
          'clientMenu',
          arguments: userRes.fullName,
        );
      }

      if (userRes.role.toString() == 'owner') {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacementNamed(
          context,
          'ownerMenu',
          arguments: userRes.fullName,
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
