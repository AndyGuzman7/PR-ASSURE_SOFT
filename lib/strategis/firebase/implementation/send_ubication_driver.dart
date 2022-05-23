import 'package:rxdart/rxdart.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/firebaseConnection.dart';
import 'package:taxi_segurito_app/strategis/firebase/interface/ISendLocation.dart';
import 'package:taxi_segurito_app/strategis/firebase/nodeNameGallery.dart';



class SendLocationDriver implements ISendLocation {
  late String key;
  late final connection;

  SendLocationDriver() {
    connection = FirebaseConnection().getConnection();
    key = FirebaseConnection().getKey(NodeNameGallery.SENDMYUBICATIONDRIVER);
  }

  @override
  bool insertNode(value) {
    // TODO: implement insertNode
    bool success = false;

    try {
      connection
          .referen()
          .child(NodeNameGallery.SENDMYUBICATIONDRIVER)
          .child(key)
          .set(value)
          .then((data) => {success = true});
      return success;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  @override
  Future<bool> updateNode(value) {
    // TODO: implement updateNode
    throw UnimplementedError();
  }
}
