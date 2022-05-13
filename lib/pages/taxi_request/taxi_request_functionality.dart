import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/services/notifications.dart';

import '../list_request_driver/list_request_driver.dart';

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
  Function(String)? updateData;

  TaxiRequestFunctionality();
  void initFirebase() {
    dbRef = FirebaseDatabase.instance.reference();
  }

  void update(value) {
    updateData!(value);
  }

  Future<void> sendRequest(ClienRequest clienRequest) async {
    key = dbRef.reference().child(nameBranch).push().key.toString();
    clienRequest.iduserFirebase = key;
    dbRef
        .reference()
        .child(nameBranch)
        .child(key)
        .set(clienRequest.toJson())
        .then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListRequestDriver(
            idRequest: key,
          ),
        ),
      );
    });

    print(key);
    LatLng latLng =
        new LatLng(clienRequest.latitudOrigen, clienRequest.longitudOrigen);
    notificationsFirebase.sendNotification(latLng);
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
