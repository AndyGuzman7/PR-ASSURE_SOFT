import 'package:firebase_database/firebase_database.dart';
import 'package:taxi_segurito_app/models/taxirequest.dart';

class RequestDecisionFunctionality {
  List<RequestTaxi> listRequest = [];
  late final nameBranch = "Taxista";
  late final dbRef;
  late String key;
  late bool status = false, statusRequest = false, estado = false;
  late Function(bool) updateStatus;

  RequestDecisionFunctionality();
  void initFirebase() {
    dbRef = FirebaseDatabase.instance.reference();
    checkStatus('-N1vHdpBe2km7i6xJbkz');

    Stream<Event> streamBuilder = dbRef.child("RequestPruebas").onValue;
    streamBuilder.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      getItemsRequestFirebase(snapshot, '-N1vHdpBe2km7i6xJbkz');
    });
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
      print('No esta ocupado conduciendo...');
    }
  }

  Future<void> update(String idUserTaxista) async {
    dbRef
        .reference()
        .child(nameBranch)
        .child(idUserTaxista)
        .update({'estado': 'ocupado'});
  }

  Stream<Event> getEvent() {
    return dbRef.child('RequestPruebas').onValue;
  }

  void getInstance() {
    return dbRef;
  }

  getItemsRequestFirebase(DataSnapshot snapshot, String idTaxista) {
    List<RequestTaxi> listRequestPreview = [];

    final extractedData = snapshot.value;
    if (extractedData != null)
      extractedData.forEach(
        (blogId, blogData) {
          RequestTaxi taxiRequest = RequestTaxi.fromJson(blogData);
          print('INFO $blogData');
          listRequestPreview.add(taxiRequest);
        },
      );
    statusRequest = false;

    for (RequestTaxi item in listRequestPreview) {
      String idTaxi = item.idTaxista;
      print(idTaxi);
      if (idTaxista == idTaxi) {
        if (estado) {
          statusRequest = true;
        } else {
          statusRequest = false;
          print("No esta disponible pero tiene solicitudes");
        }
      }
    }
    updateStatus(statusRequest);
  }
}
