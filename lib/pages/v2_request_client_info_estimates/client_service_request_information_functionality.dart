import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/models/estimate_taxi.dart';
import 'package:taxi_segurito_app/pages/v2_list_request_client/taxi_service_request_list_page.dart';
import 'package:taxi_segurito_app/pages/v2_list_request_driver/taxi_services_estimate_list_page.dart';
import 'package:taxi_segurito_app/pages/v2_request_client_info_estimates/nameGalleryStateConfirmation.dart';
import 'package:taxi_segurito_app/services/sessions_service.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/service_request_estimates_impl.dart';

class ClientServiceRequestInformationFunctionality {
  var idTaxi;
  SessionsService sessionsService = new SessionsService();

  late Location location = new Location();
  late BuildContext context;

  Function(String)? updateData;

  ClientServiceRequestInformationFunctionality();

  insertNodeEstimates(estimate, idServiceRequest) async {
    ServiceRequestEstimatesImpl serviceRequestEstimatesImpl =
        new ServiceRequestEstimatesImpl();
    Position position = await Geolocator.getCurrentPosition();
    var idUser = await sessionsService.getSessionValue('id');
    EstimateTaxi estimateTaxi = new EstimateTaxi(
        int.parse(idUser),
        NameGalleryStateConfirmation.SINCONFIRMAR,
        NameGalleryStateConfirmation.SINCONFIRMAR,
        serviceRequestEstimatesImpl.key,
        idServiceRequest,
        estimate,
        position.latitude,
        position.longitude,
        "");

    serviceRequestEstimatesImpl.insertNode(estimateTaxi.toJson()).then((value) {
      if (value) {
        Navigator.pop(context, estimateTaxi);
      } else
        print("No se envio");
    });
  }

  Future<void> getIdSessionIdTaxi() async {
    idTaxi = await sessionsService.getSessionValue("id");
    print(idTaxi);
  }
}
