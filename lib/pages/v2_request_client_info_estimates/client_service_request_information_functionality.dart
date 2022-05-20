import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:taxi_segurito_app/models/estimate_taxi.dart';
import 'package:taxi_segurito_app/pages/v2_list_request_client/taxi_service_request_list_page.dart';
import 'package:taxi_segurito_app/pages/v2_list_request_driver/taxi_services_estimate_list_page.dart';
import 'package:taxi_segurito_app/services/sessions_service.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/service_request_estimates_impl.dart';

class ClientServiceRequestInformationFunctionality {
  var idTaxi;
  SessionsService sessionsService = new SessionsService();
  late final nameBranch = "RequestTaxi";
  late final dbRef;
  late String key;
  late Location location = new Location();
  late BuildContext context;

  Function(String)? updateData;

  ClientServiceRequestInformationFunctionality();
  void initFirebase() {
    dbRef = FirebaseDatabase.instance.reference();

    key = dbRef.reference().child(nameBranch).push().key.toString();
  }

  void update(value) {
    updateData!(value);
  }

  Future<void> sendRequest(EstimateTaxi taxiRequest) async {
    taxiRequest.idFirebase = key;
    dbRef.reference().child(nameBranch).child(key).set(taxiRequest.toJson());
    print(key);
  }

  insertNodeEstimates(estimate, idServiceRequest) async {
    ServiceRequestEstimatesImpl serviceRequestEstimatesImpl =
        new ServiceRequestEstimatesImpl();
    Position position = await Geolocator.getCurrentPosition();
    var idUser = await sessionsService.getSessionValue('id');
    EstimateTaxi estimateTaxi = new EstimateTaxi(
        int.parse(idUser),
        serviceRequestEstimatesImpl.key,
        idServiceRequest,
        estimate,
        position.latitude,
        position.longitude,
        "");

    serviceRequestEstimatesImpl.insertNode(estimateTaxi.toJson()).then((value) {
      if (value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaxiServiceRequestListPage(),
          ),
        );
      } else
        print("No se envio");
    });
  }

  Future<void> sendEstiamtes(double cotization) async {
    Position position = await Geolocator.getCurrentPosition();
    getIdSessionIdTaxi();
    idTaxi = await sessionsService.getSessionValue("id");
    EstimateTaxi estimateTaxi = new EstimateTaxi(
        int.parse(idTaxi),
        key,
        "-N1vLO9946XQ4MXqRkys",
        cotization,
        position.latitude,
        position.longitude,
        "");

    dbRef.reference().child(nameBranch).child(key).set(estimateTaxi.toJson());
    //print(key);
  }

  Future<void> getIdSessionIdTaxi() async {
    idTaxi = await sessionsService.getSessionValue("id");
    print(idTaxi);
  }

  void getInstance() {
    return dbRef;
  }
}
