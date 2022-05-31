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
  late NotificationsFirebase notificationsFirebase;
  late Clientuser client;
  void initState() {
    super.initState();
    notificationsFirebase = new NotificationsFirebase();
    //AndroidAlarmManager.periodic(Duration(seconds: 1), id, alarmaMostrar);
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }
  
  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      Navigator.pushNamed(context, '/chat', 
        
      );
    }
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
                      sendNotification();
                      callBackTask();
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

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void notificationClient() {
  AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title

        description:
            'This channel is used for important notifications.', // description
        importance: Importance.high,
        playSound: true
  );
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification?.title,
        notification?.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
              channel.id, 
              channel.name,
              channelDescription: channel.description,
              importance: Importance.high,
              color: Colors.blue,
              playSound: true,
              showWhen: false,
              showProgress: true,
              icon: android?.smallIcon,
            ),
        ),
      );
    });
}


void callBackTask(){
  {
    final FlutterLocalNotificationsPlugin notificacion = new FlutterLocalNotificationsPlugin();
    int id = 0;
    String title = "Cotizacion aceptada";
    String body = "La cotizacion se acepto";
    NotificationsFirebase notificationClient = new NotificationsFirebase();
    notificationClient.confirmClient("Lucky luciano", title, body);
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