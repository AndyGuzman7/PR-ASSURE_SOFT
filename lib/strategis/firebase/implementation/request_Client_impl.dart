import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/firebaseConnection.dart';
import 'package:taxi_segurito_app/strategis/firebase/interface/IRequest.dart';
import 'package:taxi_segurito_app/strategis/firebase/nodeNameGallery.dart';

class RequestClientImpl implements IRequest {
  late String key;
  late final connection;

  RequestClientImpl() {
    connection = FirebaseConnection().getConnection();
    key = FirebaseConnection().getKey(NodeNameGallery.REQUESTCLIENT);
  }

  @override
  bool insertNode(value) {
    bool success = false;
    try {
      connection
          .reference()
          .child(NodeNameGallery.REQUESTCLIENT)
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
}
