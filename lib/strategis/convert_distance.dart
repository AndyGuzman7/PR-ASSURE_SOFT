import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/client_request.dart';

class ConvertDistance {
  String getDistance(ClienRequest clientRequest) {
    String distanceString = "0 km";
    double origenLatitud = double.parse(clientRequest.latitudOrigen.toString());

    double origenLongitud =
        double.parse(clientRequest.longitudOrigen.toString());
    double destinoLatitud =
        double.parse(clientRequest.latitudDestino.toString());
    double destinoLongitud =
        double.parse(clientRequest.longitudDestino.toString());
    double distanceDouble = Geolocator.distanceBetween(
        origenLatitud, origenLongitud, destinoLatitud, destinoLongitud);

    if (distanceDouble >= 1000) {
      distanceString = (distanceDouble / 1000).toStringAsFixed(1) + " Km";
    } else {
      distanceString = distanceDouble.toStringAsFixed(1) + " m";
    }
    return distanceString;
  }

  Future<Text> getNameDirection(LatLng latLng) async {
    String address = "";
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    address = '${placemarks.first.locality}';
    return Text(
      address,
      textAlign: TextAlign.left,
    );
  }

  FutureBuilder<Text> getNameDirectionAddress(concat, latitude, longitude) {
    LatLng latLng = new LatLng(latitude, longitude);
    return FutureBuilder(
      future: getNameDirection(latLng),
      builder: (_, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Text response = snapshot.data!;
          print(response);
          return Text(
            concat + response.data,
            textAlign: TextAlign.left,
          );
        }
        return Text("...");
      },
    );
  }
}
