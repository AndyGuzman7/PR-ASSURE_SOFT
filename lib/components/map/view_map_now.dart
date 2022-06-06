import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/models/pin_pill_info.dart';
import 'package:taxi_segurito_app/pages/v2_view_user_request/view_user_request_functionality.dart';
import 'package:taxi_segurito_app/strategis/location_service.dart';

import 'animated/map_pin_pill.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
const LatLng DEST_LOCATION = LatLng(37.335685, -122.0605916);

//primeras versiones de prueba
class ViewMapNow extends StatefulWidget {
  int idTaxi;
  ViewMapNow({Key? key, required this.idTaxi}) : super(key: key);

  @override
  State<ViewMapNow> createState() => _ViewMapNowState();
}

class _ViewMapNowState extends State<ViewMapNow> {
  //controller
  Completer<GoogleMapController> _controller = Completer();
  //markers
  Set<Marker> _markers = Set<Marker>();
  LocationService locationService = LocationService();
  late LocationData currentLocation = LocationData.fromMap({
    "latitude": SOURCE_LOCATION.latitude,
    "longitude": SOURCE_LOCATION.longitude
  });
  late LocationData destinationLocation;
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
    // create an instance of Location
    locationService.getPermisson();

    viewTaxiRequestFunctionality.setUbicationTaxi = (value) {
      print(value.latitudActual.toString() + "asd");
      //LatLng latLng = new LatLng(value.latitudActual, value.longitudActual);
      currentLocation = LocationData.fromMap(
          {"latitude": value.latitudActual, "longitude": value.longitudActual});

      //print(currentLocation.toString() + "ESTO ES EL CURRENTTTTT");

      updatePinOnMap();
      //viewMapNow.updatePinOnMap(latLng);
    };

    // set custom marker pins
    setSourceAndDestinationIcons();
    // set the initial location
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
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await locationService.getUbication();

    // hard-coded destination for this example
    currentLocation = LocationData.fromMap({
      "latitude": DEST_LOCATION.latitude,
      "longitude": DEST_LOCATION.longitude
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
              myLocationEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              markers: _markers,
              //polylines: _polylines,
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              onTap: (LatLng loc) {
                pinPillPosition = -100;
              },
              onMapCreated: (GoogleMapController controller) {
                //controller.setMapStyle(Utils.mapStyles);
                _controller.complete(controller);
                // my map has completed being created;
                // i'm ready to show the pins on the map
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
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    var pinPosition =
        LatLng(currentLocation.latitude!, currentLocation.longitude!);
    // get a LatLng out of the LocationData object
    // var destPosition =
    //     LatLng(destinationLocation.latitude, destinationLocation.longitude);
    try {
      sourcePinInfo = PinInformation(
          locationName: "Ubicación del Taxista",
          location: SOURCE_LOCATION,
          pinPath: "assets/images/location_car.png",
          avatarPath: "assets/images/location_car.png",
          labelColor: Colors.blueAccent);
    } catch (e) {
      print(e.toString() + 'AQUI ESTA EL ERROR DE IMAGEN 2');
    }

    // destinationPinInfo = PinInformation(
    //     locationName: "End Location",
    //     location: DEST_LOCATION,
    //     pinPath: "assets/destination_map_marker.png",
    //     avatarPath: "assets/friend2.jpg",
    //     labelColor: Colors.purple);

    // add the initial source location pin
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
    // destination pin
    // _markers.add(Marker(
    //     markerId: MarkerId('destPin'),
    //     position: destPosition,
    //     onTap: () {
    //       setState(() {
    //         currentlySelectedPin = destinationPinInfo;
    //         pinPillPosition = 0;
    //       });
    //     },
    //     icon: destinationIcon));
    // // set the route lines on the map from source to destination
    // for more info follow this tutorial
    ////setPolylines();
  }

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);

      sourcePinInfo.location = pinPosition;

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          onTap: () {
            setState(() {
              currentlySelectedPin = sourcePinInfo;
              pinPillPosition = 0;
            });
          },
          position: pinPosition, // updated position
          icon: sourceIcon!));
    });
  }
}
