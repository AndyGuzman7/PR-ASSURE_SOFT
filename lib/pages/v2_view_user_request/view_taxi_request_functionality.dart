import 'package:firebase_database/firebase_database.dart';
import 'package:taxi_segurito_app/pages/v2_client_service_request_information/nameGalleryStateConfirmation.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/request_view_taxi_impl.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/service_request_estimates_impl.dart';

class ViewTaxiRequestFunctionality {
  ServiceRequestEstimatesImpl serviceRequestEstimatesImpl =
      new ServiceRequestEstimatesImpl();

  RequestViewTaxiImpl requestViewTaxiImpl = new RequestViewTaxiImpl();

  late Function() showConfirmation;

  ViewTaxiRequestFunctionality();

  void initListenerNodeFirebase(String idRequest) {
    try {
      requestViewTaxiImpl.getNodeEvent(idRequest).listen((event) {
        listenEvent(event);
      });
    } catch (e) {
      print(e);
    }
  }

  listenEvent(event) {
    DataSnapshot snapshot = event.snapshot;
    print(snapshot.value);
    if (snapshot.value == NameGalleryStateConfirmation.CANCELADO) {
      showConfirmation();
    }
  }

  void sendReasonCancel(idFirebase, motivo) {
    //value, motivo, status
    serviceRequestEstimatesImpl
        .cancelEstimateTaxi(
            idFirebase, motivo, NameGalleryStateConfirmation.CANCELADO)
        .then(
          (value) => {
            print("Se inserto con exito"),
          },
        );
  }
}