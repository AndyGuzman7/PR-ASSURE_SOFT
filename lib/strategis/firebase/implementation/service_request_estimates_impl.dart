import 'dart:developer';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:taxi_segurito_app/models/estimate_taxi.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/firebaseConnection.dart';

import 'package:taxi_segurito_app/strategis/firebase/interface/IServiceRequestEstimates.dart';
import 'package:taxi_segurito_app/strategis/firebase/nodeNameGallery.dart';

class ServiceRequestEstimatesImpl extends IServiceRequestEstimates {
  late String key;
  late final connection;

  ServiceRequestEstimatesImpl() {
    connection = FirebaseConnection().getConnection();
    key =
        FirebaseConnection().getKey(NodeNameGallery.SERVICEREQUESTESTIMATELIST);
  }

  @override
  Future<bool> insertNode(value) async {
    bool success = false;
    try {
      await connection
          .reference()
          .child(NodeNameGallery.SERVICEREQUESTESTIMATELIST)
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
  Stream<Event> getNodeEvent() {
    return connection
        .reference()
        .child(NodeNameGallery.SERVICEREQUESTESTIMATELIST)
        .onValue;
  }

  List<EstimateTaxi> convertJsonList(Event event) {
    DataSnapshot snapshot = event.snapshot;
    List<EstimateTaxi> listEstimates = [];
    final extractedData = snapshot.value;
    if (extractedData != null)
      extractedData.forEach(
        (blogId, blogData) {
          EstimateTaxi clienRequest = EstimateTaxi.fromJson(blogData);
          listEstimates.add(clienRequest);
        },
      );
    return listEstimates;
  }

  @override
  Stream<Event> getConfirmationEvent(idFirebase) {
    return connection
        .reference()
        .child(NodeNameGallery.SERVICEREQUESTESTIMATELIST)
        .child(idFirebase)
        .child('estado')
        .onValue;
  }

  @override
  Future<bool> updateStatus(value, motivo, status) async {
    bool success = false;
    try {
      await connection
          .reference()
          .child(NodeNameGallery.SERVICEREQUESTESTIMATELIST)
          .child(value)
          .update({'estado': status, 'motivoCancelacion': motivo}).then(
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
}
