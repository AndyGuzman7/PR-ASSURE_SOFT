import 'package:firebase_database/firebase_database.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/firebaseConnection.dart';
import 'package:taxi_segurito_app/strategis/firebase/interface/IRequest.dart';
import 'package:taxi_segurito_app/strategis/firebase/nodeNameGallery.dart';

class RequestClientImpl implements IRequest {
  late String key;
  late FirebaseDatabase connection;

  RequestClientImpl() {
    connection = FirebaseConnection.initFirebase();
    key = FirebaseConnection.getKey(NodeNameGallery.REQUESTCLIENT);
  }

  @override
  bool insertNode(value) {
    bool success = false;
    connection
        .reference()
        .child(NodeNameGallery.REQUESTCLIENT)
        .child(key)
        .set(value)
        .then((_) {
      success = true;
    });
    return success;
  }
}
