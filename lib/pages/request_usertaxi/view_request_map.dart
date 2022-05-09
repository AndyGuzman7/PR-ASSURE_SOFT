import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/components/inputs/CustomTextField.dart';
import 'package:taxi_segurito_app/models/taxi_request.dart';
import 'package:taxi_segurito_app/pages/request_usertaxi/request_funcionality.dart';
import 'package:taxi_segurito_app/validators/TextFieldValidators.dart';

import '../../components/buttons/CustomButton.dart';

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
  late CustomTextField fieldPrice;
  RequestFunctionality taxiRequestFunctionality = new RequestFunctionality();
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
      taxiRequestFunctionality.initFirebase();
      setCustomMapPin();
      getRequest();
    });
  }

  Future<void> getRequest() async {
    //String? requestID = widget.requestID;
    String? requestID = "-N1aPDdp6doREQqbAKFL";
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
    final _formKey = GlobalKey<FormState>();
    bool registerRequest() {
      if (_formKey.currentState!.validate()) {
        return true;
      }
      return false;
    }

    final btnRegister = new CustomButton(
      onTap: () {
        if (registerRequest()) {
          TaxiRequest taxiRequest = new TaxiRequest(1, '-N19THZozQ9wurM6uzLF',
              '', double.parse(fieldPrice.getValue()));
          taxiRequestFunctionality.sendRequest(taxiRequest);
        }
      },
      buttonText: "Aceptar",
      buttonColor: Color.fromRGBO(255, 193, 7, 1),
      buttonTextColor: Colors.white,
      marginBotton: 0,
      marginLeft: 5,
      marginRight: 0,
      marginTop: 0,
    );

    final btnCancel = new CustomButton(
      onTap: () {},
      buttonText: "Declinar",
      buttonColor: Color.fromRGBO(240, 142, 136, 1),
      buttonTextColor: Colors.white,
      marginBotton: 0,
      marginLeft: 5,
      marginRight: 0,
      marginTop: 0,
    );

    fieldPrice = CustomTextField(
      hint: "Precio Estimado",
      multiValidator: MultiValidator([
        RequiredValidator(errorText: 'Tarifa requerido'),
        NumberValidator(errorText: 'No puede ingresar letras')
      ]),
      marginLeft: 0,
      marginRight: 0,
      marginTop: 15,
      marginBotton: 30,
      heightNum: 42,
    );

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          //Mapa
          FutureBuilder(
            future: location.getLocation(),
            builder: (_, AsyncSnapshot<LocationData> snapshot) {
              if (snapshot.hasData) {
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
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),

          Row(
            children: [
              Form(
                key: _formKey,
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    //CustomFieldText Passengers
                    child: Column(
                      children: [
                        fieldPrice,
                        Row(
                          children: [
                            Expanded(child: btnCancel),
                            Expanded(
                              child: btnRegister,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
