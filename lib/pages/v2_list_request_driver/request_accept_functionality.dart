import 'package:firebase_database/firebase_database.dart';

class RequestAcceptFunctionality {
  late final dbRef;
  late String key;
  late bool statusRequest = false;
  late String idRequestAccept = "", idUser = "";
  late Function(bool) updateStatus;

  RequestAcceptFunctionality();
  void initFirebase() {
    dbRef = FirebaseDatabase.instance.reference();

    Stream<Event> streamBuilder = dbRef.child("RequestPruebas").onValue;

    streamBuilder.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      getItemsRequestFirebase(snapshot, idUser);
    });
  }

  Stream<Event> getEvent() {
    return dbRef.child('RequestPruebas').onValue;
  }

  void getInstance() {
    return dbRef;
  }

//Get data from RequestPruebas node
  getItemsRequestFirebase(DataSnapshot snapshot, String idUser) {
    final extractedData = snapshot.value;
    if (extractedData != null) {
      statusRequest = false;
      extractedData.forEach(
        (blogId, blogData) {
          String idUserRequest = blogData['idCliente'];

          if (idUserRequest == idUser) {
            String statusConfirmation = blogData['estado'];
            if (statusConfirmation == "confirmado") {
              idRequestAccept = blogId;
              print(idRequestAccept);
              statusRequest = true;
            } else {
              statusRequest = false;
            }
          }
        },
      );
    }

    updateStatus(statusRequest);
  }
}
