import 'dart:async';

import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'package:sms_advanced/sms_advanced.dart';

import '../../strategis/firebase/implementation/send_ubication_driver.dart';

class SendMyUbication extends StatefulWidget {
  @override
  _SendMyUbication createState() => _SendMyUbication();
}

class _SendMyUbication extends State<SendMyUbication>
    with WidgetsBindingObserver {
  SendLocationDriver sendLocation = SendLocationDriver();
  var locationMess = "";
  final Location location = Location();

  StreamSubscription<LocationData>? _locationSubs;

  _getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

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
    final LocationData _locResult = await location.getLocation();
    //sendLocation.insertNode(currentLocation.altitude);
    setState(() {
      locationMess = _locResult.latitude.toString() +
          " \n" +
          _locResult.longitude.toString();
    });
  }

  Future<void> _listenLocation() async {
    location.enableBackgroundMode(enable: true);
    _locationSubs = location.onLocationChanged.handleError((onError) {
      _locationSubs?.cancel();
      setState(() {
        _locationSubs = null;
      });
    }).listen((LocationData currentLocation) async {
      setState(() {
        print(currentLocation.latitude.toString() +
            " \n" +
            currentLocation.longitude.toString());
        print('otro');
        locationMess = currentLocation.latitude.toString() +
            " \n" +
            currentLocation.longitude.toString();
      });
    });
  }

  _stopListening() {
    _locationSubs?.cancel();
    location.enableBackgroundMode(enable: false);

    setState(() {
      _locationSubs = null;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    _getLocation();
  }

  @override
  void deactivate() {
    super.deactivate();
    print('Se salio :v 2');
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
    print('Se salio :v');

    //WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("Location: " + state.name.toString());
    if (state == AppLifecycleState.detached &&
        state == AppLifecycleState.inactive) {
      // GeofenceService.instance.stop();
      _listenLocation();
      print('se detuvo');
    }
    if (state == AppLifecycleState.resumed) {
      // GeofenceService.instance.setup(...);
      print('nuevamente');
    }
    if (state == AppLifecycleState.detached) {
      //GeofenceService.instance.setup(...);
      print('se detuvo2');
      //_listenLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _listenLocation(),
      ),
      appBar: AppBar(
        title: Text('Ubicación'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(locationMess, style: TextStyle(fontSize: 40)),
            ElevatedButton(
                onPressed: () {
                  _stopListening();
                },
                child: Text('STOP'))
          ],
        ),
      ),
    );
  }
}
