import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taxi_segurito_app/models/driver.dart';
import 'package:taxi_segurito_app/providers/ImageFromBase64Provider.dart';
import 'package:taxi_segurito_app/services/auth_service.dart';
import 'server.dart';

class DriversService {
  AuthService _authService = AuthService();

  Future<bool> insert(Driver driver) async {
    final ownerId = await _authService.getCurrentId();
    String path = '${Server.url}/driver/driver_controller.php';
    final response = await http.post(
      Uri.parse(path),
      body: jsonEncode({
        "fullname": driver.fullName,
        "cellphone": driver.cellphone,
        "license": driver.license,
        "ci": driver.ci,
        "picture": driver.pictureStr,
        "ownerId": ownerId,
        "email": driver.email,
        "password": driver.password,
      }),
    );
    print(response.body);

    return response.statusCode == 200;
  }

  Future<List<Driver>> getDrivers() async {
    final ownerId = await _authService.getCurrentId();
    final queryParams = {'ownerId': ownerId.toString()};
    final endpoint = Uri.http(
      Server.host,
      '${Server.baseEndpoint}/driver/driver_controller.php',
      queryParams,
    );
    print(endpoint);

    http.Response response = await http.get(endpoint);
    if (response.statusCode == 200) {
      print(response.statusCode);
      return _jsonToList(response);
    }

    throw 'Unable to fetch drivers data';
  }

  Future<List<Driver>> getByCriteria(String criteria) async {
    final ownerId = await _authService.getCurrentId();
    final queryParams = {
      'criteria': criteria,
      'ownerId': ownerId.toString(),
    };
    final endpoint = Uri.http(
      Server.host,
      '${Server.baseEndpoint}/driver/driver_controller.php',
      queryParams,
    );

    http.Response response = await http.get(endpoint);
    if (response.statusCode == 200) {
      return _jsonToList(response);
    }
    throw 'Unable to fetch drivers data';
  }

  List<Driver> _jsonToList(http.Response response) {
    print(response.body);
    List<dynamic> body = jsonDecode(response.body);
    List<Driver> drivers = body.map((d) => Driver.fromJson(d)).toList();
    return drivers;
  }

  Future<bool> delete(Driver driver) async {
    try {
      String path = '${Server.url}/driver/driver_controller.php';
      http.Response response = await http.delete(
        Uri.parse(path),
        body: jsonEncode({'id': driver.idPerson.toString()}),
      );

      final success = response.statusCode == 200;
      return success;
    } catch (exception) {
      return false;
    }
  }

  Future<bool> update(Driver driver) async {
    try {
      String path = '${Server.url}/driver/driver_controller.php';

      http.Response response = await http.put(
        Uri.parse(path),
        body: jsonEncode(
          {
            'id': driver.idPerson,
            'fullname': driver.fullName,
            'cellphone': driver.cellphone,
            'license': driver.license,
            'ci': driver.ci,
            'picture': stringFromBase64Bytes(driver.picture),
            'ownerId': driver.ownerId,
            'email': driver.email,
            'password': driver.password,
          },
        ),
      );

      final success = response.statusCode == 200;
      return success;
    } catch (exception) {
      return false;
    }
  }
}
