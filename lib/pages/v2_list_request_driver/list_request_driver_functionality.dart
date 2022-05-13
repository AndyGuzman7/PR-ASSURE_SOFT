import 'package:flutter/cupertino.dart';
import 'package:taxi_segurito_app/models/driver.dart';
import 'package:taxi_segurito_app/models/driver_request.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:location/location.dart';
import 'package:taxi_segurito_app/pages/v2_list_request_client/list_request_client_functionality.dart';
import 'package:taxi_segurito_app/services/driver_service.dart';

class ListRequestDriverFunctionality {
  List<DriverRequest> listDriverReq = [];
  late BuildContext context;
  late final nameBranch = "RequestTaxi";

  late double latitudClient;
  late double longitudClient;
  late String placaTaxi;
  late String imagenTaxi;
  late double estimacion;
  late Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  ListRequestClientFunctionality clientFunctionality =
      ListRequestClientFunctionality();
  late Function(List<DriverRequest>) updateListRequest;
  DriversService _driversService = DriversService();
  late Future<List<Driver>> drivers;

  late final dbRef;

  Function(String)? updateData;

  void initFirebase() {
    print("dasdasd" + latitudClient.toString());
    dbRef = FirebaseDatabase.instance.reference();
    Stream<Event> streamBuilder = dbRef.child("RequestTaxi").onValue;
    streamBuilder.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      getItemsFirebase(snapshot);
    });
  }

  void getItemsFirebase(DataSnapshot snapshot) {
    listDriverReq = [];
    List<DriverRequest> list = [];
    print(snapshot.value);
    final request = snapshot.value;
    if (request != null) {
      request.forEach((blogId, blogData) {
        print(DriverRequest.fromJson(blogData).rango);
        DriverRequest driverRequest = DriverRequest.fromJson(blogData);
        print(driverRequest.rango.toString() + "a");
        list.add(driverRequest);
      });
    }

    for (DriverRequest item in list) {
      double latitudTaxi = item.latitud;
      double longitudTaxi = item.longitud;
      estimacion = item.estimacion;

      double distance = clientFunctionality.getConvertKm(
          clientFunctionality.getDistance(
              latitudTaxi, longitudTaxi, latitudClient, longitudClient));
      item.distancia = distance;
      if (item.idRequestUserFirebase == '-N19THZozQ9wurM6uzdF') {
        listDriverReq.add(item);
      }
    }
    updateListRequest(listDriverReq);

    for (var item in listDriverReq) {
      print('object');
      print(item.rango.toString() +
          " " +
          item.latitud.toString() +
          " " +
          item.longitud.toString());
    }
  }

  Future<void> sendRequest(DriverRequest driverRequest) async {
    dbRef.reference().child(nameBranch).push().set(driverRequest.toJson());
  }

  Stream<Event> getEvent() {
    return dbRef.child(nameBranch).onValue;
  }

  Future<bool> initUbication() async {
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

  void Update(value) {
    updateData!(value);
  }

  Future<LocationData> getUbication() async {
    _locationData = await location.getLocation();
    print(_locationData.toString() + "AAA");
    return _locationData;
  }

  Future<void> deleteRequest(String idRequest) async {
    String nameBranchRequest = "Request";
    String key = idRequest;
    dbRef.reference().child(nameBranchRequest).child(key);
    DatabaseReference nodeToRemove =
        dbRef.reference().child(nameBranchRequest).child(key);
    nodeToRemove.remove();

    var clienRequest = (await FirebaseDatabase.instance
            .reference()
            .child("Request/$key")
            .once())
        .value;

    if (clienRequest == null)
      Navigator.pushNamed(context, 'serviceFormMap');
    else
      print("existe");
  }

  initServiceRequest() {
    getUbication().then((value) {
      latitudClient = value.latitude!;
      longitudClient = value.longitude!;
      print(value.latitude);
      initFirebase();
    });
  }

  void getInstance() {
    return dbRef;
  }
}
