import 'package:firebase_database/firebase_database.dart';

abstract class ITaxi {
  Future<bool> updateStatusTaxi(value, status);
}
