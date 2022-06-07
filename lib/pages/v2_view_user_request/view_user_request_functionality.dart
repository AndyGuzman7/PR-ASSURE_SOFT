import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:taxi_segurito_app/models/estimate_taxi.dart';
import 'package:taxi_segurito_app/models/service_taxi.dart';
import 'package:taxi_segurito_app/pages/v2_client_service_request_information/nameGalleryStateConfirmation.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/request_view_taxi_impl.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/service_request_estimates_impl.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/taxi_impl.dart';

class ViewUserRequestFunctionality {
  ServiceRequestEstimatesImpl serviceRequestEstimatesImpl =
      new ServiceRequestEstimatesImpl();
  TaxiImpl taxiImpl = new TaxiImpl();
  RequestViewTaxiImpl requestViewTaxiImpl = new RequestViewTaxiImpl();

  void Function(EstimateTaxi estimateTaxi)? showConfirmation;
  void Function(ServiceTaxi serviceTaxi)? setUbicationTaxi;
  void Function()? showTerminateService;

  void initListenerNodeFirebaseUbicationTaxi(int idTaxi) {
    try {
      taxiImpl.getNodeEvent(idTaxi).listen((event) {
        listenEventTaxi(event);
      });
    } catch (e) {
      print(e);
    }
  }

  void initListenerNodeFirebase(String idRequest) {
    try {
      requestViewTaxiImpl.getNodeEvent(idRequest).listen((event) {
        listenEvent(event);
      });
    } catch (e) {
      print(e);
    }
  }

  listenEvent(event) {
    DataSnapshot snapshot = event.snapshot;
    EstimateTaxi estimateTaxi = EstimateTaxi.fromJson(snapshot.value);
    print(estimateTaxi.estadoTaxi);
    if (estimateTaxi.estadoTaxi == NameGalleryStateConfirmation.CANCELADO) {
      showConfirmation!(estimateTaxi);
    }
  }

  listenEventTaxi(event) {
    DataSnapshot snapshot = event.snapshot;
    ServiceTaxi serviceTaxi = ServiceTaxi.fromJson(snapshot.value);
    if (snapshot.exists) {
      setUbicationTaxi!(serviceTaxi);
      print(serviceTaxi.latitudActual);
    }
  }
}
