import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/firebaseConnection.dart';
import 'package:taxi_segurito_app/strategis/firebase/interface/ITaxiServiceRequest.dart';
import 'package:taxi_segurito_app/strategis/firebase/nodeNameGallery.dart';

class TaxiServiceRequestImpl extends ITaxiServiceRequest {
  late String key;
  late final connection;

  TaxiServiceRequestImpl() {
    connection = FirebaseConnection().getConnection();
    key = FirebaseConnection().getKey(NodeNameGallery.TAXISERVICEREQUESTLIST);
  }

  @override
  Future<bool> insertNode(value) async {
    bool success = false;
    try {
      await connection
          .reference()
          .child(NodeNameGallery.TAXISERVICEREQUESTLIST)
          .child(key)
          .set(value)
          .then((_) {
        success = true;
      });
      return success;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  @override
  Future<bool> deleteNode(value) async {
    bool success = false;
    try {
      await connection
          .reference()
          .child(NodeNameGallery.TAXISERVICEREQUESTLIST)
          .child(value)
          .remove()
          .then(
        (_) async {
          success = true;
        },
      );
      return success;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  @override
  Future<bool> updateRange(ClienRequest clienRequest) async {
    bool success = false;
    try {
      await connection
          .reference()
          .child(NodeNameGallery.TAXISERVICEREQUESTLIST)
          .child(clienRequest.idFirebase)
          .update({'rangoBusqueda': clienRequest.rango}).then(
        (_) async {
          success = true;
        },
      );
      return success;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Stream<Event> getNodeEvent() {
    return connection
        .reference()
        .child(NodeNameGallery.TAXISERVICEREQUESTLIST)
        .onValue;
  }

  List<ClienRequest> convertJsonList(Event event) {
    DataSnapshot snapshot = event.snapshot;
    List<ClienRequest> listRequestPreview = [];
    final extractedData = snapshot.value;
    print(extractedData);
    if (extractedData != null)
      extractedData.forEach(
        (blogId, blogData) {
          ClienRequest clienRequest = ClienRequest.fromJson(blogData);
          listRequestPreview.add(clienRequest);
        },
      );

    for (var i = 0; i < listRequestPreview.length; i++) {
      print("Rango: " + listRequestPreview[i].numeroPasageros.toString());
    }
    return listRequestPreview;
  }

//Get data ClientRequest
  @override
  Future<ClienRequest> getNodeItem(serviceRequestId) async {
    ClienRequest clienRequest = new ClienRequest.init();
    try {
      await connection
          .reference()
          .child(NodeNameGallery.TAXISERVICEREQUESTLIST + "/$serviceRequestId")
          .once()
          .then((value) {
        DataSnapshot dataSnapshot = value;
        clienRequest = ClienRequest.fromJson(dataSnapshot.value);
      });
      return clienRequest;
    } catch (e) {
      log(e.toString());
      return clienRequest;
    }
  }

  @override
  Future<ClienRequest> getNodeItemNew() async {
    ClienRequest clienRequest = new ClienRequest.init();
    try {
      await connection.reference()
          //.child(NodeNameGallery.TAXISERVICEREQUESTLIST)
          .on(NodeNameGallery.TAXISERVICEREQUESTLIST, (value) {
        print(value);
      });
      /*.then((value) {
        DataSnapshot dataSnapshot = value;
        clienRequest = ClienRequest.fromJson(dataSnapshot.value);
      });*/
      return clienRequest;
    } catch (e) {
      log(e.toString());
      return clienRequest;
    }
  }
}
