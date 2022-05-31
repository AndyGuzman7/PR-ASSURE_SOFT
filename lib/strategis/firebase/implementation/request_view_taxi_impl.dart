import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/firebaseConnection.dart';

import 'package:taxi_segurito_app/strategis/firebase/interface/ITaxiViewRequest.dart';
import 'package:taxi_segurito_app/strategis/firebase/nodeNameGallery.dart';

class RequestViewTaxiImpl extends IUserViewRequest {
  late String key;
  late final connection;

  RequestViewTaxiImpl() {
    connection = FirebaseConnection().getConnection();
    key =
        FirebaseConnection().getKey(NodeNameGallery.SERVICEREQUESTESTIMATELIST);
  }

  @override
  Stream<Event> getNodeEvent(idFirebase) {
    return connection
        .reference()
        .child(NodeNameGallery.SERVICEREQUESTESTIMATELIST)
        .child(idFirebase)
        .child('estado')
        .onValue;
  }
}
