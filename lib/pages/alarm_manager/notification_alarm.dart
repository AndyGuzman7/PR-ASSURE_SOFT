import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/pages/list_request_client/location.dart';
import 'package:taxi_segurito_app/pages/list_request_client/request_list_functionality.dart';
import 'package:taxi_segurito_app/pages/list_request_client/widgets/request_list.dart';
import 'package:taxi_segurito_app/pages/list_request_client/widgets/request_list_item.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:convert';

class Notification1 extends StatefulWidget {
  Notification1({Key? key}) : super(key: key);

  @override
  State<Notification1> createState() => _Notification1State();
}

class _Notification1State extends State<Notification1> {
  int id = 1;
  bool isOn = false;
  void initState() {
    super.initState();
    //AndroidAlarmManager.periodic(Duration(seconds: 1), id, alarmaMostrar);
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
                      AndroidAlarmManager.oneShot(Duration(seconds: 2), id, alarmaMostrar);
                      //AndroidAlarmManager.periodic(Duration(seconds: 1), id, alarmaMostrar);
                    }
                    else
                    {
                      AndroidAlarmManager.cancel(id);
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

void alarmaMostrar(){
  print("Notificacion: ${DateTime.now()}");
}

void callBackTask(){
  Workmanager().executeTask((tarea, datos) async {
    final FlutterLocalNotificationsPlugin notificacion = new FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails notificationDetails = AndroidNotificationDetails(
      'id',
      'Notificacion1',
      channelDescription: 'Notificacion ejemplo',
      importance: Importance.max,
      priority: Priority.high,
      showProgress: true,
      showWhen: false,
      
    );

    const NotificationDetails details = NotificationDetails(
      android: notificationDetails
    );

    await notificacion.show(
      0,
      'NotificacionEnvio',
      'Envio datos',
      details,
      payload: 'Item1'
    );


    return Future.value(true);

    
  });
}