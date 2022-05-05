import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  late final nameBranch = "UbicationNowDriverTaxi";
  late final dbRef;

  FirebaseService();
  void initFirebase() {
    dbRef = FirebaseDatabase.instance.reference();
  }

  Future<void> sendFirebase(value) async {
    String key = dbRef.reference().child(nameBranch).push().key.toString();
    //clienRequest.iduserFirebase = key;
    dbRef.reference().child(nameBranch).child(key).set(value);
    print(key);
    //LatLng latLng =
    // new LatLng(clienRequest.latitudOrigen, clienRequest.longitudOrigen);
    //notificationsFirebase.sendNotification(latLng);
  }

  /* Future<void> sendRequest(ClienRequest clienRequest) async {
    String key = dbRef.reference().child(nameBranch).push().key.toString();
    clienRequest.iduserFirebase = key;
    dbRef.reference().child(nameBranch).child(key).set(clienRequest.toJson());
    print(key);
    LatLng latLng =
        new LatLng(clienRequest.latitudOrigen, clienRequest.longitudOrigen);
    notificationsFirebase.sendNotification(latLng);
  }*/

}
