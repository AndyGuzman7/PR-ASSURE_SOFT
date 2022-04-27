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
  late LocationData locationData;

  late double latitudTaxi;
  late double longitudTaxi;

  late Function(List<ClienRequest>) updateListRequest;

  ListRequestClientFunctionality();
  void initFirebase() {
    dbRef = FirebaseDatabase.instance.reference();
    Stream<Event> streamBuilder = dbRef.child(nameBranch).onValue;
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
      var distanciaKm =  getConvertKm(getDistance(latitudClient, longitudClient, latitudTaxi, longitudTaxi));
      double distancia = distanciaKm;

      if (distancia <= item.rango) {
        listRequest.add(item);
      }
    }
    updateListRequest(listRequest);
    for (var item in listRequest) {
      print(item.rango.toString() +
          " sfsdfsdf " +
          item.numeroPasageros.toString());
    }
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
    return locationData = await location.getLocation();
  }

  void getInstance() {
    return dbRef;
  }

  



  double getDistance(
    double startLat, double starLong, double endLat, double endLong) {
    double distance = Geolocator.distanceBetween(startLat, starLong, endLat, endLong);


    return distance;
  }

  double getConvertKm(double distanceMeters) {
    var varMeters = distanceMeters;
    var varKm = varMeters / 1000;
    var rangeDistance = double.parse((varKm).toStringAsFixed(2));
    print(varMeters);
    print(varKm);

    return rangeDistance;
  }

  bool rangeBetween(int rangeSlider) {
    bool response = true;
    double valueDistance = getDistance(52.2165157, 6.9437819, 52.3546274, 4.8285838);
    double valueRange = getConvertKm(valueDistance);
    if (valueRange <= rangeSlider) {
      return response;
    }
    return false;
  }
}
