
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';

abstract class ISendLocation {
  Future<bool> insertNode(LocationData current);
  Future<Stream<Event>> getNodeEvent();

  Future<bool> updateNode(value);
}
