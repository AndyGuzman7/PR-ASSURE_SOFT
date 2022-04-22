import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/pages/taxi_request/taxi_request_functionality.dart';

class TaxiRequest extends StatefulWidget {
  TaxiRequest({Key? key}) : super(key: key);

  @override
  _TaxiRequestState createState() => _TaxiRequestState();
}

class _TaxiRequestState extends State<TaxiRequest> {
  TaxiRequestFunctionality taxiRequestFunctionality =
      new TaxiRequestFunctionality();

  int humedad = 0;
  int temperatura = 0;
  @override
  void initState() {
    super.initState();
    taxiRequestFunctionality.initFirebase();
    taxiRequestFunctionality.initUbicacion();
    taxiRequestFunctionality.updateData = updateData;
  }

  updateData(value) {
    print(value);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.clear_all,
                    color: Colors.red,
                  ),
                  Text(
                    "My Room",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.settings)
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "Temperatura",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        temperatura.toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Humedad",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    humedad.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            FloatingActionButton.extended(
                onPressed: () {
                  ClienRequest clienRequest =
                      new ClienRequest("casa", "cine", 1, 12, 12, 12);
                  taxiRequestFunctionality.sendRequest(clienRequest);
                },
                label: Text("Enviar Solicitud")),
          ],
        ));
  }
}
