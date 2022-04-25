import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/models/client_request.dart';

class TaxiRequestFunctionality {
  late final nameBranch = "Request";
  late final dbRef;
  late Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  Function(String)? updateData;

  TaxiRequestFunctionality();
  void initFirebase() {
    dbRef = FirebaseDatabase.instance.reference();
    Stream<Event> streamBuilder = dbRef.child("Request").onValue;
    streamBuilder.listen((event) {
      DataSnapshot d = event.snapshot;
      final extractedData = d.value;
      late List<int> lista = [];
      extractedData.forEach((blogId, blogData) {
        lista.add(blogData["rango"]);
      });

      for (var item in lista) {
        print(item);
      }
    });
  }

  void update(value) {
    updateData!(value);
  }

  Future<void> sendRequest(ClienRequest clienRequest) async {
    dbRef.reference().child(nameBranch).push().set(clienRequest.toJson());
  }

  Stream<Event> getEvent() {
    return dbRef.child(nameBranch).onValue;
  }

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

    _locationData = await location.getLocation();

    print(_locationData.latitude);
  }

  void getInstance() {
    return dbRef;
  }

  //formula para calcular distancias de dos ubicaciones
  double getDistance(
      double startLat, double starLong, double endLat, double endLong) {
    //la distancia calculada es en metros
    double distance =
        Geolocator.distanceBetween(startLat, starLong, endLat, endLong);
    //distance = Geolocator.distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);
    return distance;
  }

  double getConvertKm(double distanceMeters) {
    double varMeters = distanceMeters;
    double varKm = varMeters / 1000;
    double rangeDistance = double.parse((varKm).toStringAsFixed(2));
    print(varMeters);
    print(varKm);
    print(rangeDistance);
    return rangeDistance;
  }

  bool rangeBetween(int rangeSlider) {
    var response = true;
    var valueDistance =
        getDistance(52.2165157, 6.9437819, 52.3546274, 4.8285838);
    var valueRange = getConvertKm(valueDistance);
    if (valueRange <= rangeSlider) {
      return response;
    }
    return false;
  }
}
