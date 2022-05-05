import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _messageStream =
      new StreamController.broadcast();

  static String topicName = "DriverMessages";

  static Stream<String> get messageString => _messageStream.stream;

  static Future subscribeToTopic() async {
    messaging.subscribeToTopic(topicName).then((value) {
      print("Subscrito a un topic");
    });
  }

  static Future unsubscribeFromTopic() async {
    messaging.unsubscribeFromTopic(topicName).then((value) {
      print("Desuscrito de un Topic");
    });
  }

//aplicacion en reposo
  static Future _backgroundHandler(RemoteMessage message) async {
    print('background Handler ${message.data}');
    _messageStream.add(message.notification?.title ?? 'No Title');
  }

//aplicacion abierta
  static Future _onMessageHandler(RemoteMessage message) async {
    print('onMessageHandler Handler ${message.data}');

    _messageStream.add(message.notification?.title ?? 'No Title');
  }

//
  static Future _onMessageOpenApp(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title

        description:
            'This channel is used for important notifications.', // description
        importance: Importance.high,
        playSound: true);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    void showNotification() {
      flutterLocalNotificationsPlugin.show(
        0,
        "Testing",
        "How you doin ?",
        NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              channelDescription: channel.description,
              importance: Importance.high,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher'),
        ),
      );
    }

    //showNotification();

    print('onMessageOpenApp Handlers ${message.messageId}');
    _messageStream.add(message.notification?.title ?? 'No Title');
    messageString.listen((event) {
      showNotification();
    });
  }

  static Future initializedApp() async {
    //Push Notifications

    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print(token);

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static closeStreams() {
    _messageStream.close();
  }
}
