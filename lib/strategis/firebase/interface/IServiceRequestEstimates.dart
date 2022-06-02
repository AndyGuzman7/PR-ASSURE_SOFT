import 'package:firebase_database/firebase_database.dart';
import 'package:taxi_segurito_app/models/estimate_taxi.dart';

abstract class IServiceRequestEstimates {
  Future<bool> insertNode(value);
  Stream<Event> getNodeEvent();
  Stream<Event> getConfirmationClientEvent(idFirebase);
  Stream<Event> getConfirmationTaxiEvent(idFirebase);
  Future<bool> cancelEstimateClient(value, status);

  Future<bool> cancelEstimateTaxi(value, motivo, status);
  Future<bool> confirmateEstimateClient(value, status);
  Future<bool> confirmateEstimateTaxi(EstimateTaxi estimateTaxi, status);
}
