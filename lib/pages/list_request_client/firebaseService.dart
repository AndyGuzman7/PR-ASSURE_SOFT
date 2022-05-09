import 'package:firebase_database/firebase_database.dart';
import 'package:taxi_segurito_app/services/sessions_service.dart';

class FirebaseService {
  late final nameBranch = "UbicationNowDriverTaxi";
  late final dbRef;
  SessionsService sessions = new SessionsService();
  late String key;

  FirebaseService();
  Future<void> initFirebase() async {
    dbRef = FirebaseDatabase.instance.reference();
    //key = (await sessions.verificationSession('key')) as String;
  }

  Future<void> sendFirebase(value) async {
    key = "auto1";
    // String key = dbRef.reference().child(nameBranch).push().key.toString();
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
