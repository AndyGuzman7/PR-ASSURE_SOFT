import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/send_ubication_driver.dart';

class ReceiveLocationDriver extends StatefulWidget {
  @override
  _ReceiveLocationDriver createState() => _ReceiveLocationDriver();
}

class _ReceiveLocationDriver extends State<ReceiveLocationDriver> {
  final Location location = Location();
  late GoogleMapController _controller;
  bool _added = true;
  SendLocationDriver sendLocation = SendLocationDriver();

  getNodeItemInformation() async {
    // try {
    //   DataSnapshot snap =
    //     await FirebaseDatabase.instance.reference().child("latitude").once();
    //   print(snap.value);
    // } catch (e) {
    //   print(e);
    // }
    SendLocationDriver sendLocationDriver = new SendLocationDriver();
    late LocationData locationData;

    // sendLocationDriver
    //     .getNodeEvent()
    //     .then((value) => {print(value.toString() + "   AQUI ESTAMOSSSS")});
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Taxista en camino...'),
      ),
      // body: GoogleMap(
      //   initialCameraPosition: _kGooglePlex,
      //   mapType: MapType.hybrid,
      // ),
      body: FutureBuilder(
        future: location.getLocation(),
        builder: (context, AsyncSnapshot<LocationData> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("a"), //CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text("aaaa"),
            ); //getNodeItemInformation(); //Center(
            //     child: GoogleMap(
            //   initialCameraPosition: CameraPosition(
            //       target: LatLng(-19.036639, -65.2592666), zoom: 15),
            //   mapToolbarEnabled: false,
            //   mapType: MapType.normal,
            // )
            //);
          }
          //GoogleMap(initialCameraPosition: CameraPosition(target: LatLng());
        },
      ),
    );
  }
}
