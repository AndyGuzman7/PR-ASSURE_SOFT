import 'dart:convert';
import 'package:http/http.dart';
import 'package:taxi_segurito_app/models/driver.dart';
import 'package:taxi_segurito_app/models/vehicle.dart';
import 'package:taxi_segurito_app/services/server.dart';
import 'package:http/http.dart' as http;

class DriverVehicleService {
  Future<bool> insert(int idDriver, int idVehicle) async {
    String path = '${Server.url}/driver_has_vehicle/driverhv_controller.php';
    var response = await http.post(
      Uri.parse(path),
      body: jsonEncode({
        'iddriver': idDriver,
        'idvehicle': idVehicle,
      }),
    );

    return response.statusCode == 200;
  }

  Future<bool> update(int idDriver) async {
    try {
      String path = '${Server.url}/driver_has_vehicle/driverhv_controller.php';

      http.Response response = await http.put(
        Uri.parse(path),
        body: jsonEncode(
          {
            'iddriver': idDriver,
          },
        ),
      );

      final success = response.statusCode == 200;
      return success;
    } catch (exception) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getDriverAndVehicleByPleik(String pleik) async {
    final queryParams = {'pleik': pleik};
    final endpoint = Uri.http(
      Server.host,
      '${Server.baseEndpoint}/driver_has_vehicle/driverhv_controller.php',
      queryParams,
    );

    Response response = await http.get(endpoint);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return {
        'idDriverHasVehicle': body['idDriverHasVehicle'] as int,
        'driver': Driver.fromJson(body['driver']),
        'vehicle': Vehicle.fromJson(body['vehicle'])
      };
    }
    return null;
  }

  Future<Map<String, dynamic>?> getAssignationByDriverId(int driverId) async {
    final queryParams = {'driverId': driverId.toString()};
    final endpoint = Uri.http(
      Server.host,
      '${Server.baseEndpoint}/driver_has_vehicle/driverhv_controller.php',
      queryParams,
    );

    Response response = await http.get(endpoint);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return {
        'idDriverHasVehicle': body['idDriverHasVehicle'] as int,
        'driver': Driver.fromJson(body['driver']),
        'vehicle': Vehicle.fromJson(body['vehicle'])
      };
    }
    return null;
  }

  Future<Map<String, dynamic>?> getAssignationByVehicleId(int vehicle) async {
    final queryParams = {'vehicleId': vehicle.toString()};
    final endpoint = Uri.http(
      Server.host,
      '${Server.baseEndpoint}/driver_has_vehicle/driverhv_controller.php',
      queryParams,
    );
    print(endpoint);
    Response response = await http.get(endpoint);
    print(response.body);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return {
        'idDriverHasVehicle': body['idDriverHasVehicle'] as int,
        'driver': Driver.fromJson(body['driver']),
        'vehicle': Vehicle.fromJson(body['vehicle'])
      };
    }
    return null;
  }
}
