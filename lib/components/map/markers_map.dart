import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkersMap {
  LatLng? latLngOrigin;
  LatLng? latLngDestine;
  late BitmapDescriptor pinLocationIconUser, pinLocationIconCar;
  MarkersMap() {
    setCustomMapPin();
  }

  LatLng? getlatLngOrigin() {
    return latLngOrigin;
  }

  LatLng? getlatLngDestine() {
    return latLngDestine;
  }

  Set<Marker> createMarkersMap(LatLng latlnOrigin, LatLng latLngDestine) {
    Map<MarkerId, Marker> markersMap = {};

    markersMap[MarkerId('Origin')] = new Marker(
      markerId: MarkerId('Origin'),
      position: latlnOrigin,
      draggable: true,
      icon: pinLocationIconUser,
      infoWindow: InfoWindow(title: "Origin"),
      onDragEnd: (newPosition) {
        latLngOrigin = LatLng(newPosition.latitude, newPosition.longitude);
      },
    );

    markersMap[MarkerId('Destine')] = new Marker(
      markerId: MarkerId('Destine'),
      position: latLngDestine,
      draggable: true,
      icon: pinLocationIconCar,
      infoWindow: InfoWindow(title: "Destine"),
      onDragEnd: (newPosition) {
        latLngDestine = LatLng(newPosition.latitude, newPosition.longitude);
      },
    );

    Set<Marker> markers = markersMap.values.toSet();
    return markers;
  }

  void setCustomMapPin() async {
    pinLocationIconUser = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(35, 35)),
        'assets/images/location_user.png');
    pinLocationIconCar = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(35, 35)),
        'assets/images/location_car.png');
  }
}
