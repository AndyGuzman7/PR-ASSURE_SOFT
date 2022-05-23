import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';

abstract class IServiceRequestEstimates {
  Future<bool> insertNode(value);
  Stream<Event> getNodeEvent();
  Stream<Event> getConfirmationEvent(idFirebase);
  Future<bool> updateStatus(value, motivo, status);
}
