import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/models/taxi_request.dart';

class ViewRequestFunctionality {
  late final nameBranch = "RequestTaxi";
  late final dbRef;
  late String key;
  late Location location = new Location();

  Function(String)? updateData;

  ViewRequestFunctionality();
  void initFirebase() {
    dbRef = FirebaseDatabase.instance.reference();

    key = dbRef.reference().child(nameBranch).push().key.toString();
  }

  void update(value) {
    updateData!(value);
  }

  Future<void> sendRequest(TaxiRequest taxiRequest) async {
    taxiRequest.idRequestTaxiFirebase = key;
    dbRef.reference().child(nameBranch).child(key).set(taxiRequest.toJson());
    print(key);
  }

  void getInstance() {
    return dbRef;
  }
}
