import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/components/buttons/CustomButtonWithLinearBorder.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/models/estimate_taxi.dart';
import 'package:taxi_segurito_app/pages/v2_client_service_request_information/client_service_request_information_page.dart';

import 'package:taxi_segurito_app/pages/v2_taxi_service_request_list/taxi_service_request_list_functionality.dart';
import 'package:taxi_segurito_app/pages/v2_taxi_service_request_list/widgets/request_list.dart';
import 'package:taxi_segurito_app/pages/v2_taxi_service_request_list/widgets/request_list_item.dart';
import 'package:taxi_segurito_app/services/sessions_service.dart';

class TaxiServiceRequestListPage extends StatefulWidget {
  TaxiServiceRequestListPage({Key? key}) : super(key: key);

  @override
  State<TaxiServiceRequestListPage> createState() =>
      _TaxiServiceRequestListPageState();
}

class _TaxiServiceRequestListPageState
    extends State<TaxiServiceRequestListPage> {
  List<ClienRequest>? clienRequest = [];
  List<EstimateTaxi> listEstimates = [];

  late GlobalKey<RefreshIndicatorState> refreshListKey;

  late String idUserTaxista = "-N1vHdpBe2km7i6xJbkz";
  late bool estadoSolicitud = false;

  Color colorMain = Color.fromRGBO(255, 193, 7, 1);
  Color colorMainDanger = Color.fromRGBO(242, 78, 30, 1);
  Color colorMainNull = Color.fromARGB(255, 244, 123, 123);

  TaxiServiceRequestListPageFunctionality listRequestClientFunctionality =
      new TaxiServiceRequestListPageFunctionality();
  @override
  void initState() {
    super.initState();

    listRequestClientFunctionality
        .initServiceUbicationPermisson()
        .then((value) {
      if (value) {
        listRequestClientFunctionality.initServiceUbication();
        listRequestClientFunctionality.updateListRequest = ((value) {
          setState(() {
            clienRequest = value;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    listRequestClientFunctionality.context = context;
    listRequestClientFunctionality.showConfirmation = (value) {
      showAlert(value);
    };

    RequestList requestList = new RequestList(
      clienRequest: clienRequest,
      callback: (value) async {
        EstimateTaxi? result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClientServiceRequestInformationPage(
              serviceRequestId: value.idFirebase,
            ),
          ),
        );

        if (result != null) listEstimates.add(result);
        listRequestClientFunctionality.listenConfirmationClient(listEstimates);
      },
    );

    Text title = new Text(
      "Lista de Solicitudes",
      style: const TextStyle(
          fontSize: 25.0, color: Colors.black, fontWeight: FontWeight.w700),
      textAlign: TextAlign.left,
    );

    AppBar appbar = new AppBar(
      foregroundColor: Colors.white,
      elevation: 0,
      title: Container(
        alignment: Alignment.center,
        child: Text(
          "Servicios de Taxi",
          style: TextStyle(),
        ),
      ),
    );
    return Scaffold(
      appBar: appbar,
      body: Container(
        color: Color.fromARGB(255, 248, 248, 248),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            title,
            Expanded(child: requestList),
          ],
        ),
      ),
    );
  }

  boxData(value) {
    return new Container(
      alignment: Alignment.centerLeft,
      child: value,
    );
  }

//AlertDialog confirm request
  void showAlert(EstimateTaxi estimateTaxi) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        title: Text(
          "Se acepto la cotizacion",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            boxData(
              Text(
                'Estimacion: ' + estimateTaxi.estimacion.toString(),
              ),
            ),
            boxData(
              Text(
                'Distancia: ' + "23" + ' Km',
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomButtonWithLinearBorder(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      buttonBorderColor: colorMainNull,
                      marginBotton: 0,
                      marginLeft: 0,
                      marginRight: 0,
                      marginTop: 0,
                      buttonText: "Rechazar",
                      buttonColor: Colors.white,
                      buttonTextColor: colorMainNull),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CustomButtonWithLinearBorder(
                      onTap: () {
                        Navigator.pop(context);
                        listRequestClientFunctionality
                            .confirmationService(estimateTaxi);
                      },
                      buttonBorderColor: colorMainDanger,
                      marginBotton: 0,
                      marginLeft: 0,
                      marginRight: 0,
                      marginTop: 0,
                      buttonText: "Aceptar",
                      buttonColor: Colors.white,
                      buttonTextColor: colorMainDanger),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
