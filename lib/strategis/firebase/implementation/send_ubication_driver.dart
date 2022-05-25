import 'package:location/location.dart';
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
  Future<bool> updateNode(value) {
    // TODO: implement updateNode
    throw UnimplementedError();
  }

  @override
  Future<bool> insertNode(LocationData current) async {
    bool success = false;
    try {
      await connection
          .reference()
          .child(NodeNameGallery.SENDMYUBICATIONDRIVER)
          .child(key)
          .set({
        'latitude': current.latitude,
        'longitude': current.longitude
      }).then((data) => {success = true});
      return success;
    } catch (ex) {
      print(ex);
      return false;
    }
  }
}
