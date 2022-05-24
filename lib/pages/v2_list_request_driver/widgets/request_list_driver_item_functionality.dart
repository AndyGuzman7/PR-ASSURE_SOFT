import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_segurito_app/models/estimate_taxi.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/request_taxi_impl.dart';
import 'package:workmanager/workmanager.dart';

class RequestListItemFunctionality {
  late BuildContext context;
  RequestListItemFunctionality();

  String getDistance(EstimateTaxi estimateTaxi, double latitudCliente,
      double longitudCliente) {
    String distanceString = "0 km";
    double origenLatitud = double.parse(longitudCliente.toString());

    double origenLongitud = double.parse(latitudCliente.toString());
    double destinoLatitud = double.parse(estimateTaxi.latitud.toString());
    double destinoLongitud = double.parse(estimateTaxi.longitud.toString());
    double distanceDouble = Geolocator.distanceBetween(
        origenLatitud, origenLongitud, destinoLatitud, destinoLongitud);

    if (distanceDouble >= 1000) {
      distanceString = (distanceDouble / 1000).toStringAsFixed(2) + " Km";
    } else {
      distanceString = distanceDouble.toStringAsFixed(2) + " Km";
    }
    return distanceString;
  }

  confirmationEstimate(key) {
    RequestTaxiImpl requestTaxiImpl = new RequestTaxiImpl();
    requestTaxiImpl.updateNode(key).then((value) {
      print(value);

      if (value) showSnackBar(context);
    });
  }

  showSnackBar(contex) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Confirmacion Enviada'),
    ),);
  }
 
}
