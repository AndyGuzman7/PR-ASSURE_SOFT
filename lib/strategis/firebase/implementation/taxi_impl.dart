import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/models/service_taxi.dart';
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

  @override
  Future<bool> sendStatusTaxi(int idTaxi, ServiceTaxi serviceTaxi) async {
    bool success = false;
    try {
      await connection
          .reference()
          .child(NodeNameGallery.TAXI)
          .child(idTaxi.toString())
          .set(serviceTaxi.toJson())
          .then(
        (_) async {
          success = true;
        },
      );
      return success;
    } catch (e) {
      //log(e.toString());
      return false;
    }
  }

  @override
  Future<bool> sendUbicationTaxi(int idTaxi, LocationData curren) async {
    bool success = false;
    try {
      await connection
          .reference()
          .child(NodeNameGallery.TAXI)
          .child(idTaxi.toString())
          .update({
        'latitudActual': curren.latitude,
        'longitudActual': curren.longitude
      }).then(
        (_) async {
          success = true;
        },
      );
      return success;
    } catch (e) {
      //log(e.toString());
      return false;
    }
  }

  @override
  Stream<Event> getNodeEvent(int idTaxi) {
    return connection
        .reference()
        .child(NodeNameGallery.TAXI)
        .child(idTaxi.toString())
        .onValue;
  }
}
