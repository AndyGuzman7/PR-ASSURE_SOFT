import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/components/buttons/CustomButton.dart';
import 'package:taxi_segurito_app/components/slider/slider.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/pages/v2_taxi_request/taxi_request_functionality.dart';
import 'package:taxi_segurito_app/pages/v2_taxi_request/widgets/view_map.dart';

import 'package:taxi_segurito_app/services/sessions_service.dart';
import '../../components/inputs/CustomTextField.dart';
import '../../validators/TextFieldValidators.dart';

class TaxiRequestPage extends StatefulWidget {
  TaxiRequestPage({Key? key}) : super(key: key);

  @override
  State<TaxiRequestPage> createState() => _PruebaState();
}

class _PruebaState extends State<TaxiRequestPage> {
  late CustomTextField fieldPassengers;
  late CustomSlider customSlider;
  Location location = Location();
  TaxiRequestFunctionality taxiRequestFunctionality =
      new TaxiRequestFunctionality();

  Color colorMain = Color.fromRGBO(255, 193, 7, 1);

  @override
  Widget build(BuildContext context) {
    taxiRequestFunctionality.context = context;
    final _formKey = GlobalKey<FormState>();
    final taxiRequestMap = new ViewMap();

    bool registerRequest() {
      if (_formKey.currentState!.validate()) {
        return true;
      }
      return false;
    }

    final btnRegister = new CustomButton(
      onTap: () {
        if (registerRequest()) {
          late LatLng latLngOrigen = taxiRequestMap.getLocationOrigen();
          late LatLng latLngDestino = taxiRequestMap.getLocationDestino();

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
      typeIput: TextInputType.number,
      hint: "Número de pasajeros",
      multiValidator: MultiValidator([
        RequiredValidator(errorText: 'Número de pasajeros requerido'),
        NumberValidator(errorText: 'No puede ingresar letras'),
        NumberValidatorZero(errorText: 'No se permite 0')
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
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Form(
              key: _formKey,
              child: Expanded(
                  child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      containerTitle,
                      fieldPassengers,
                      Container(
                        child: Text("Rango de Busqueda",
                            textAlign: TextAlign.right),
                      ),
                      customSlider,
                      btnRegister,
                      Column(children: [taxiRequestMap]),
                    ],
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
