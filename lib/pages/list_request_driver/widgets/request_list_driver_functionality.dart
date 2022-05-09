import 'package:flutter/cupertino.dart';
//import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../models/driver_request.dart';

class RequestListItemFunctionality {
  RequestListItemFunctionality();

  String getDistance(DriverRequest driverRequest, double latitudCliente, double longitudCliente) {
    String distanceString = "0 km";
    double origenLatitud = double.parse(longitudCliente.toString());

    double origenLongitud =
        double.parse(latitudCliente.toString());
    double destinoLatitud =
        double.parse(driverRequest.latitud.toString());
    double destinoLongitud =
        double.parse(driverRequest.longitud.toString());
    double distanceDouble = Geolocator.distanceBetween(
        origenLatitud, origenLongitud, destinoLatitud, destinoLongitud);

    if (distanceDouble >= 1000) {
      distanceString = (distanceDouble / 1000).toStringAsFixed(2) + " Km";
    } else {
      distanceString = distanceDouble.toStringAsFixed(2) + " Km";
    }
    return distanceString;
  }

}