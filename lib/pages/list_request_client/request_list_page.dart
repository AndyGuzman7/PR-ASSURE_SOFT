import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    listRequestClientFunctionality.updateListRequest = ((value) {
      setState(() {
        listRequest = value;
      });
    });

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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                child: RequestList(
                  listRequest: listRequest,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
