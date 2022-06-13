import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/pages/v2_taxi_services_estimate_list/taxi_services_estimate_list_page.dart';
import 'package:taxi_segurito_app/services/notifications.dart';
import 'package:taxi_segurito_app/services/sessions_service.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/taxi_service_request_impl.dart';

class TaxiRequestFunctionality {
  late final nameBranch = "Request";
  late String key;
  late final dbRef;
  late Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late NotificationsFirebase notificationsFirebase =
      new NotificationsFirebase();
  late BuildContext context;
  var idUser;
  Function(String)? updateData;
  SessionsService sessionsService = new SessionsService();

  TaxiRequestFunctionality() {
    initFirebase();
  }
  void initFirebase() {
    dbRef = FirebaseDatabase.instance.reference();
  }

  void update(value) {
    updateData!(value);
  }

  Future<void> getIdSessionIdTaxi() async {
    idUser = await sessionsService.getSessionValue("id");
    print(idUser);
  }

  Future<void> insertNodeTaxiRequest(ClienRequest clienRequest) async {
    TaxiServiceRequestImpl taxiServiceRequestImpl =
        new TaxiServiceRequestImpl();

    idUser = await sessionsService.getSessionValue('id');
    clienRequest.idFirebase = taxiServiceRequestImpl.key;
    clienRequest.idUser = int.parse(idUser);
    taxiServiceRequestImpl.insertNode(clienRequest.toJson()).then((value) {
      if (value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaxiServicesEstimateListPage(
              idRequestService: taxiServiceRequestImpl.key,
            ),
          ),
        );
      } else
        print("No se envio");
    });
  }

  Future<void> sendRequest(ClienRequest clienRequest) async {
    key = dbRef.reference().child(nameBranch).push().key.toString();
    clienRequest.idFirebase = key;
    dbRef
        .reference()
        .child(nameBranch)
        .child(key)
        .set(clienRequest.toJson())
        .then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaxiServicesEstimateListPage(
            idRequestService: key,
          ),
        ),
      );
    });

    print(key);
    LatLng latLng =
        new LatLng(clienRequest.latitudOrigen, clienRequest.longitudOrigen);
    notificationsFirebase.sendNotification(latLng);
  }

  Future<void> updateRequestRange(ClienRequest clienRequest) async {
    dbRef
        .reference()
        .child(nameBranch)
        .child(clienRequest.idFirebase)
        .update({'rango': clienRequest.rango});
  }

  //Delete request

  Future<void> initUbicacion() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  void getInstance() {
    return dbRef;
  }
}
