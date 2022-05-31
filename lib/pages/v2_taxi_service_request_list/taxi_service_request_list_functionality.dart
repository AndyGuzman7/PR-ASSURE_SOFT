import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/models/estimate_taxi.dart';
import 'package:taxi_segurito_app/pages/v2_client_service_request_information/nameGalleryStateConfirmation.dart';
import 'package:taxi_segurito_app/pages/v2_view_taxi_request/view_taxi_request.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/service_request_estimates_impl.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/taxi_service_request_impl.dart';

class TaxiServiceRequestListPageFunctionality {
  List<ClienRequest> listRequest2 = [];
  late BuildContext context;

  late Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData locationData;
  TaxiServiceRequestImpl taxiServiceRequestImpl = new TaxiServiceRequestImpl();
  ServiceRequestEstimatesImpl serviceRequestEstimatesImpl =
      new ServiceRequestEstimatesImpl();
  late double latitudTaxi;
  late double longitudTaxi;
  late Function(List<ClienRequest>) updateListRequest;
  late Function(EstimateTaxi) showConfirmation;

  TaxiServiceRequestListPageFunctionality();

  void initListenerNodeFirebase() {
    try {
      listRequest2 = [];

      taxiServiceRequestImpl.getNodeEvent().listen((event) {
        listRequest2 = filtreRequestClientZoneRange(
            taxiServiceRequestImpl.convertJsonList(event));
        updateListRequest(listRequest2);
        for (var item in listRequest2) {
          print(item.idUser);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void listenConfirmationClient(list) {
    for (EstimateTaxi item in list) {
      serviceRequestEstimatesImpl = new ServiceRequestEstimatesImpl();
      serviceRequestEstimatesImpl
          .getConfirmationClientEvent(item.idFirebase)
          .listen((event) {
        listenEvent(event, item);
      });
    }
  }

  listenEvent(event, EstimateTaxi estimateTaxi) {
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.value == NameGalleryStateConfirmation.CONFIRMADO) {
      showConfirmation(estimateTaxi);
    }
  }

  void confirmationService(EstimateTaxi estimateTaxi) {
    serviceRequestEstimatesImpl
        .confirmateEstimateTaxi(
            estimateTaxi, NameGalleryStateConfirmation.CONFIRMADO)
        .then((value) {
      if (value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewTaxiRequest(
              estimate: estimateTaxi,
            ),
          ),
        );
      }
    });
  }

  List<ClienRequest> filtreRequestClientZoneRange(List<ClienRequest> value) {
    List<ClienRequest> listRequest = [];

    for (var item in value) {
      double latitudClient = item.latitudOrigen;
      double longitudClient = item.longitudOrigen;

      double distancia = getConvertKm(getDistance(
          latitudClient, longitudClient, latitudTaxi, longitudTaxi));
      print("distancia:  " + distancia.toString());
      if (distancia <= item.rango) {
        listRequest.add(item);
      }
    }
    return listRequest;
  }

  Future<bool> initServiceUbicationPermisson() async {
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

  initServiceUbication() {
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
