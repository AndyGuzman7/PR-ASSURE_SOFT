import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/components/map/settingsGalleryMap.dart';
import 'package:taxi_segurito_app/models/pin_pill_info.dart';
import 'package:taxi_segurito_app/pages/v2_view_user_request/view_user_request_functionality.dart';
import 'package:taxi_segurito_app/strategis/location_service.dart';

import 'animated/map_pin_pill.dart';

//primeras versiones de prueba
class ViewMapNow extends StatefulWidget {
  int idTaxi;
  ViewMapNow({Key? key, required this.idTaxi}) : super(key: key);

  @override
  State<ViewMapNow> createState() => _ViewMapNowState();
}

class _ViewMapNowState extends State<ViewMapNow> {
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = Set<Marker>();
  LocationService locationService = LocationService();
  late LocationData currentLocation = LocationData.fromMap({
    "latitude": SettingsGalleryMap.SOURCE_LOCATION.latitude,
    "longitude": SettingsGalleryMap.SOURCE_LOCATION.longitude
  });

  double pinPillPosition = -100;
  BitmapDescriptor? sourceIcon;

  late PinInformation sourcePinInfo;
  ViewUserRequestFunctionality viewTaxiRequestFunctionality =
      new ViewUserRequestFunctionality();

  PinInformation currentlySelectedPin = PinInformation(
      pinPath: 'assets/images/location_car.png',
      avatarPath: 'assets/images/location_car.png',
      location: LatLng(0, 0),
      locationName: 'Ubicacion del Taxista',
      labelColor: Colors.grey);

  @override
  void initState() {
    super.initState();
    setInitialLocation();
    viewTaxiRequestFunctionality
        .initListenerNodeFirebaseUbicationTaxi(widget.idTaxi);

    locationService.getPermisson();

    viewTaxiRequestFunctionality.setUbicationTaxi = (value) {
      currentLocation = LocationData.fromMap(
          {"latitude": value.latitudActual, "longitude": value.longitudActual});
      updatePinOnMap();
    };

    setSourceAndDestinationIcons();
  }

  void setSourceAndDestinationIcons() async {
    try {
      sourceIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 2.0),
          'assets/images/location_car.png');
    } catch (e) {
      print(e.toString() + 'AQUI ESTA EL ERROR DE IMAGEN 1');
    }
  }

  void setInitialLocation() async {
    currentLocation = await locationService.getUbication();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      zoom: SettingsGalleryMap.CAMERA_ZOOM,
      tilt: SettingsGalleryMap.CAMERA_TILT,
      bearing: SettingsGalleryMap.CAMERA_BEARING,
      target: SettingsGalleryMap.SOURCE_LOCATION,
    );

    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
        zoom: SettingsGalleryMap.CAMERA_ZOOM,
        tilt: SettingsGalleryMap.CAMERA_TILT,
        bearing: SettingsGalleryMap.CAMERA_BEARING,
        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
      );
    }
    return Container(
      child: Stack(
        children: <Widget>[
          GoogleMap(
              myLocationEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              markers: _markers,
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              onTap: (LatLng loc) {
                pinPillPosition = -100;
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);

                showPinsOnMap();
              }),
          MapPinPillComponent(
              pinPillPosition: pinPillPosition,
              currentlySelectedPin: currentlySelectedPin)
        ],
      ),
    );
  }

  void showPinsOnMap() async {
    var pinPosition =
        LatLng(currentLocation.latitude!, currentLocation.longitude!);

    try {
      sourcePinInfo = PinInformation(
          locationName: "Ubicación del Taxista",
          location: SettingsGalleryMap.SOURCE_LOCATION,
          pinPath: "assets/images/location_car.png",
          avatarPath: "assets/images/location_car.png",
          labelColor: Colors.blueAccent);
    } catch (e) {
      print(e.toString());
    }

    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = sourcePinInfo;
            pinPillPosition = 0;
          });
        },
        icon: sourceIcon!));
  }

  void updatePinOnMap() async {
    CameraPosition cPosition = CameraPosition(
      zoom: SettingsGalleryMap.CAMERA_ZOOM,
      tilt: SettingsGalleryMap.CAMERA_TILT,
      bearing: SettingsGalleryMap.CAMERA_BEARING,
      target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

    setState(() {
      var pinPosition =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);

      sourcePinInfo.location = pinPosition;

      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          onTap: () {
            setState(() {
              currentlySelectedPin = sourcePinInfo;
              pinPillPosition = 0;
            });
          },
          position: pinPosition,
          icon: sourceIcon!));
    });
  }
}
