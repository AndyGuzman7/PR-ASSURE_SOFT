import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/models/estimate_taxi.dart';
import 'package:taxi_segurito_app/pages/v2_client_service_request_information/nameGalleryStateConfirmation.dart';
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
    var pleik = await sessionsService.getSessionValue("pleik");
    EstimateTaxi estimateTaxi = new EstimateTaxi(
        int.parse(idUser),
        NameGalleryStateConfirmation.SINCONFIRMAR,
        NameGalleryStateConfirmation.SINCONFIRMAR,
        serviceRequestEstimatesImpl.key,
        idServiceRequest,
        estimate,
        position.latitude,
        position.longitude,
        pleik.toString());

    serviceRequestEstimatesImpl.insertNode(estimateTaxi.toJson()).then((value) {
      if (value) {
        Navigator.pop(context, estimateTaxi);
      } else
        print("No se envio");
    });
  }
}
