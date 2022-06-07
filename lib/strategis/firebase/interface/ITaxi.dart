import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/models/service_taxi.dart';

abstract class ITaxi {
  Future<bool> updateStatusTaxi(value, status);
  Future<bool> sendStatusTaxi(int idTaxi, ServiceTaxi serviceTaxi);
  Future<bool> sendUbicationTaxi(int idTaxi, LocationData curren);
  Stream<Event> getNodeEvent(int idTaxi);
}
