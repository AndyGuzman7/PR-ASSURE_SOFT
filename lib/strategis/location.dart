import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/strategis/firebaseService.dart';

class LocationService {
  var latitudeGlobal = 0.0; //= currentLocation.latitude;
  var longitudeGlobal = 0.0;

  /// = currentLocation.longitude;
  late final nameBranch = "Request";
  late final dbRef;
  late Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData locationData;

  late double latitudTaxi;
  late double longitudTaxi;

  Future<bool> initUbicacion() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return true;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return true;
      }
    }

    return true;
  }

  int value = 0;

  void getUbication() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      print(currentLocation);
      var latitude = currentLocation.latitude;
      var longitude = currentLocation.longitude;
      var kmDiference = getConvertKm(
          getDistance(latitude!, longitude!, latitudeGlobal, longitudeGlobal));
      print(kmDiference);
      if (kmDiference > 5) {
        FirebaseService firebaseService = new FirebaseService();
        firebaseService.initFirebase();
        firebaseService.sendFirebase(value++);

        ///current user location
      }
      print("leyendo ubicacion");

      latitudeGlobal = latitude;
      longitudeGlobal = longitude;
    });
  }

  double getDistance(
      double startLat, double starLong, double endLat, double endLong) {
    double distance =
        Geolocator.distanceBetween(startLat, starLong, endLat, endLong);

    return distance;
  }

  double getConvertKm(double distanceMeters) {
    double varMeters = distanceMeters;
    double varKm = varMeters / 1000;
    double rangeDistance = double.parse((varKm).toStringAsFixed(2));
    print(varMeters);
    print(varKm);
    print(rangeDistance);

    return rangeDistance;
  }

  bool rangeBetween(int rangeSlider) {
    var response = true;
    var valueDistance =
        getDistance(52.2165157, 6.9437819, 52.3546274, 4.8285838);
    var valueRange = getConvertKm(valueDistance);
    if (valueRange <= rangeSlider) {
      return response;
    }
    return false;
  }
}
