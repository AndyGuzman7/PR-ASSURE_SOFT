import 'package:firebase_database/firebase_database.dart';

class FirebaseConnection {
  late var dbRef; // = FirebaseDatabase.instance.reference();

  FirebaseConnection() {
    dbRef = FirebaseDatabase.instance.reference();
  }

  dynamic getConnection() {
    return dbRef;
  }

  String getKey(value) {
    return dbRef.reference().child(value).push().key.toString();
  }
}
