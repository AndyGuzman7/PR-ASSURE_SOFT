import 'dart:convert' show json;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/client_user.dart';

abstract class IFcmNotification {
  Future<void> sendNotificationToTaxi({
    required String Token,
    required String Title,
    required String Body,
    required String Client,
  });
  Future<void> unsubscribeFromTopic({
    required String Topic,
  });
  Future<void> subscribeToTopic({
    required String Topic,
  });
}

class NotificationsFirebase extends IFcmNotification {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final String url = "https://fcm.googleapis.com/fcm/send";
  final String contentType = "application/json";
  final String authorization = "key=AAAAvrKm_kk:APA91bFbW-5W3MWTSOPq_Lam18qRzZNMzFT37EfOTrBvHSzkVV5Z2WJbHp2d-IzxoSuISXxWbPpHaxFJ2DuIpr_ecrICHc6dh3xQUexzaw2i6I1oBEp-Cys5dce9GGMpS2tfgZSO3Dl4";



  String key = "AAAAvrKm_kk:APA91bFbW-5W3MWTSOPq_Lam18qRzZNMzFT37EfOTrBvHSzkVV5Z2WJbHp2d-IzxoSuISXxWbPpHaxFJ2DuIpr_ecrICHc6dh3xQUexzaw2i6I1oBEp-Cys5dce9GGMpS2tfgZSO3Dl4";
  //este metodo no funciona
  Future<bool> sendNotification(LatLng latLng) async {
    String path = url;
    var response = await http.post(
      Uri.parse(path),
      headers: {
        'Authorization': 'key=$key',
      },
      body: json.encode({
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

  //metodo para enviar automaticamente el mensaje de notificacion al taxista
  Future<http.Response> confirmClient(cliente, title, body) async {
    try {
      final dynamic data = json.encode(
        {
          "to": "e53nf4hyRVGCGbJ9-1wIrP:APA91bH8JqmbIBng_R4xh68yJgO3GUM5LVTEq75afZwE-MU5CCjC604UNmwAWhwoBwWx5m2st3ZdGQ_G6sXVP_fRf-fFTnwVg0a-iNX6HwIdLEIWizsVkVik_PabugvdbaihZSDLvzgh",
          "priority": "high",
          "notification": {
            "title": title,
            "body": body + " " + cliente,
          },
         "data": {
            "mensajeConfirmacion": "El cliente $cliente acepto la cotizacion",
            "mensajeCliente": "Espera pronto su respuesta"
          },
          "content_available": true,
        }
      );

      http.Response response = await http.post(
        Uri.parse(url),
        body: data,
        headers: {
          'Content-Type': contentType,
          'Authorization': authorization,
        },
      );
  
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }


  }

  //metodo para enviar automaticamente notificaciones
  Future<http.Response> sendConfirmClient(to, title, body, client) async {
    try {
      final dynamic data = json.encode(
        {
          "to": to,
          "priority": "high",
          "notification": {
            "title": title,
            "body": body + " " + client,
          },
         "data": {
            "mensajeConfirmacion": "El cliente $client acepto la cotizacion",
            "mensajeCliente": "Espera pronto su respuesta"
          },
          "content_available": true,
        }
      );

      http.Response response = await http.post(
        Uri.parse(url),
        body: data,
        headers: {
          'Content-Type': contentType,
          'Authorization': authorization,
        },
      );

      return response;
    } catch (e) {
      throw Exception(e.toString());
    }


  }


  
  @override
  Future<void> subscribeToTopic({required String Topic}) {
    return messaging.subscribeToTopic(Topic);
  }

  @override
  Future<void> unsubscribeFromTopic({required String Topic}) {
    return messaging.unsubscribeFromTopic(Topic);
  }

  @override
  Future<void> sendNotificationToTaxi({
    required String Token,
    required String Title,
    required String Body,
    required String Client,
  }){
    return sendConfirmClient(
      Token,
      Title,
      Body,
      Client,
    );
  }


}
