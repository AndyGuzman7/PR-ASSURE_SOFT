import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taxi_segurito_app/models/report_car.dart';
import 'package:taxi_segurito_app/models/user.dart';
import 'package:taxi_segurito_app/services/auth_service.dart';
import 'package:taxi_segurito_app/services/server.dart';

class ReportCarService {
  AuthService _authService = AuthService();

  Future<bool> insertReportCar(ReportCar reportCar) async {
    try {
      var path = "${Server.url}/report_car/report_car_controller.php";
      final response = await http.post(
        Uri.parse(path),
        body: jsonEncode(
          {
            "calification": reportCar.calification,
            "coments": reportCar.comment,
            "clientuser_idclientuser": reportCar.idClientuser,
            "vehicleId": reportCar.idVehicule
          },
        ),
      );

      final success = response.statusCode == 200;
      print(success);
      return success;
    } catch (exception) {
      print(exception);
      return Future<bool>.value(false);
    }
  }

//Returns a double if success.
  Future<double> getAverageRating(int idVehicle) async {
    try {
      final queryParams = {'idVehicle': idVehicle.toString()};
      final endpoint = Uri.http(
        Server.host,
        '${Server.baseEndpoint}/report_car/report_car_controller.php',
        queryParams,
      );

      final response = await http.get(endpoint);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return double.parse(result);
      }
      return 0.0;
    } catch (e) {
      print("2 msgError: " + e.toString());
      return -1.1;
    }
  }

  Future<List<Map<String, dynamic>>?> getVehicleReviews(int idVehicle) async {
    final ownerId = await _authService.getCurrentId();
    final queryParams = {
      'idOwner': ownerId.toString(),
      'idVehicleOfOwner': idVehicle.toString()
    };

    final endpoint = Uri.http(
      Server.host,
      '${Server.baseEndpoint}/report_car/report_car_controller.php',
      queryParams,
    );

    final response = await http.get(endpoint);
    if (response.statusCode == 200) {
      return _reviewsToList(response);
    }
    return null;
  }

  List<Map<String, dynamic>> _reviewsToList(http.Response response) {
    List<dynamic> body = jsonDecode(response.body);
    List<Map<String, dynamic>> reviews = body.map((review) {
      return {
        'comment': ReportCar.fromJson(review['comment']),
        'user': User.fromJson(review['user'])
      };
    }).toList();

    return reviews;
  }
}
