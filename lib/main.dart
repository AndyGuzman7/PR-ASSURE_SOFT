import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/SRC/providers/push_notifications_provider.dart';
import 'package:taxi_segurito_app/models/estimate_taxi.dart';
import 'package:taxi_segurito_app/models/service_taxi.dart';
import 'package:taxi_segurito_app/pages/contacList/list_contact.dart';
import 'package:taxi_segurito_app/pages/menu/driver_menu.dart';
import 'package:taxi_segurito_app/pages/menu/menu_client.dart';
import 'package:taxi_segurito_app/pages/v2_location_taxi/v2_receive_location/receive_location_driver.dart';
import 'package:taxi_segurito_app/pages/v2_client_service_request_information/client_service_request_information_page.dart';
import 'package:taxi_segurito_app/pages/v2_location_taxi/v2_send_my_location/send_my_location.dart';

import 'package:taxi_segurito_app/pages/v2_taxi_request/taxi_request_page.dart';
import 'package:taxi_segurito_app/pages/v2_taxi_service_request_list/taxi_service_request_list_page.dart';
import 'package:taxi_segurito_app/pages/v2_taxi_services_estimate_list/taxi_services_estimate_list_page.dart';

import 'package:taxi_segurito_app/pages/vehicle_screen/vehicle_edit_screen.dart';
import 'package:taxi_segurito_app/pages/vehicle_screen/vehicle_register_screen.dart';
import 'package:taxi_segurito_app/strategis/firebase/nameGalleryStateTaxi.dart';
import 'package:workmanager/workmanager.dart';

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
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'strategis/firebase/implementation/request_taxi_impl.dart';
import 'strategis/firebase/implementation/taxi_impl.dart';

//metodo para el envio de notificaciones de firebase en segundo plano
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);
  id = message.messageId;
  key = message.collapseKey;
  flutterLocalNotificationsPlugin.show(
    message.data.hashCode,
    message.data['notificaction']['title'],
    message.data['notificaction']['body'],
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.high,
        playSound: true,
        enableVibration: false,
        color: Colors.amberAccent,
      ),
    ),
    payload: message.data['notificaction']['body'],
  );
}

//configuracion para el envio del mensaje
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
String? id;
String? key;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //metodo para las tareas de sgundo plano
  taskWorkManager();
  //metodo para enviar notificaciones en segundo plano
  //enviar notificaciones desde firebase
  /*FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);*/

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
        app = AppTaxiSegurito('adminMenu', sessionName: name);
        break;
      case 'owner':
        app = AppTaxiSegurito('ownerMenu', sessionName: name);
        break;
      case 'driver':
        app = AppTaxiSegurito('driverMenu', sessionName: name);
        SessionsService sessionsService = new SessionsService();
        int id = int.parse(await sessionsService.getSessionValue("id"));
        TaxiImpl taxiImpl = new TaxiImpl();
        ServiceTaxi serviceTaxi =
            new ServiceTaxi(NameGalleryStateTaxi.DISPONIBLE, 0.0, 0.0);
        taxiImpl.sendStatusTaxi(id, serviceTaxi);
        break;
      default:
        app = AppTaxiSegurito('clientMenu', sessionName: name);
        break;
    }
  }
  runApp(app);
}

//metodo para mostrar notificaciones en segundo plano
taskWorkManager() async {
  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings settings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final IOSInitializationSettings iosSettings = IOSInitializationSettings();
  final MacOSInitializationSettings macSettings = MacOSInitializationSettings();
  final InitializationSettings initialization = InitializationSettings(
      android: settings, iOS: iosSettings, macOS: macSettings);

  await plugin.initialize(initialization,
      onSelectNotification: selectNotification);

  Workmanager().initialize(
    callBackTask,
    isInDebugMode: true,
  );

  Workmanager().registerPeriodicTask(
    id.toString(),
    key.toString(),
    frequency: Duration(minutes: 10),
    initialDelay: Duration(seconds: 5),
  );
}

//metodo para enviar notificaciones mediante workmanager
void callBackTask() {
  Workmanager().executeTask((tarea, datos) async {
    final RemoteMessage message = RemoteMessage();
    if (tarea == key) {
      _firebaseMessagingBackgroundHandler(message);
    }
    return Future.value(true);
  });
}

showConfirmNotification() {
  //configuraciones para los permisos del dispositivo
  var initialzationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
      InitializationSettings(android: initialzationSettingsAndroid);
  //configuracion para mostrar la notificacion
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon,
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: false,
            color: Colors.amberAccent,
          ),
        ),
        payload: notification.body,
      );
    }
  });
}

//envio de notificacion
Future selectNotification(payload) async {
  if (payload != null) {
    debugPrint("Notificacion: $payload");
    print("Notificacion Envio: ${DateTime.now()}" + " " + payload);
  }
}


