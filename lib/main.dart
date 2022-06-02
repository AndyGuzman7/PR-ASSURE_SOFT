import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/SRC/providers/push_notifications_provider.dart';
import 'package:taxi_segurito_app/pages/alarm_manager/notification_alarm.dart';
import 'package:taxi_segurito_app/pages/contacList/list_contact.dart';
import 'package:taxi_segurito_app/pages/list_request_client/request_list_page.dart';
import 'package:taxi_segurito_app/pages/menu/driver_menu.dart';
import 'package:taxi_segurito_app/pages/taxi_request/taxi_request_functionality.dart';
import 'package:taxi_segurito_app/pages/vehicle_screen/vehicle_edit_screen.dart';
import 'package:taxi_segurito_app/pages/vehicle_screen/vehicle_register_screen.dart';
import 'package:taxi_segurito_app/pages/taxi_request/taxi_request.dart';
import './pages/driver_register/driver_register.dart';
import './pages/main_window/main_window.dart';
import './pages/log_in/log_in_page.dart';
import './pages/menu/admin_menu.dart';
import './pages/owner_list/owner_list_page.dart';
import './pages/scanner_qr/scanner_qr_page.dart';
import './services/sessions_service.dart';
import './pages/register/register_page_phone.dart';
import './pages/driver_list/drivers_list_page.dart';
import './pages/owner_register/owner_register.dart';
import './pages/menu/owner_menu.dart';
import './pages/company_list/company_list_page.dart';
import './pages/company_screen/company_register_screen.dart';
import './pages/vehiclesList/VehiclesListPage.dart';
import './pages/historyReview/HistoryReview.dart';
import './models/vehicle.dart';
import './models/providers/HttpProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:workmanager/workmanager.dart';
import 'package:taxi_segurito_app/services/notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  
  {

  //configuraciones para las notificaciones
  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings settings = AndroidInitializationSettings('@mipmap/ic_launcher');
  final IOSInitializationSettings iosSettings = IOSInitializationSettings();
  final MacOSInitializationSettings macSettings = MacOSInitializationSettings();
  final InitializationSettings initialization = InitializationSettings(
    android: settings,
    iOS: iosSettings,
    macOS: macSettings
    
  );

  await plugin.initialize(
    initialization,
    onSelectNotification: selectNotification
  );

  Workmanager().initialize(
    callBackTask,
    isInDebugMode: true,
    
  );

  Workmanager().registerPeriodicTask(
    "1",
    "Key",
    frequency: Duration(minutes: 10),
    
  );
  }

  AndroidAlarmManager.initialize();
  AndroidAlarmManager.periodic(
    Duration(seconds: 5), 
    1, 
    notificacion, 
    exact: true, 
    wakeup: true, 
    rescheduleOnReboot: true,
  );

  HttpOverrides.global = new HttpProvider();
  SessionsService sessions = SessionsService();
  bool idsession = await sessions.verificationSession('id');
  bool rolsession = await sessions.verificationSession('role');
  Widget app = AppTaxiSegurito('firstScreen');
  if (idsession && rolsession) {
    final rol = await sessions.getSessionValue('role');
    final name = await sessions.getSessionValue('name');
    switch (rol.toString()) {
      case 'admin':
        PushNotificationService.unsubscribeFromTopic();
        app = AppTaxiSegurito('adminMenu', sessionName: name);

        break;
      case 'owner':
        PushNotificationService.unsubscribeFromTopic();
        app = AppTaxiSegurito('ownerMenu', sessionName: name);
        break;
      case 'driver':
        PushNotificationService.subscribeToTopic();
        app = AppTaxiSegurito('driverMenu', sessionName: name);
        break;
      default:
        PushNotificationService.unsubscribeFromTopic();
        app = AppTaxiSegurito('scannerQr', sessionName: name);
        break;
    }
  }
  runApp(app);
}

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

void notificacion() async {
  print("Alarma: ${DateTime.now()}");
  final FlutterLocalNotificationsPlugin notificacion = FlutterLocalNotificationsPlugin();

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
        1,
        'Simulacion',
        'Es una simulacion con android alert manager',
        details,
        payload: 'Item1'
      );
}

//envio de notificacion
Future selectNotification(payload) async {
  if (payload!=null){
    debugPrint("Notificacion: $payload");
    print("Notificacion Envio: ${DateTime.now()}");
  }
}

//metodo para enviar notificaciones mediante workmanager
void callBackTask(){
  Workmanager().executeTask((tarea, datos) async {
    if(tarea=="Key")
    {
      final FlutterLocalNotificationsPlugin notificacion = FlutterLocalNotificationsPlugin();

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
        1,
        'Envio Simulacion',
        'Es una simulacion work manager',
        details,
        payload: 'Item1'
      );
    }
    return Future.value(true);
    
  });
}

class AppTaxiSegurito extends StatefulWidget {
  final String initialRoute;
  final String? sessionName;
  AppTaxiSegurito(this.initialRoute, {this.sessionName});
  @override
  _AppTaxiSeguritoState createState() =>
      _AppTaxiSeguritoState(initialRoute, sessionName: this.sessionName);
}

