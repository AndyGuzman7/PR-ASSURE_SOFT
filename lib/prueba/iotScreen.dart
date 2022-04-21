import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taxi_segurito_app/models/client_request.dart';

class IotScreen extends StatefulWidget {
  IotScreen({Key? key}) : super(key: key);

  @override
  _IotScreenState createState() => _IotScreenState();
}

class _IotScreenState extends State<IotScreen> {
  bool value = false;
  final dbRef = FirebaseDatabase.instance.reference();

  Future<void> writeData() async {
    dbRef.reference().child("LightState").set({"switch": value});
    dbRef.reference().child("Data").set({"Huminty": 0, "Temperatura": 0});
  }

  Future<void> writeDataUser() async {
    ClienRequest clienRequest = new ClienRequest("casa", "cine", 1, 12, 12, 12);
    dbRef
        .reference()
        .child("LightState2")
        .set({"destino": clienRequest.destino});
  }

  onUpdate() {
    setState(() {
      value = !value;
    });
  }

  var humedad = 0;
  var temperatura = 0;
  @override
  void initState() {
    super.initState();
    Stream<Event> streamBuilder = dbRef.child("Data").onValue;
    streamBuilder.listen((event) {
      print(event.snapshot.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: dbRef.child("Data").onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              dbRef.child("Data").once().then((DataSnapshot value) {
                setState(() {
                  humedad = value.value["Huminty"];
                  temperatura = value.value["Temperatura"];
                });
              });

              return Column(
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
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
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
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          humedad.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FloatingActionButton.extended(
                      onPressed: () {
                        onUpdate();
                        writeData();
                        writeDataUser();
                      },
                      label: Text("ON"))
                ],
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
