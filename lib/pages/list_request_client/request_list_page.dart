import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/pages/list_request_client/location.dart';
import 'package:taxi_segurito_app/pages/list_request_client/request_list_functionality.dart';
import 'package:taxi_segurito_app/pages/list_request_client/widgets/request_list.dart';

class ListRequestClient extends StatefulWidget {
  ListRequestClient({Key? key}) : super(key: key);

  @override
  State<ListRequestClient> createState() => _ListRequestClientState();
}

class _ListRequestClientState extends State<ListRequestClient> {
  List<ClienRequest> listRequest = [];

  ListRequestClientFunctionality listRequestClientFunctionality =
      new ListRequestClientFunctionality();
  @override
  void initState() {
    super.initState();
    listRequestClientFunctionality.initUbicacion().then((value) {
      if (value) {
        listRequestClientFunctionality.initServiceRequest();
      }
    });
    LocationService locationService = new LocationService();
    locationService.initUbicacion().then((value) {
      locationService.getUbication();
    });
  }

  @override
  Widget build(BuildContext context) {
    RequestList requestList = new RequestList();
    requestList.listRequest = listRequest;
    requestList.callback = (value) {};

    listRequestClientFunctionality.updateListRequest = ((value) {
      setState(() {
        listRequest = value;
        requestList.listRequest = listRequest;
      });
    });

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
            Expanded(
              child: Container(child: requestList),
            )
          ],
        ),
      ),
    );
  }
}
