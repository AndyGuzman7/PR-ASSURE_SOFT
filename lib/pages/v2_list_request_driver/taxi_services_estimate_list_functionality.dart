import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/models/driver.dart';

import 'package:location/location.dart';
import 'package:taxi_segurito_app/models/estimate_taxi.dart';
import 'package:taxi_segurito_app/pages/v2_list_request_client/taxi_service_request_list_functionality.dart';

import 'package:taxi_segurito_app/strategis/firebase/implementation/service_request_estimates_impl.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/taxi_service_request_impl.dart';

class ListRequestDriverFunctionality {
  List<EstimateTaxi> listDriverReq = [];
  late BuildContext context;

  late double latitudClient;
  late double longitudClient;
  late String placaTaxi;
  late String imagenTaxi;
  late double estimacion;
  late Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  TaxiServiceRequestListPageFunctionality clientFunctionality =
      TaxiServiceRequestListPageFunctionality();
  late Function(List<EstimateTaxi>) updateListRequest;

  late Future<List<Driver>> drivers;

  late final dbRef;

  Function(String)? updateData;

  void initListenerNodeFirebase(idRequestService) {
    try {
      ServiceRequestEstimatesImpl serviceRequestEstimatesImpl =
          new ServiceRequestEstimatesImpl();
      serviceRequestEstimatesImpl.getNodeEvent().listen((event) {
        print(event.snapshot.value);
        listDriverReq = [];
        listDriverReq = serviceRequestEstimatesImpl.convertJsonList(event);
        listDriverReq =
            filtreRequestClientZoneRange(listDriverReq, idRequestService);
        updateListRequest(listDriverReq);
      });
    } catch (e) {
      print(e);
    }
  }

  filtreRequestClientZoneRange(value, idRequestService) {
    List<EstimateTaxi> estimateTaxiList = [];
    for (EstimateTaxi item in value) {
      double distance = clientFunctionality.getConvertKm(
          clientFunctionality.getDistance(
              item.latitud, item.longitud, latitudClient, longitudClient));
      item.distancia = distance;
      print(item.idFirebase);
      print(idRequestService.toString() + " idRequestService");
      if (item.idTaxiServiceRequest == idRequestService) {
        estimateTaxiList.add(item);
      }
    }
    return estimateTaxiList;
  }

  Future<bool> initUbication() async {
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

  void updateRangeRequestService(ClienRequest clienRequest) {
    TaxiServiceRequestImpl taxiServiceRequestImpl =
        new TaxiServiceRequestImpl();
    taxiServiceRequestImpl.updateRange(clienRequest).then((value) {
      if (value) {
        print("Se actualizo el rango");
      } else
        print("No se envio");
    });
  }

  Future<LocationData> getUbication() async {
    _locationData = await location.getLocation();
    print(_locationData.toString() + "AAA");
    return _locationData;
  }

  deleteNodeService(value) {
    TaxiServiceRequestImpl taxiServiceRequestImpl =
        new TaxiServiceRequestImpl();
    taxiServiceRequestImpl.deleteNode(value).then((value) {
      if (value) {
        Navigator.pushNamed(context, 'taxiRequestScreen');
      } else
        print("No se envio");
    });
  }

  initServiceRequest(valu) {
    getUbication().then((value) {
      latitudClient = value.latitude!;
      longitudClient = value.longitude!;
      initListenerNodeFirebase(valu);
    });
  }
}