class AppTaxiSegurito extends StatefulWidget {
  final String initialRoute;
  final String? sessionName;
  AppTaxiSegurito(this.initialRoute, {this.sessionName});
  @override
  _AppTaxiSeguritoState createState() =>
      _AppTaxiSeguritoState(initialRoute, sessionName: this.sessionName);
}

EstimateTaxi? driverRequest;

class _AppTaxiSeguritoState extends State<AppTaxiSegurito> {
  @override
  void initState() {
    super.initState();
    PushNotificationService.getToken();
    showConfirmNotification();
  }

  String routeInitial;
  String? sessionName;
  _AppTaxiSeguritoState(this.routeInitial, {this.sessionName});
  @override
  Widget build(BuildContext context) {
    Uint8List image = base64Decode(
        "iVBORw0KGgoAAAANSUhEUgAAAJYAAADICAQAAACgjNDuAAAAAmJLR0QA/4ePzL8AAAAJcEhZcwAACxMAAAsTAQCanBgAAAFqSURBVHja7dgxSxthHMfxX60x0NBCpywKFizSoTg2S8HBqVMnRxfxTfgm+g7a1U06OEiHDh2KUDq0dOgcMYiLcXDQhnM405LU5DY59PN5xnuG48txz58nAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAO6kBzV7n5k8zXye5CK99HIp1iSzWclGOlm4jvUru9nLmS/6f61s5zDFyDrPTl5IM66R7ZyPpSrXpyzKM2or/RtTFSnyPo8E+udZfk5MVeQsb+py+tRBZ+qf6XHeZlas4Yn8Kg+n7nidebFKc1mq2NFOW6zhl9WsPCsbYpUGOa7Y0U9frNJlvlfs+J2uWENfczLlaZGPOTVfDTXzYcqc9aPyALhnlvJ5QqqTrMsz7mW+3JDqKJv1GEjr5nnepZvB31Cn2c9axbh6yzNOve4elrOahbTyJ8c5yDe3WQAAAAAAAAAAAAAAAAAjrgA9sX9RB69GsAAAAEl0RVh0Y29tbWVudABGaWxlIHNvdXJjZTogaHR0cDovL2NvbW1vbnMud2lraW1lZGlhLm9yZy93aWtpL0ZpbGU6RnVsbF9zdG9wLnBuZ/hCj5kAAAAldEVYdGRhdGU6Y3JlYXRlADIwMTQtMTItMDRUMjM6MzY6MDQrMDA6MDDfLSfJAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDE0LTEyLTA0VDIzOjM2OjA0KzAwOjAwrnCfdQAAAEZ0RVh0c29mdHdhcmUASW1hZ2VNYWdpY2sgNi42LjktNyAyMDE0LTAzLTA2IFExNiBodHRwOi8vd3d3LmltYWdlbWFnaWNrLm9yZ4HTs8MAAAAYdEVYdFRodW1iOjpEb2N1bWVudDo6UGFnZXMAMaf/uy8AAAAYdEVYdFRodW1iOjpJbWFnZTo6aGVpZ2h0ADY0MFHve2EAAAAXdEVYdFRodW1iOjpJbWFnZTo6V2lkdGgANDgwInKzjgAAABl0RVh0VGh1bWI6Ok1pbWV0eXBlAGltYWdlL3BuZz+yVk4AAAAXdEVYdFRodW1iOjpNVGltZQAxNDE3NzM2MTY0Cs916QAAABN0RVh0VGh1bWI6OlNpemUAMi4xM0tCQmpcHHIAAAAzdEVYdFRodW1iOjpVUkkAZmlsZTovLy90bXAvbG9jYWxjb3B5XzE3NTRiNzYyNmU2MC0xLnBuZ1oV86IAAAAASUVORK5CYII=");
    return MaterialApp(
      title: "Taxi Segurito",
      theme: ThemeData(primarySwatch: Colors.amber),
      debugShowCheckedModeBanner: false,

      initialRoute: 'taxiServicesEstimateListPage',
      //home: ReceiveLocationDriver(),
      routes: {
        'sendMyUbication': (_) => SendMyUbication(),
        'taxiServicesEstimateListPage': (BuildContext contextss) =>
            TaxiServicesEstimateListPage(
                idRequestService: "-N1vLO9946XQ4MXqRkys"),
        'loginUser': (_) => UserLoginPage(),
        'listRequestClient': (_) => TaxiServiceRequestListPage(),
        'taxiRequestScreen': (_) => TaxiRequestPage(),
        'registerScreen': (_) => RegisterPage(),
        'viewRequestInfo': (_) => ClientServiceRequestInformationPage(
              serviceRequestId: "-N1oqGSf7jtxDr7DEnjy",
            ),
        'firstScreen': (_) => MainWindow(),
        'scannerQr': (_) => ScannerQrPage(name: this.sessionName),
        'ownerMenu': (_) => OwnerMenu(name: this.sessionName),
        'clientMenu': (_) => ClientMenu(name: this.sessionName),
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
