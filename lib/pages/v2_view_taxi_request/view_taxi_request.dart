import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/components/buttons/CustomButton.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/models/estimate_taxi.dart';
import 'package:taxi_segurito_app/pages/v2_view_taxi_request/view_taxi_request_functionality.dart';
import 'package:taxi_segurito_app/strategis/convert_distance.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/taxi_service_request_impl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dialog_reason.dart';

// ignore: must_be_immutable
class ViewTaxiRequest extends StatefulWidget {
  EstimateTaxi? estimate;

  ViewTaxiRequest({this.estimate});
  @override
  State<ViewTaxiRequest> createState() => _ViewTaxiRequestState();
}

class _ViewTaxiRequestState extends State<ViewTaxiRequest> {
  late LatLng latLngOrigen = LatLng(0, 0);
  late LatLng latLngDestino = LatLng(0, 0);

  late String distancia = "Ninguna";
  late String passengers = "Ninguno";
  Map<MarkerId, Marker> _markers = {};

  late String idEstimateTaxi = "";

  Set<Marker> get markers => _markers.values.toSet();

  Location location = Location();

  //Creation of markers
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
      getNodeItemInformation();
    });
  }

  //Get request data from Firebase
  getNodeItemInformation() {
    TaxiServiceRequestImpl taxiServiceRequestImpl =
        new TaxiServiceRequestImpl();

    taxiServiceRequestImpl
        .getNodeItem(widget.estimate!.idTaxiServiceRequest)
        .then((value) {
      ClienRequest clienRequest = value;
      setState(() {
        distancia = ConvertDistance().getDistance(clienRequest);
        passengers = clienRequest.numeroPasageros.toString();
        latLngOrigen =
            LatLng(clienRequest.latitudOrigen, clienRequest.longitudOrigen);

        latLngDestino =
            LatLng(clienRequest.latitudDestino, clienRequest.longitudDestino);
      });
    });

    /*taxiServiceRequestImpl.getIdRequest(widget.serviceRequestId).then((value) {
      setState(() {
        idEstimateTaxi = value;
      });
    });*/
  }

  //Load bookmark icons
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

    closeView() {
      Navigator.pop(context);
    }

    //button that displays the dialog for canceling the request
    final btnActive = new CustomButton(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => DialogReason(
            idFirebase: widget.estimate!.idFirebase,
            callBackCancel: () {
              closeView();
            },
          ),
        );
      },
      buttonText: "Cancelar Solicitud",
      buttonColor: Color.fromRGBO(255, 193, 7, 1),
      buttonTextColor: Colors.white,
      marginBotton: 0,
      marginLeft: 0,
      marginRight: 0,
      marginTop: 0,
    );

    Text title = new Text(
      "Servicio en marcha",
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
      child: title,
    );

    //Left side image container
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

    //Right side container: Distance and number of passengers information
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
                    ),
              )
            ],
          ),
          //Map
          FutureBuilder(
            future: location.getLocation(),
            builder: (_, AsyncSnapshot<LocationData> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target:
                          LatLng(latLngOrigen.latitude, latLngOrigen.longitude),
                      zoom: 15,
                    ),
                    onMapCreated: (GoogleMapController controller) {},
                    mapToolbarEnabled: false,
                    myLocationEnabled: true,
                    markers: _createMarker(),
                    mapType: MapType.normal,
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                //CustomFieldText Passengers
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: btnActive,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ))
            ],
          ),
        ],
      ),
    );
  }
}
