import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/models/estimate_taxi.dart';

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

  Future<void> sendRequest(EstimateTaxi taxiRequest) async {
    taxiRequest.idRequestTaxiFirebase = key;
    dbRef.reference().child(nameBranch).child(key).set(taxiRequest.toJson());
    print(key);
  }

  Future<void> sendEstiamtes(double cotization) async {
    Position position = await Geolocator.getCurrentPosition();
    EstimateTaxi estimateTaxi = new EstimateTaxi(1, key, "-N1vLO9946XQ4MXqRkys",
        cotization, position.latitude, position.longitude, "");

    dbRef.reference().child(nameBranch).child(key).set(estimateTaxi.toJson());
    print(key);
  }

  void getInstance() {
    return dbRef;
  }
}
