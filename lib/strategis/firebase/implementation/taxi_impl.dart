import 'dart:developer';

import 'package:taxi_segurito_app/strategis/firebase/implementation/firebaseConnection.dart';
import 'package:taxi_segurito_app/strategis/firebase/interface/ITaxi.dart';
import 'package:taxi_segurito_app/strategis/firebase/nodeNameGallery.dart';

class TaxiImpl extends ITaxi {
  late String key;
  late final connection;

  TaxiImpl() {
    connection = FirebaseConnection().getConnection();
    key = FirebaseConnection().getKey(NodeNameGallery.TAXI);
  }

  @override
  Future<bool> updateStatusTaxi(value, status) async {
    bool success = false;
    try {
      await connection
          .reference()
          .child(NodeNameGallery.TAXI)
          .child(value)
          .update({'estado': status}).then(
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
