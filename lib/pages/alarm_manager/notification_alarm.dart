import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/pages/list_request_client/location.dart';
import 'package:taxi_segurito_app/pages/list_request_client/request_list_functionality.dart';
import 'package:taxi_segurito_app/pages/list_request_client/widgets/request_list.dart';
import 'package:taxi_segurito_app/pages/list_request_client/widgets/request_list_item.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:taxi_segurito_app/services/notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:convert';

import '../../models/client_user.dart';

class Notification1 extends StatefulWidget {
  Notification1({Key? key}) : super(key: key);

  @override
  State<Notification1> createState() => _Notification1State();
}

class _Notification1State extends State<Notification1> {
  bool isOn = false;
  final NotificationsFirebase notificationsFirebase = new NotificationsFirebase();
  late Clientuser client;
  void initState() {
    super.initState();

    notificationsFirebase.subscribeToTopic(Topic: 'ConfirmEstimate');

  }

  
  @override
  Widget build(BuildContext context) {
    
    Text title = new Text(
      "Alarma",
      style: const TextStyle(
          fontSize: 25.0, color: Colors.black, fontWeight: FontWeight.w700),
      textAlign: TextAlign.left,
    );

    AppBar appbar = new AppBar(
      foregroundColor: Colors.white,
      elevation: 0,
      title: Container(
        alignment: Alignment.center,
        child: Text(
          "Servicios de Taxi",
          style: TextStyle(),
        ),
      ),
    );
    return Scaffold(
      appBar: appbar,

      body: Container(
        color: Color.fromARGB(255, 248, 248, 248),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            title,
            Expanded(
              child: Container(
                child: Switch(
                  value: isOn,
                  onChanged: (value){
                    setState(() {
                      isOn = value;
                    });
                    if(isOn==true)
                    {
                     String title = "Cotizacion aceptada";
                      String body = "La cotizacion se acepto";
                      String token = "e53nf4hyRVGCGbJ9-1wIrP:APA91bH8JqmbIBng_R4xh68yJgO3GUM5LVTEq75afZwE-MU5CCjC604UNmwAWhwoBwWx5m2st3ZdGQ_G6sXVP_fRf-fFTnwVg0a-iNX6HwIdLEIWizsVkVik_PabugvdbaihZSDLvzgh";
                      String client = "Marco Aurelio";
                      notificationsFirebase.sendNotificationToTaxi(Token: token, Title: title, Body: body, Client: client);
                      //sendNotification();
                      //callBackTask();
                      //AndroidAlarmManager.oneShot(Duration(seconds: 2), id, alarmaMostrar);                    
                    }
                    else
                    {
                      //AndroidAlarmManager.cancel(id);
                    }
                    
                  }

                )
              ),
              
            ),
          ],
        ),
      ),
    );
  }
}


sendNotification() {

  String title = "Cotizacion aceptada";
  String body = "La cotizacion se acepto";
  NotificationsFirebase notificationClient = new NotificationsFirebase();
  notificationClient.confirmClient("Lucky luciano", title, body);
}


void callBackTask(){
  {
    final FlutterLocalNotificationsPlugin notificacion = new FlutterLocalNotificationsPlugin();
    int id = 0;
    String title = "Cotizacion aceptada";
    String body = "La cotizacion se acepto";
    //NotificationsFirebase notificationClient = new NotificationsFirebase();
    //notificationClient.confirmClient("Lucky luciano", title, body);
    const AndroidNotificationDetails notificationDetails = AndroidNotificationDetails(
      'id',
      'channel1',
      channelDescription: 'Notificacion ejemplo',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: false,
      color: Colors.amberAccent,
      showProgress: true,
      showWhen: false,
      
    );

    const NotificationDetails details = NotificationDetails(
      android: notificationDetails
    );

    notificacion.show(
      id++,
      title,
      body,
      details,
      payload: sendNotification()
    );
  }

}