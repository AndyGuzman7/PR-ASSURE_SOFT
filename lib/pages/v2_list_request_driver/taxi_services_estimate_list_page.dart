import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/components/buttons/CustomButtonWithLinearBorder.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/models/estimate_taxi.dart';

import 'package:taxi_segurito_app/pages/v2_list_request_driver/taxi_services_estimate_list_functionality.dart';
import 'package:taxi_segurito_app/pages/v2_list_request_driver/widgets/estimate_list.dart';
import 'package:taxi_segurito_app/pages/v2_view_user_request/view_user_request.dart';

import '../../components/buttons/CustomButton.dart';
import '../../components/slider/slider.dart';

class TaxiServicesEstimateListPage extends StatefulWidget {
  String idRequestService;
  TaxiServicesEstimateListPage({Key? key, required this.idRequestService})
      : super(key: key);

  @override
  State<TaxiServicesEstimateListPage> createState() =>
      _TaxiServicesEstimateListPageState();
}

class _TaxiServicesEstimateListPageState
    extends State<TaxiServicesEstimateListPage> {
  late List<EstimateTaxi> listEstimates = [];
  late EstimateTaxi selectedEstimateTaxi;
  TaxiServicesEstimatesListFunctionality
      taxiServicesEstimatesListFunctionality =
      new TaxiServicesEstimatesListFunctionality();

  Color colorMain = Color.fromRGBO(255, 193, 7, 1);
  Color colorMainDanger = Color.fromRGBO(242, 78, 30, 1);
  Color colorMainNull = Color.fromARGB(255, 244, 123, 123);

  @override
  void initState() {
    super.initState();
    taxiServicesEstimatesListFunctionality.initUbication().then((value) {
      if (value) {
        taxiServicesEstimatesListFunctionality
            .startServices(widget.idRequestService);
      }
    });
  }

  AppBar appBar = new AppBar(
    automaticallyImplyLeading: false,
    title: Container(
      alignment: Alignment.center,
      child: Text(
        "Servicio de taxi",
        style: TextStyle(),
      ),
    ),
  );

  Text title = new Text(
    "Lista de Estimaciones",
    style: const TextStyle(
        fontSize: 25.0, color: Colors.black, fontWeight: FontWeight.w700),
    textAlign: TextAlign.left,
  );

  @override
  Widget build(BuildContext context) {
    taxiServicesEstimatesListFunctionality.context = context;
    taxiServicesEstimatesListFunctionality.updateListRequest = ((value) {
      setState(() {
        listEstimates = value;
      });
    });
    taxiServicesEstimatesListFunctionality.showConfirmation = () {
      showConfirmServiceTaxi(context);
    };

    EstimateList estimateListv2 = new EstimateList(
      listEstimates: listEstimates,
      callback: (value) {
        showInformationSelectedEstimate(value);
      },
    );

    final customSlider = new CustomSlider();

    final btnActualizar = new CustomButton(
      onTap: () {
        ClienRequest clienRequest = new ClienRequest.updateRange(
            widget.idRequestService, customSlider.getValue());

        taxiServicesEstimatesListFunctionality
            .updateRangeRequestService(clienRequest);
        Navigator.pop(context);
      },
      buttonText: "Actualizar rango",
      buttonColor: Color.fromRGBO(255, 193, 7, 1),
      buttonTextColor: Colors.white,
      marginBotton: 10,
      marginLeft: 0,
      marginRight: 0,
      marginTop: 0,
    );

    showDialogUpdateRange() {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
            titleTextStyle: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
            title: Container(
              child: Text(
                'Establecer nuevo rango: ',
              ),
              alignment: Alignment.topLeft,
            ),
            backgroundColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [customSlider],
            ),
            actions: [btnActualizar],
          );
        },
      );
    }

    final btnCancel = new CustomButtonWithLinearBorder(
      onTap: () {
        taxiServicesEstimatesListFunctionality
            .deleteNodeService(widget.idRequestService);
      },
      buttonText: "Cancelar Solicitud",
      buttonColor: Color.fromRGBO(255, 193, 7, 1),
      buttonTextColor: Colors.white,
      marginBotton: 0,
      buttonBorderColor: Color.fromRGBO(255, 193, 7, 1),
      marginLeft: 5,
      marginRight: 0,
      marginTop: 0,
    );

    final btnUpdateRange = new CustomButtonWithLinearBorder(
      onTap: () {
        showDialogUpdateRange();
      },
      buttonText: "Actualizar Rango",
      buttonColor: Color.fromRGBO(255, 193, 7, 1),
      buttonTextColor: Colors.white,
      marginBotton: 0,
      buttonBorderColor: Color.fromRGBO(255, 193, 7, 1),
      marginLeft: 5,
      marginRight: 0,
      marginTop: 0,
    );

    return Scaffold(
      appBar: appBar,
      body: Container(
        color: Color.fromARGB(255, 248, 248, 248),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            title,
            Container(
              margin: new EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: btnUpdateRange,
            ),
            Expanded(child: estimateListv2),
            Container(
              child: btnCancel,
              margin: new EdgeInsets.fromLTRB(10, 10, 10, 10),
            ),
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

  showConfirmationSelectedEstimate(EstimateTaxi estimateTaxi) {
    final btnAceptar = new CustomButtonWithLinearBorder(
      onTap: () {
        taxiServicesEstimatesListFunctionality
            .confirmationEstimate(estimateTaxi.idFirebase);
        Navigator.pop(context);
      },
      buttonText: "Si",
      buttonColor: Color.fromRGBO(255, 193, 7, 1),
      buttonTextColor: Colors.white,
      marginBotton: 0,
      buttonBorderColor: Color.fromRGBO(255, 193, 7, 1),
      marginLeft: 5,
      marginRight: 0,
      marginTop: 0,
    );

    final btnRechazar = new CustomButtonWithLinearBorder(
      onTap: () {
        Navigator.pop(context);
      },
      buttonText: "No",
      buttonColor: Color.fromRGBO(255, 193, 7, 1),
      buttonTextColor: Colors.white,
      marginBotton: 0,
      buttonBorderColor: Color.fromRGBO(255, 193, 7, 1),
      marginLeft: 5,
      marginRight: 0,
      marginTop: 0,
    );

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(28))),
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
          title: Container(
            child: Text(
              'Estas seguro que aceptas esta cotizacion?',
            ),
            alignment: Alignment.topLeft,
          ),
          backgroundColor: Colors.white,
          content: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: [
              Expanded(child: btnAceptar),
              Expanded(child: btnRechazar)
            ],
          ),
        );
      },
    );
  }

  showInformationSelectedEstimate(EstimateTaxi estimateTaxi) {
    selectedEstimateTaxi = estimateTaxi;
    final btnConfirm = new CustomButtonWithLinearBorder(
      onTap: () {
        Navigator.pop(context);
        showConfirmationSelectedEstimate(estimateTaxi);
      },
      buttonText: "Aceptar Cotizacion",
      buttonColor: Color.fromRGBO(255, 193, 7, 1),
      buttonTextColor: Colors.white,
      marginBotton: 0,
      buttonBorderColor: Color.fromRGBO(255, 193, 7, 1),
      marginLeft: 5,
      marginRight: 0,
      marginTop: 20,
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(28))),
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
          title: Container(
            child: Text(
              'Cotización del Taxista',
            ),
            alignment: Alignment.topLeft,
          ),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: [
              boxData(
                Text(
                  'Precio: ' + estimateTaxi.estimacion.toString(),
                ),
              ),
              boxData(Text(
                'Distancia: ' + estimateTaxi.distancia.toString() + ' Km',
              )),
              boxData(Text(
                "Placa: " + estimateTaxi.placa.toString(),
              )),
              btnConfirm
            ],
          ),
        );
      },
    );
  }

  void showConfirmServiceTaxi(BuildContext context) {
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
          "Solcitud Aceptada\nLa Solicitud de Servicio\nfue Aceptada, pronto\nllegara el taxi",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        content: Row(
          children: [
            Expanded(
              child: CustomButtonWithLinearBorder(
                  onTap: () {
                    //routeInitial
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewUserRequest(
                            idRequest: selectedEstimateTaxi.idFirebase,
                            idTaxi: selectedEstimateTaxi.idUserTaxi,
                          ),
                        ));
                  },
                  buttonBorderColor: colorMainDanger,
                  marginBotton: 0,
                  marginLeft: 0,
                  marginRight: 0,
                  marginTop: 0,
                  buttonText: "Ver Ubicación",
                  buttonColor: Colors.white,
                  buttonTextColor: colorMainDanger),
            ),
          ],
        ),
      ),
    );
  }
}
