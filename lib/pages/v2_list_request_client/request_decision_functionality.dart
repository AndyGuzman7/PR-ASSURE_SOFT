import 'package:firebase_database/firebase_database.dart';
import 'package:taxi_segurito_app/models/taxirequest.dart';

class RequestDecisionFunctionality {
  late final dbRef;
  late String key;
  late bool statusRequest = false, estado = false;
  late String idRequestAccept = "";
  late Function(bool) updateStatus;

  RequestDecisionFunctionality();
  void initFirebase() {
    dbRef = FirebaseDatabase.instance.reference();
    checkStatus('-N1vHdpBe2km7i6xJbkz');

    /* Stream<Event> streamBuilder = dbRef.child("RequestTaxi").onValue;
    streamBuilder.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      getItemsRequestFirebase(snapshot, 1);
    });*/
  }

  //Check if the status is available
  Future<void> checkStatus(String idUserTaxista) async {
    var taxiStatus = (await FirebaseDatabase.instance
            .reference()
            .child("Taxista/$idUserTaxista")
            .once())
        .value;

    if (taxiStatus['estado'] == 'ocupado') {
      estado = false;
      print('Esta ocupado conduciendo...');
    } else {
      estado = true;
      print('No esta conduciendo...');
    }
  }

//Update data status Taxista and confirmation RequestTaxi
  Future<void> updateStatusRequest(String idUserTaxista) async {
    dbRef
        .reference()
        .child("Taxista")
        .child(idUserTaxista)
        .update({'estado': 'ocupado'});
    dbRef
        .reference()
        .child("RequestTaxi")
        .child(idRequestAccept)
        .update({'confirmation': true});
  }

  Stream<Event> getEvent() {
    return dbRef.child('RequestPruebas').onValue;
  }

  void getInstance() {
    return dbRef;
  }

//Get data from RequestTaxi node
  /*getItemsRequestFirebase(DataSnapshot snapshot, int idTaxista) {
    final extractedData = snapshot.value;
    if (extractedData != null) {
      statusRequest = false;
      extractedData.forEach(
        (blogId, blogData) {
          int idTaxi = blogData['idUserTaxi'];
          if (idTaxi == idTaxista) {
            idRequestAccept = blogId;
            if (estado) {
              statusRequest = true;
            } else {
              statusRequest = false;
            }
          }
        },
      );
    }

    updateStatus(statusRequest);
  }*/
}
