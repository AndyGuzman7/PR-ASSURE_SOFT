import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/components/buttons/CustomButton.dart';
import 'package:taxi_segurito_app/components/buttons/CustomButtonWithLinearBorder.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/models/estimate_taxi.dart';
import 'package:taxi_segurito_app/pages/v2_taxi_service_request_list/taxi_service_request_list_page.dart';
import 'package:taxi_segurito_app/pages/v2_view_taxi_request/view_taxi_request_functionality.dart';
import 'package:taxi_segurito_app/strategis/convert_distance.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/taxi_service_request_impl.dart';
import 'package:taxi_segurito_app/strategis/location_service.dart';

import 'dialog_reason.dart';

// ignore: must_be_immutable
class ViewTaxiRequest extends StatefulWidget {
  EstimateTaxi? estimate;

  ViewTaxiRequest({this.estimate});
  @override
  State<ViewTaxiRequest> createState() => _ViewTaxiRequestState();
}

class _ViewTaxiRequestState extends State<ViewTaxiRequest> {
  LocationService locationService = new LocationService();
  late LatLng latLngOrigen = LatLng(0, 0);
  late LatLng latLngDestino = LatLng(0, 0);

  late String distancia = "Ninguna";
  late String passengers = "Ninguno";
  Map<MarkerId, Marker> _markers = {};

  late String idEstimateTaxi = "";

  Set<Marker> get markers => _markers.values.toSet();

  Location location = Location();

  ViewTaxiRequestFunctionality viewTaxiRequestFunctionality =
      new ViewTaxiRequestFunctionality();

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

    locationService.getPermisson();
    locationService.listenLocation(widget.estimate!.idUserTaxi);
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
      locationService.stopListening();
      Navigator.pop(context, widget.estimate);
    }

    //AlertDialog terminate service
    void showFinishService() {
      Color colorMain = Color.fromRGBO(255, 193, 7, 1);
      Color colorMainDanger = Color.fromRGBO(242, 78, 30, 1);
      Color colorMainNull = Color.fromARGB(255, 244, 123, 123);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          title: Text(
            "Desea finalizar el servicio?",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomButtonWithLinearBorder(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        buttonBorderColor: colorMainNull,
                        marginBotton: 0,
                        marginLeft: 0,
                        marginRight: 0,
                        marginTop: 0,
                        buttonText: "Rechazar",
                        buttonColor: Colors.white,
                        buttonTextColor: colorMainNull),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomButtonWithLinearBorder(
                        onTap: () {
                          viewTaxiRequestFunctionality.sendTerminateService(
                              widget.estimate!.idFirebase,
                              widget.estimate!.idUserTaxi);
                          Navigator.pop(context);
                          //locationService.stopListening();
                          closeView();
                        },
                        buttonBorderColor: colorMainDanger,
                        marginBotton: 0,
                        marginLeft: 0,
                        marginRight: 0,
                        marginTop: 0,
                        buttonText: "Confirmar",
                        buttonColor: Colors.white,
                        buttonTextColor: colorMainDanger),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    //button that displays the dialog for canceling the request
    final btnCancelRequest = new CustomButton(
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

    //BUtton terminate service
    final btnTerminate = new CustomButton(
      onTap: () {
        showFinishService();
      },
      buttonText: "Finalizar Solicitud",
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: title,
      ),
      body: WillPopScope(
        onWillPop: () async => false,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
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
                        target: LatLng(
                            latLngOrigen.latitude, latLngOrigen.longitude),
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
                            Expanded(child: btnCancelRequest),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: btnTerminate,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
