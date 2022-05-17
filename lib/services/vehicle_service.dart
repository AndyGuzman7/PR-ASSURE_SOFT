import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taxi_segurito_app/models/vehicle.dart';
import 'package:taxi_segurito_app/services/auth_service.dart';
import 'package:taxi_segurito_app/services/server.dart';

class VehicleService {
  AuthService _authService = AuthService();

  Future<List<Vehicle>> getOwnVehicles() async {
    final ownerId = await _authService.getCurrentId();
    final queryParams = {'ownerId': ownerId.toString()};
    final endpoint = Uri.http(
      Server.host,
      '${Server.baseEndpoint}/vehicle/vehicle_controller.php',
      queryParams,
    );

    var response = await http.get(endpoint);
    if (response.statusCode == 200) {
      return _jsonToList(response);
    }
    throw 'Unable to fetch vehicles data';
  }

  Future<List<Vehicle>> getVehiclesByOwnerId(int ownerId) async {
    final queryParams = {'ownerId': ownerId.toString()};
    final endpoint = Uri.http(
      Server.host,
      '${Server.baseEndpoint}/vehicle/vehicle_controller.php',
      queryParams,
    );

    var response = await http.get(endpoint);
    if (response.statusCode == 200) {
      print(response.body);
      return _jsonToList(response);
    }
    throw 'Unable to fetch vehicles data';
  }

  Future<bool> update(Vehicle vehicle) async {
    try {
      final endpoint = Uri.http(
        Server.host,
        '${Server.baseEndpoint}/vehicle/vehicle_controller.php',
      );
      final response = await http.put(
        endpoint,
        body: jsonEncode(
          {
            "idVehicle": vehicle.idVehicle,
            "color": vehicle.color,
            "model": vehicle.model,
            "pleik": vehicle.pleik,
            "capacity": vehicle.capacity,
            "photo": vehicle.pictureStr,
            "status": vehicle.status,
            "owner_idowner": vehicle.idOwner
          },
        ),
      );
      print(vehicle.idVehicle);
      print(vehicle.idOwner);
      print(response.statusCode);
      print(jsonDecode(response.body));
      bool success = response.statusCode == 200;
      return success;
    } catch (exception) {
      print(exception);
      return false;
    }
  }

  List<Vehicle> _jsonToList(http.Response response) {
    List<dynamic> body = jsonDecode(response.body);
    List<Vehicle> vehicles = body.map((v) => Vehicle.fromJson(v)).toList();
    return vehicles;
  }

  Future<bool> insertVehicle(Vehicle vehicle) async {
    try {
      var path = '${Server.url}/vehicle/vehicle_controller.php';
      final response = await http.post(
        Uri.parse(path),
        body: jsonEncode({
          "color": vehicle.color,
          "model": vehicle.model,
          "pleik": vehicle.pleik,
          "capacity": vehicle.capacity,
          "picture": vehicle.pictureStr,
          "ownerId": vehicle.idOwner.toString(),
        }),
      );
      return response.statusCode == 200;
    } catch (exception) {
      print(exception.toString());
      return false;
    }
  }
}
