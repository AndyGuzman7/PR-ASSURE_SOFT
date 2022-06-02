import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/send_ubication_driver.dart';
import 'package:taxi_segurito_app/strategis/firebaseService.dart';

class LocationService {
  late Location location = new Location();
  late bool serviceEnabled;
  late PermissionStatus permissionGranted;
  late LocationData locationData;

  SendLocationDriver sendLocation = SendLocationDriver();
  var locationMess = "";

  SendLocationDriver sendLocationDriver = new SendLocationDriver();
  StreamSubscription<LocationData>? locationSubs;

  Future<bool> getPermisson() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return true;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return true;
      }
    }

    return false;
  }

  Future<LocationData> getUbication() async {
    return await location.getLocation();
  }

  //Future<void> _listenLocation()
  //listen to the location of the taxi driver
  //and then transfer the data to firebase and
  //can be consumed elsewhere
  Future<void> listenLocation() async {
    //activate Background mode, if the user exit the application
    location.enableBackgroundMode(enable: true);
    //IN CASE AN ERROR OCCURS
    locationSubs = location.onLocationChanged.handleError((onError) {
      locationSubs?.cancel();
    }).listen(
      (LocationData currentLocation) async {
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
      },
    );
  }

//StopListening():
  //stopping the service once the taxi driver's service is finished
  stopListening() {
    locationSubs?.cancel();
    location.enableBackgroundMode(enable: false);

    locationSubs = null;
  }
}
