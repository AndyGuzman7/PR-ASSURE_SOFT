import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:taxi_segurito_app/models/client_user.dart';
import 'package:taxi_segurito_app/services/auth_service.dart';
import 'server.dart';

class SignUpService {
  Future<bool> _registerClient(Clientuser clientUser, String signUpType) async {
    print(clientUser.fullName + clientUser.email + clientUser.cellphone);
    String path = Server.url + "/auth/auth_controller.php";
    print("Se hizo una pericion");
    final response = await http.post(
      Uri.parse(path),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": clientUser.email,
        "password": clientUser.password,
        "typeRegister": signUpType,
        "fullName": clientUser.fullName,
        "cellphone": clientUser.cellphone
      }),
    );

    print(response.body);
    final success = response.statusCode == 200;
    return success;
  }

  Future<bool> registerClientThroughEmail(Clientuser clientUser) async {
    final success = await _registerClient(
      clientUser,
      Server.SignUpType['EMAIL']!,
    );
    return success;
  }

  Future<bool> registerClientThroughGoogle(Clientuser clientUser) async {
    final success = await _registerClient(
      clientUser,
      Server.SignUpType['GOOGLE']!,
    );
    if (success) {
      AuthService().logIn(clientUser);
    }
    return success;
  }

  Future<bool> registerClientThroughFacebook(Clientuser clientUser) async {
    final success = await _registerClient(
      clientUser,
      Server.SignUpType['FACEBOOK']!,
    );
    if (success) {
      AuthService().logIn(clientUser);
    }
    return success;
  }
}
