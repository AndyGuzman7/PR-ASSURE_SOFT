import 'package:firebase_database/firebase_database.dart';

class FirebaseConnection {
  late final dbRef;

  FirebaseConnection();
  initFirebase() {
    dbRef = FirebaseDatabase.instance.reference();
    return dbRef;
  }

  String getKey(value) {
    return dbRef.reference().child(value).push().key.toString();
  }
}