class _AppTaxiSeguritoState extends State<AppTaxiSegurito> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();


    PushNotificationService.initializedApp();
    PushNotificationService.subscribeToTopic();

    PushNotificationService.messageString.listen((event) {
      print("object");
      //showNotification();
    });
  }

  String routeInitial;
  String? sessionName;
  _AppTaxiSeguritoState(this.routeInitial, {this.sessionName});
  @override
  Widget build(BuildContext context) {
    Uint8List image = base64Decode(
        "iVBORw0KGgoAAAANSUhEUgAAAJYAAADICAQAAACgjNDuAAAAAmJLR0QA/4ePzL8AAAAJcEhZcwAACxMAAAsTAQCanBgAAAFqSURBVHja7dgxSxthHMfxX60x0NBCpywKFizSoTg2S8HBqVMnRxfxTfgm+g7a1U06OEiHDh2KUDq0dOgcMYiLcXDQhnM405LU5DY59PN5xnuG48txz58nAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAO6kBzV7n5k8zXye5CK99HIp1iSzWclGOlm4jvUru9nLmS/6f61s5zDFyDrPTl5IM66R7ZyPpSrXpyzKM2or/RtTFSnyPo8E+udZfk5MVeQsb+py+tRBZ+qf6XHeZlas4Yn8Kg+n7nidebFKc1mq2NFOW6zhl9WsPCsbYpUGOa7Y0U9frNJlvlfs+J2uWENfczLlaZGPOTVfDTXzYcqc9aPyALhnlvJ5QqqTrMsz7mW+3JDqKJv1GEjr5nnepZvB31Cn2c9axbh6yzNOve4elrOahbTyJ8c5yDe3WQAAAAAAAAAAAAAAAAAjrgA9sX9RB69GsAAAAEl0RVh0Y29tbWVudABGaWxlIHNvdXJjZTogaHR0cDovL2NvbW1vbnMud2lraW1lZGlhLm9yZy93aWtpL0ZpbGU6RnVsbF9zdG9wLnBuZ/hCj5kAAAAldEVYdGRhdGU6Y3JlYXRlADIwMTQtMTItMDRUMjM6MzY6MDQrMDA6MDDfLSfJAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDE0LTEyLTA0VDIzOjM2OjA0KzAwOjAwrnCfdQAAAEZ0RVh0c29mdHdhcmUASW1hZ2VNYWdpY2sgNi42LjktNyAyMDE0LTAzLTA2IFExNiBodHRwOi8vd3d3LmltYWdlbWFnaWNrLm9yZ4HTs8MAAAAYdEVYdFRodW1iOjpEb2N1bWVudDo6UGFnZXMAMaf/uy8AAAAYdEVYdFRodW1iOjpJbWFnZTo6aGVpZ2h0ADY0MFHve2EAAAAXdEVYdFRodW1iOjpJbWFnZTo6V2lkdGgANDgwInKzjgAAABl0RVh0VGh1bWI6Ok1pbWV0eXBlAGltYWdlL3BuZz+yVk4AAAAXdEVYdFRodW1iOjpNVGltZQAxNDE3NzM2MTY0Cs916QAAABN0RVh0VGh1bWI6OlNpemUAMi4xM0tCQmpcHHIAAAAzdEVYdFRodW1iOjpVUkkAZmlsZTovLy90bXAvbG9jYWxjb3B5XzE3NTRiNzYyNmU2MC0xLnBuZ1oV86IAAAAASUVORK5CYII=");
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: "Taxi Segurito",
      theme: ThemeData(primarySwatch: Colors.amber),
      debugShowCheckedModeBanner: false,
      initialRoute: 'Notification1',
      routes: {
        'loginUser': (_) => UserLoginPage(),
        'Notification1': (_) => Notification1(),
        'listRequestClient': (_) => ListRequestClient(),
        'serviceFormMap': (_) => ServiceFormMap(),
        'registerScreen': (_) => RegisterPage(),
        'firstScreen': (_) => MainWindow(),
        'scannerQr': (_) => ScannerQrPage(name: this.sessionName),
        'ownerMenu': (_) => OwnerMenu(name: this.sessionName),
        'adminMenu': (_) => AdminMenu(name: this.sessionName),
        'driverMenu': (_) => DriverMenu(name: this.sessionName),
        'driverList': (_) => DriversListPage(),
        'registerCompany': (_) => CompanyRegisterScreen(),
        'companyList': (_) => CompanyListPage(),
        'vehicleList': (_) => VehiclesListPage(),
        'historyReview': (_) => HistoryReview(),
        'userList': (_) => OwnerListPage(),
        'registerDriver': (_) => DriverRegister(),
        'registerOwner': (_) => RegisterOwner(),
        'registerVehicle': (_) => VehicleRegisterScreen(),
        'listContact': (_) => ContactList(),
        'updateVehicleScreen': (BuildContext contextss) => VehicleEditScreen(
              Vehicle(
                idVehicle: 1,
                capacity: 1,
                color: "rojo con franjas verdes",
                model: "Lamborginy",
                pleik: "sdasd",
                picture: image,
                status: 1,
                idOwner: 1,
              ),
            ),
      },
    );
  }
}
