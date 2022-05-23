import 'package:firebase_database/firebase_database.dart';

class ViewTaxiRequestFunctionality {
  late final dbRef;
  late String key;

  ViewTaxiRequestFunctionality();
  void initFirebase() {
    dbRef = FirebaseDatabase.instance.reference();
  }

  //Update data status Request
  Future<void> updateStatusRequest(String idRequest, String reason) async {
    dbRef
        .reference()
        .child("RequestPruebas")
        .child(idRequest)
        .update({'estado': 'cancelado', 'motivo': reason});
  }

  void getInstance() {
    return dbRef;
  }
}
