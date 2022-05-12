import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class NotificationsFirebase {
  String url = "https://fcm.googleapis.com/fcm/send";
  String key =
      "AAAAvrKm_kk:APA91bFbW-5W3MWTSOPq_Lam18qRzZNMzFT37EfOTrBvHSzkVV5Z2WJbHp2d-IzxoSuISXxWbPpHaxFJ2DuIpr_ecrICHc6dh3xQUexzaw2i6I1oBEp-Cys5dce9GGMpS2tfgZSO3Dl4";

  Future<bool> sendNotification(LatLng latLng) async {
    String path = url;
    var response = await http.post(
      Uri.parse(path),
      headers: {
        'Authorization': 'key=$key',
      },
      body: jsonEncode({
        "to": "/topics/DriverMessages",
        "notification": {
          "title": "Taxi Segurito",
          "body": "¡Hay solictudes nuevas!"
        },
        "data": {
          "latitudeOrigenClient": latLng.latitude,
          "longitudeOrigenClient": latLng.longitude
        }
      }),
    );

    return response.statusCode == 200;
  }
}
