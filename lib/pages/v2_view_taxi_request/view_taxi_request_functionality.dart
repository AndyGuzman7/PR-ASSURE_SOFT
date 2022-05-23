import 'package:firebase_database/firebase_database.dart';

class ViewTaxiRequestFunctionality {
  late final dbRef;
  late String key;

  ViewTaxiRequestFunctionality();
  void initFirebase() {
    dbRef = FirebaseDatabase.instance.reference();
  }

  //Send data reason cancel
  Future<void> sendReasonCancel(String reason) async {
    dbRef
        .reference()
        .child("RequestPruebas")
        .child(key)
        .update({'estado': 'cancelado', 'motivo': reason});
  }

  void getInstance() {
    return dbRef;
  }
}
