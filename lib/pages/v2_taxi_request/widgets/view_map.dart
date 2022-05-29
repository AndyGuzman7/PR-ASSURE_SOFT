import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/models/owner.dart';

class ViewMap extends StatefulWidget {
  ViewMap({Key? key}) : super(key: key);
  _ViewMapState _taxiRequestMapv2State = new _ViewMapState();
  @override
  State<ViewMap> createState() {
    return _taxiRequestMapv2State;
  }

  getLocationOrigen() {
    return _taxiRequestMapv2State.getLocationOrigen();
  }

  getLocationDestino() {
    return _taxiRequestMapv2State.getLocationDestino();
  }
}

class _ViewMapState extends State<ViewMap> {
  Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();
  getLocationOrigen() {
    return latLngOrigen;
  }

  getLocationDestino() {
    return latLngOrigen;
  }

  Location location = Location();

  late LatLng latLngOrigen;
  late LatLng latLngDestino = LatLng(-0.000327615289788, -0.00522494279294);

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;

  Set<Marker> _createMarker(LatLng locationOrigin) {
    _markers[MarkerId('Origin')] = new Marker(
        markerId: MarkerId('Origin'),
        position: LatLng(locationOrigin.latitude, locationOrigin.longitude),
        draggable: true,
        icon: pinLocationIconUser,
        infoWindow: InfoWindow(title: "Origin"),
        onDragEnd: (newPosition) {
          latLngOrigen = LatLng(newPosition.latitude, newPosition.longitude);
        });

    _markers[MarkerId('Destine')] = new Marker(
        markerId: MarkerId('Destine'),
        position: latLngDestino,
        draggable: true,
        icon: pinLocationIconCar,
        infoWindow: InfoWindow(title: "Destine"),
        onDragEnd: (newPosition) {
          latLngDestino = LatLng(newPosition.latitude, newPosition.longitude);
        });

    return markers;
  }

  Future<void> initUbicacion() async {
    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  late BitmapDescriptor pinLocationIconUser, pinLocationIconCar;
  @override
  void initState() {
    super.initState();

    setCustomMapPin();
    initUbicacion();

    //taxiRequestFunctionality.initFirebase();
  }

  void setCustomMapPin() async {
    pinLocationIconUser = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(35, 35)),
        'assets/images/location_user.png');
    pinLocationIconCar = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(35, 35)),
        'assets/images/location_car.png');
  }

  Color colorMain = Color.fromRGBO(255, 193, 7, 1);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return new Container(
      height: height,
      width: width,
      child: FutureBuilder(
        future: location.getLocation(),
        builder: (_, AsyncSnapshot<LocationData> snapshot) {
          print(snapshot.hasData);
          if (snapshot.hasData) {
            final locat = snapshot.data;
            LatLng locationOri =
                LatLng(locat?.latitude ?? 0.0, locat?.longitude ?? 0.0);
            latLngOrigen = locationOri;
            latLngDestino = LatLng(
                (latLngOrigen.latitude + latLngDestino.latitude),
                (latLngOrigen.longitude + latLngDestino.longitude));
            print("respuesta " + locationOri.latitude.toString());

            return Expanded(
                child: GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(locationOri.latitude, locationOri.longitude),
                  zoom: 15),
              onMapCreated: (GoogleMapController controller) {},
              mapToolbarEnabled: false,
              compassEnabled: false,
              myLocationEnabled: true,
              markers: _createMarker(locationOri),
              mapType: MapType.normal,
            ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
