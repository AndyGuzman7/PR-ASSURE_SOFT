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

  late String distancia = "Ninguna";
  late String passengers = "Ninguno";

  Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();

  Location location = Location();

  //Creacion de marcadores
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

  //Obtener informacion desde Firebase
  Future<void> getRequest() async {
    String? requestID = widget.requestID;
    var clienRequest = (await FirebaseDatabase.instance
            .reference()
            .child("Request/$requestID")
            .once())
        .value;
    setState(() {
      distancia = "400m";
      passengers = clienRequest["numeroPasajeros"].toString();
      latLngOrigen =
          LatLng(clienRequest["latitudOrigen"], clienRequest["longitudOrigen"]);

      latLngDestino = LatLng(
          clienRequest["latitudDestino"], clienRequest["longitudDestino"]);
    });
  }

  //Cargar iconos de marcadores
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
    Image imagedefault = new Image.asset(
      "assets/images/user_icon.png",
    );

    Text title = new Text(
      "Lista de Solicitudes",
      style: const TextStyle(
          fontSize: 25.0, color: Colors.black, fontWeight: FontWeight.w700),
      textAlign: TextAlign.left,
    );

    final containerTitle = new Container(
        alignment: Alignment.centerLeft,
        margin: new EdgeInsets.only(
          top: 5.0,
          bottom: 10.0,
          left: 0.0,
          right: 35.0,
        ),
        child: title);
    //Contenedor de imagen del lado izquierdo
    Container columnOne = new Container(
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 70,
          height: 70,
          margin: EdgeInsets.all(0),
          decoration: BoxDecoration(
              image:
                  DecorationImage(image: imagedefault.image, fit: BoxFit.cover),
              shape: BoxShape.circle),
        ),
      ),
    );

    //Contenedor del lado derecho: Informacion de distancia y Numero de pasajeros
    Container columnTwo = new Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
        left: 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              'Distancia: ' + distancia,
            ),
            alignment: Alignment.topLeft,
          ),
          Container(
            child: Text(
              'Pasajeros: ' + passengers,
            ),
            alignment: Alignment.topLeft,
          ),
        ],
      ),
    );

    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            containerTitle,
                            Container(
                              margin: new EdgeInsets.only(
                                top: 10.0,
                                bottom: 10.0,
                                left: 5.0,
                                right: 5.0,
                              ),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromRGBO(203, 203, 203, 1),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 0,
                                    child: columnOne,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: columnTwo,
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
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
