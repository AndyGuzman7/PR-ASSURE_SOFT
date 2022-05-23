import 'package:taxi_segurito_app/pages/v2_request_client_info_estimates/nameGalleryStateConfirmation.dart';
import 'package:taxi_segurito_app/strategis/firebase/implementation/service_request_estimates_impl.dart';

class ViewTaxiRequestFunctionality {
  ServiceRequestEstimatesImpl serviceRequestEstimatesImpl =
      new ServiceRequestEstimatesImpl();
  ViewTaxiRequestFunctionality();

  void sendReasonCancel(idFirebase, motivo) {
    //value, motivo, status
    serviceRequestEstimatesImpl
        .cancelEstimate(
            idFirebase, motivo, NameGalleryStateConfirmation.CANCELADO)
        .then(
          (value) => {
            print("Se inserto con exito"),
          },
        );
  }
}
