import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/components/buttons/CustomButtonWithLinearBorder.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/models/estimate_taxi.dart';

import 'package:taxi_segurito_app/pages/v2_list_request_driver/list_request_driver_functionality.dart';
import 'package:taxi_segurito_app/pages/v2_list_request_driver/widgets/request_list_driver.dart';
import 'package:taxi_segurito_app/pages/v2_taxi_request/taxi_request_functionality.dart';

import '../../components/buttons/CustomButton.dart';
import '../../components/slider/slider.dart';

class ListRequestDriver extends StatefulWidget {
  String idRequest;
  ListRequestDriver({Key? key, required this.idRequest}) : super(key: key);

  @override
  State<ListRequestDriver> createState() => _ListRequestDriverState();
}

class _ListRequestDriverState extends State<ListRequestDriver> {
  List<EstimateTaxi> listRequest = [];

  ListRequestDriverFunctionality listRequestDriverFunctionality =
      new ListRequestDriverFunctionality();
  late CustomSlider customSlider;
  @override
  void initState() {
    super.initState();
    listRequestDriverFunctionality.initUbication().then((value) {
      if (value) {
        listRequestDriverFunctionality.initServiceRequest();
      } else {
        print('null aqui en linea 27');
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
    listRequestDriverFunctionality.context = context;
    RequestListDriver requestList = RequestListDriver();
    requestList.listRequest = listRequest;
    requestList.callback = (value) {};
    customSlider = new CustomSlider();

    final btnActualizar = new CustomButton(
      onTap: () {
        ClienRequest clienRequest = new ClienRequest.updateRange(
            '-N1vLO9946XQ4MXqRkys', customSlider.getValue());
        Navigator.pop(context);
        TaxiRequestFunctionality().updateRequestRange(clienRequest);
      },
      buttonText: "Actualizar rango",
      buttonColor: Color.fromRGBO(255, 193, 7, 1),
      buttonTextColor: Colors.white,
      marginBotton: 10,
      marginLeft: 0,
      marginRight: 0,
      marginTop: 0,
    );

    listRequestDriverFunctionality.updateListRequest = ((value) {
      setState(() {
        listRequest = value;
        requestList.listRequest = listRequest;
        print("LISTA: " + listRequest.length.toString());
      });
    });

    showAlertDialog() {
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
        listRequestDriverFunctionality.deleteRequest(widget.idRequest);
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
        showAlertDialog();
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
            Expanded(
              child: Container(
                child: requestList,
              ),
            ),
            Container(
              child: btnCancel,
              margin: new EdgeInsets.fromLTRB(10, 10, 10, 10),
            ),
          ],
        ),
      ),
    );
  }
}
