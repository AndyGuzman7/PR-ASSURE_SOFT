import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/components/buttons/CustomButton.dart';
import 'package:taxi_segurito_app/components/slider/slider.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/pages/v2_taxi_request/taxi_request_functionality.dart';
import 'package:taxi_segurito_app/services/sessions_service.dart';
import '../../components/inputs/CustomTextField.dart';
import '../../validators/TextFieldValidators.dart';

class TaxiRequestPage extends StatefulWidget {
  TaxiRequestPage({Key? key}) : super(key: key);

  @override
  State<TaxiRequestPage> createState() => _PruebaState();
}

class _PruebaState extends State<TaxiRequestPage> {
  Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();
  late CustomTextField fieldPassengers;
  late CustomSlider customSlider;
  Location location = Location();
  TaxiRequestFunctionality taxiRequestFunctionality =
      new TaxiRequestFunctionality();
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
    taxiRequestFunctionality.context = context;
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
          print("se quire enviar");
          ClienRequest clienRequest = new ClienRequest(
              0,
              '0',
              latLngOrigen.latitude,
              latLngOrigen.longitude,
              int.parse(fieldPassengers.getValue()),
              latLngDestino.latitude,
              latLngDestino.longitude,
              customSlider.getValue());
          taxiRequestFunctionality.insertNodeTaxiRequest(clienRequest);
        }
      },
      buttonText: "Enviar Solicitud",
      buttonColor: Color.fromRGBO(255, 193, 7, 1),
      buttonTextColor: Colors.white,
      marginBotton: 0,
      marginLeft: 5,
      marginRight: 0,
      marginTop: 0,
    );
    customSlider = new CustomSlider();
    fieldPassengers = CustomTextField(
      hint: "Número de pasajeros",
      multiValidator: MultiValidator([
        RequiredValidator(errorText: 'Número de pasajeros requerido'),
        NumberValidator(errorText: 'No puede ingresar letras')
      ]),
      marginLeft: 0,
      marginRight: 0,
      heightNum: 42,
    );

    Text title = new Text(
      "¿A donde vamos?",
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

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Formulario de servicio'),
        ),
        body: Column(
          children: [
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
                            containerTitle,
                            fieldPassengers,
                            Container(
                              child: Text("Rango de Busqueda",
                                  textAlign: TextAlign.right),
                            ),
                            customSlider,
                            btnRegister
                          ],
                        ),
                      ),
                    ))
              ],
            ),

            //Mapa
            FutureBuilder(
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
                        target:
                            LatLng(locationOri.latitude, locationOri.longitude),
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
          ],
        ));
  }
}
