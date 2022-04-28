import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

// ignore: must_be_immutable
class RequestInfo extends StatefulWidget {
  String? requestID;

  RequestInfo({this.requestID});
  @override
  _RequestInfoState createState() => _RequestInfoState();
}

class _RequestInfoState extends State<RequestInfo> {
  late LatLng latLngOrigen = LatLng(0, 0);
  late LatLng latLngDestino = LatLng(0, 0);

  //final fb = FirebaseDatabase.instance.reference();
  Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();

  Location location = Location();

  Set<Marker> _createMarker() {
    _markers[MarkerId('Origin')] = new Marker(
      markerId: MarkerId('Origin'),
      position: LatLng(latLngOrigen.latitude, latLngOrigen.longitude),
      icon: pinLocationIconUser,
      infoWindow: InfoWindow(title: "Origen"),
    );

    _markers[MarkerId('Destine')] = new Marker(
      markerId: MarkerId('Destine'),
      position: LatLng(latLngDestino.latitude, latLngDestino.longitude),
      icon: pinLocationIconCar,
      infoWindow: InfoWindow(title: "Destino"),
    );

    return markers;
  }

  late BitmapDescriptor pinLocationIconUser, pinLocationIconCar;
  @override
  void initState() {
    super.initState();
    setState(() {
      setCustomMapPin();
      getRequest();
    });
  }

  Future<void> getRequest() async {
    String? requestID = widget.requestID;
    var clienRequest = (await FirebaseDatabase.instance
            .reference()
            .child("Request/$requestID")
            .once())
        .value;
    latLngOrigen =
        LatLng(clienRequest["latitudOrigen"], clienRequest["longitudOrigen"]);

    latLngDestino =
        LatLng(clienRequest["latitudDestino"], clienRequest["longitudDestino"]);
  }

  void setCustomMapPin() async {
    pinLocationIconUser = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(35, 35)),
        'assets/images/location_user.png');
    pinLocationIconCar = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(35, 35)),
        'assets/images/location_car.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  //CustomFieldText Passengers
                  //child: TextField(),
                ))
              ],
            ),

            //Mapa
            FutureBuilder(
                future: location.getLocation(),
                builder: (_, AsyncSnapshot<LocationData> snapshot) {
                  if (snapshot.hasData) {
                    final locat = snapshot.data;
                    LatLng locationOri =
                        LatLng(locat?.latitude ?? 0.0, locat?.longitude ?? 0.0);
                    print(locationOri.latitude);

                    return Expanded(
                        child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(
                              latLngOrigen.latitude, latLngOrigen.longitude),
                          zoom: 15),
                      onMapCreated: (GoogleMapController controller) {},
                      mapToolbarEnabled: false,
                      myLocationEnabled: true,
                      markers: _createMarker(),
                      mapType: MapType.normal,
                    ));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ],
        ));
  }
}
