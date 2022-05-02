import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:taxi_segurito_app/models/user.dart';
import 'package:taxi_segurito_app/services/server.dart';
import 'sessions_service.dart';

class AuthService {
  late SessionsService _sessionsService;

  AuthService() {
    _sessionsService = SessionsService();
  }

  Future<User?> logIn(User user) async {
    User? userRes = await _getUser(user);
    if (userRes != null) {
      await _saveSession(userRes);
    }

    return userRes;
  }

  Future<bool> logOut() async {
    final success = await _deleteSession();
    return success;
  }

  Future<bool> isLoggedIn() async {
    bool id = await _sessionsService.verificationSession('id');
    bool role = await _sessionsService.verificationSession('role');
    bool name = await _sessionsService.verificationSession('name');
    bool cell = await _sessionsService.verificationSession('cellphone');

    final isLoggedId = id && role && name && cell;
    return isLoggedId;
  }

  Future<int> getCurrentId() async {
    final id = await _sessionsService.getSessionValue("id");
    return int.parse(id);
  }

  Future<String> getCurrentRole() async {
    final role = await _sessionsService.getSessionValue("role");
    return role.toString();
  }

  Future<String> getCurrentUsername() async {
    final name = await _sessionsService.getSessionValue("name");
    return name.toString();
  }

  _saveSession(User user) async {
    await _sessionsService.addSessionValue('id', user.idPerson.toString());
    await _sessionsService.addSessionValue('role', user.role);
    await _sessionsService.addSessionValue('name', user.fullName);
    await _sessionsService.addSessionValue('cellphone', user.cellphone);
  }

  Future<bool> _deleteSession() async {
    bool id = await _sessionsService.verificationSession('id');
    bool role = await _sessionsService.verificationSession('role');
    bool name = await _sessionsService.verificationSession('name');
    bool cell = await _sessionsService.verificationSession('cellphone');
    if (id && role && name && cell) {
      _sessionsService.removeValuesSession('id');
      _sessionsService.removeValuesSession('role');
      _sessionsService.removeValuesSession('name');
      _sessionsService.removeValuesSession('cellphone');
      return true;
    }
    return false;
  }

  Future<User?> _getUser(User user) async {
    log("Entra Metodo get");
    final queryParams = {'email': user.email, 'password': user.password};
    final endpoint = Uri.http(
      Server.host,
      "${Server.baseEndpoint}/auth/auth_controller.php",
      queryParams,
    );

    final response = await http.get(endpoint);
    log("response.body: " + response.body);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      log(body['name']);
      return new User.logInResponse(
          body['id'], body['role'], body['name'], body['cellphone']);
    }
    log("retorna nulo");
    return null;
  }
}
