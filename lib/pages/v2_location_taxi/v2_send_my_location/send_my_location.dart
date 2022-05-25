import 'dart:async';

import 'package:flutter/material.dart';

import 'package:location/location.dart';

import '../../../strategis/firebase/implementation/send_ubication_driver.dart';

class SendMyUbication extends StatefulWidget {
  @override
  _SendMyUbication createState() => _SendMyUbication();
}

class _SendMyUbication extends State<SendMyUbication>
    with WidgetsBindingObserver {
  SendLocationDriver sendLocation = SendLocationDriver();
  var locationMess = "";
  final Location location = Location();
  SendLocationDriver sendLocationDriver = new SendLocationDriver();
  StreamSubscription<LocationData>? _locationSubs;

  //GetLocation obtains the location of the taxi driver 
  //requesting the corresponding permits
  _getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    //Permits getting
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

    //Result It is assigned to variable string locationMess
    final LocationData _locResult = await location.getLocation();
    setState(() {
      locationMess = _locResult.latitude.toString() +
          " \n" +
          _locResult.longitude.toString();
    });
  }

  //Future<void> _listenLocation()
  //listen to the location of the taxi driver 
  //and then transfer the data to firebase and 
  //can be consumed elsewhere
  Future<void> _listenLocation() async {

    //activate Background mode, if the user exit the application
    location.enableBackgroundMode(enable: true);
    //IN CASE AN ERROR OCCURS
    _locationSubs = location.onLocationChanged.handleError((onError) {
      _locationSubs?.cancel();
      setState(() {
        _locationSubs = null;
      }); //ELSE
    }).listen((LocationData currentLocation) async {
      setState(() {
        print(currentLocation.latitude.toString() +
            " \n" +
            currentLocation.longitude.toString());
        print('otro');
        locationMess = currentLocation.latitude.toString() +
            " \n" +
            currentLocation.longitude.toString();
        sendLocationDriver
            .insertNode(currentLocation)
            .then((value) => print(value));
      });
    });
  }

  //StopListening():
  //stopping the service once the taxi driver's service is finished
  _stopListening() {
    _locationSubs?.cancel();
    location.enableBackgroundMode(enable: false);

    setState(() {
      _locationSubs = null;
    });
  }

  
  //when initialize the widget
  @override
  void initState() {
    super.initState();
    //Controls for clycle life
    WidgetsBinding.instance!.addObserver(this);
    _getLocation();
  }
  //when close the widget
  @override
  void dispose() {

    super.dispose();
    print('Salir');
    //remove the controls for clycle life
    WidgetsBinding.instance!.removeObserver(this);
  }
  //Events for controls of widget cycle life
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
      print('vuelve a entrar a la aplicacion');
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
                child: Text('STOP')),
          ],
        ),
      ),
    );
  }
}
