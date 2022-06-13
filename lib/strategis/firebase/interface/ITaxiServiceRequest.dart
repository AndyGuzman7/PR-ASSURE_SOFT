import 'package:firebase_database/firebase_database.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/request_Client_impl.dart';

abstract class ITaxiServiceRequest {
  Future<bool> insertNode(value);
  Future<bool> deleteNode(vaue);
  Stream<Event> getNodeEvent();
  Future<ClienRequest> getNodeItem(serviceRequestId);
  Future<bool> updateRange(ClienRequest clienRequest);

  Future<ClienRequest> getNodeItemNew();
}
