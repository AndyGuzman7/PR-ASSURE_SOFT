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
  }

  Future<void> sendFirebase(value) async {
    dbRef.reference().child(nameBranch).child(key).set(value);
    print(key);
  }
}
