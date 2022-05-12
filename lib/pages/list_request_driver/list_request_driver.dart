import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/models/driver_request.dart';
import 'package:taxi_segurito_app/pages/list_request_driver/list_request_driver_functionality.dart';
import 'package:taxi_segurito_app/pages/list_request_driver/widgets/request_list_driver.dart';

class ListRequestDriver extends StatefulWidget {
  ListRequestDriver({Key? key}) : super(key: key);

  @override
  State<ListRequestDriver> createState() => _ListRequestDriverState();
}

class _ListRequestDriverState extends State<ListRequestDriver> {
  List<DriverRequest> listRequest = [];

  ListRequestDriverFunctionality listRequestDriverFunctionality =
      new ListRequestDriverFunctionality();

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
    RequestListDriver requestList = RequestListDriver();
    requestList.listRequest = listRequest;
    requestList.callback = (value) {};

    listRequestDriverFunctionality.updateListRequest = ((value) {
      setState(() {
        listRequest = value;
        requestList.listRequest = listRequest;
        print("LISTA: " + listRequest.length.toString());
      });
    });

    return Scaffold(
        appBar: appBar,
        body: Container(
          color: Color.fromARGB(255, 248, 248, 248),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                title,
                Expanded(
                    child: Container(
                  child: requestList,
                ))
              ]),
        ));
  }
}
