import 'package:firebase_database/firebase_database.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/firebaseConnection.dart';
import 'package:taxi_segurito_app/strategis/firebase/interface/IRequest.dart';
import 'package:taxi_segurito_app/strategis/firebase/interface/IRequestTaxi.dart';
import 'package:taxi_segurito_app/strategis/firebase/nodeNameGallery.dart';

class RequestTaxiImpl extends IRequestTaxi {
  late final connection;
  RequestTaxiImpl() {
    connection = FirebaseConnection().initFirebase();
  }

  @override
  Future<bool> updateNode(value) async {
    bool succes = false;

    await connection
        .reference()
        .child(NodeNameGallery.REQUESTTAXI)
        .child(value)
        .update({'confirmation': true}).then((value) {
      succes = true;
    });
    return succes;
  }
}
