import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/models/client_request.dart';

import 'package:location/location.dart';
import 'package:taxi_segurito_app/models/estimate_taxi.dart';
import 'package:taxi_segurito_app/pages/v2_client_service_request_information/nameGalleryStateConfirmation.dart';
import 'package:taxi_segurito_app/pages/v2_taxi_service_request_list/taxi_service_request_list_functionality.dart';

import 'package:taxi_segurito_app/strategis/firebase/implementation/service_request_estimates_impl.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/taxi_service_request_impl.dart';

class TaxiServicesEstimatesListFunctionality {
  List<EstimateTaxi> listEstimateTaxi = [];
  late BuildContext context;

  late double latitudClient;
  late double longitudClient;

  late Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  TaxiServiceRequestListPageFunctionality clientFunctionality =
      TaxiServiceRequestListPageFunctionality();
  late Function(List<EstimateTaxi>) updateListRequest;
  late Function() showConfirmation;
  ServiceRequestEstimatesImpl serviceRequestEstimatesImpl =
      new ServiceRequestEstimatesImpl();

  void initListenerNodeFirebase(idRequestService) {
    try {
      serviceRequestEstimatesImpl.getNodeEvent().listen((event) {
        print(event.snapshot.value);
        listEstimateTaxi = [];
        listEstimateTaxi = serviceRequestEstimatesImpl.convertJsonList(event);
        listEstimateTaxi =
            filtreRequestClientZoneRange(listEstimateTaxi, idRequestService);
        updateListRequest(listEstimateTaxi);
      });
    } catch (e) {
      print(e);
    }
  }

  void listenNodeFirebaseStatus(idEstimate) {
    serviceRequestEstimatesImpl
        .getConfirmationTaxiEvent(idEstimate)
        .listen((event) {
      String value = event.snapshot.value;
      print("fsdf");
      if (value == NameGalleryStateConfirmation.CONFIRMADO) {
        showConfirmation();
      } else {
        //statusRequest = false;
      }
    });
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

  confirmationEstimate(key) {
    serviceRequestEstimatesImpl
        .confirmateEstimateClient(key, NameGalleryStateConfirmation.CONFIRMADO)
        .then((value) {
      if (value) {
        showSnackBar(context);
        listenNodeFirebaseStatus(key);
      }
    });
  }

  sendConfirmNotification(token) {
    //envio de notificaciones al taxista
    
  }

  showSnackBar(contex) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Confirmacion Enviada'),
      ),
    );
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
        Navigator.pop(context);
      } else
        print("No se envio");
    });
  }

  startServices(valu) {
    getUbication().then((value) {
      latitudClient = value.latitude!;
      longitudClient = value.longitude!;
      initListenerNodeFirebase(valu);
    });
  }
}
