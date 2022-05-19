import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/taxi_service_request_impl.dart';

class TaxiServiceRequestListPageFunctionality {
  List<ClienRequest> listRequest = [];

  late Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData locationData;

  late double latitudTaxi;
  late double longitudTaxi;
  late Function(List<ClienRequest>) updateListRequest;

  TaxiServiceRequestListPageFunctionality();
  void initListenerNodeFirebase() {
    try {
      TaxiServiceRequestImpl taxiServiceRequestImpl =
          new TaxiServiceRequestImpl();
      taxiServiceRequestImpl.getNodeEvent().listen((event) {
        listRequest = [];
        listRequest = taxiServiceRequestImpl.convertJsonList(event);
        listRequest = filtreRequestClientZoneRange(listRequest);
        updateListRequest(listRequest);
      });
    } catch (e) {
      print(e);
    }
  }

  filtreRequestClientZoneRange(value) {
    List<ClienRequest> listRequest = [];
    for (ClienRequest item in value) {
      double latitudClient = item.latitudOrigen;
      double longitudClient = item.longitudOrigen;

      double distancia = getConvertKm(getDistance(
          latitudClient, longitudClient, latitudTaxi, longitudTaxi));

      if (distancia <= item.rango) {
        listRequest.add(item);
      }
      return listRequest;
    }
  }

  Future<bool> initUbicacion() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  initServiceRequest() {
    getUbication().then((value) {
      latitudTaxi = value.latitude!;
      longitudTaxi = value.longitude!;
      initListenerNodeFirebase();
    });
  }

  Future<LocationData> getUbication() async {
    return locationData = await location.getLocation();
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
