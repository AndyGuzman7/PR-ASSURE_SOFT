import 'package:firebase_database/firebase_database.dart';

class FirebaseConnection {
  static late final dbRef;

  FirebaseConnection();
  static initFirebase() {
    dbRef = FirebaseDatabase.instance.reference();
    return dbRef;
  }

  static String getKey(value) {
    return dbRef.reference().child(value).push().key.toString();
  }
}
