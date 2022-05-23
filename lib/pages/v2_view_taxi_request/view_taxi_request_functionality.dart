import 'package:firebase_database/firebase_database.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/service_request_estimates_impl.dart';

class ViewTaxiRequestFunctionality {
  late final dbRef;
  late String key;
  ServiceRequestEstimatesImpl serviceRequestEstimatesImpl =
      new ServiceRequestEstimatesImpl();
  ViewTaxiRequestFunctionality();
  void initFirebase() {
    dbRef = FirebaseDatabase.instance.reference();
  }

  void sendReasonCancel(motivo) {
    //value, motivo, status
    serviceRequestEstimatesImpl
        .updateStatus("-N2Q6GQdFTS1ssytbuBj", motivo, "cancelado")
        .then(
          (value) => {
            print("Se inserto con exito"),
          },
        );
  }

  //Send data reason cancel
  /*Future<void> sendReasonCancel(String reason) async {
    dbRef
        .reference()
        .child("RequestPruebas")
        .child(key)
        .update({'estado': 'cancelado', 'motivo': reason});
  }*/

  void getInstance() {
    return dbRef;
  }
}
