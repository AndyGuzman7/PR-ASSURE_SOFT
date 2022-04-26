import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/models/client_request.dart';

class ListRequestClientFunctionality {
  List<ClienRequest> listRequest = [];
  late final nameBranch = "Request";
  late final dbRef;
  late Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  late double latitudTaxi;
  late double longitudTaxi;

  Function(String)? updateData;

  ListRequestClientFunctionality();
  void initFirebase() {
    print("dasdasd" + latitudTaxi.toString());
    dbRef = FirebaseDatabase.instance.reference();
    Stream<Event> streamBuilder = dbRef.child("Request").onValue;
    streamBuilder.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      getItemsFirebase(snapshot);
    });
  }

  getItemsFirebase(DataSnapshot snapshot) {
    listRequest = [];
    List<ClienRequest> listRequestPreview = [];

    final extractedData = snapshot.value;
    if (extractedData != null)
      extractedData.forEach(
        (blogId, blogData) {
          ClienRequest clienRequest = ClienRequest.fromJson(blogData);
          listRequestPreview.add(clienRequest);
        },
      );

    for (ClienRequest item in listRequestPreview) {
      double latitudClient = item.latitudOrigen;
      double longitudClient = item.longitudOrigen;

      double distancia =
          getDistance(latitudClient, longitudClient, latitudTaxi, longitudTaxi);

      if (distancia < 1000 * item.rango) {
        listRequest.add(item);
      }
    }

    for (var item in listRequest) {
      print(item.rango.toString() +
          " sfsdfsdf" +
          item.numeroPasageros.toString());
    }
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

  Future<bool> initUbicacion() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  initServiceRequest() {
    getUbication().then((value) {
      latitudTaxi = value.latitude!;
      longitudTaxi = value.longitude!;
      initFirebase();
    });
  }

  Future<LocationData> getUbication() async {
    return _locationData = await location.getLocation();
    //print(_locationData.latitude);
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
