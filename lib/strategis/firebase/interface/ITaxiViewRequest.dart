import 'package:firebase_database/firebase_database.dart';

abstract class IUserViewRequest {
  Stream<Event> getNodeEvent(idFirebase);
}
