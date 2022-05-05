import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/pages/list_request_client/list_request_client_functionality.dart';

class ListRequestClient extends StatefulWidget {
  ListRequestClient({Key? key}) : super(key: key);

  @override
  State<ListRequestClient> createState() => _ListRequestClientState();
}

class _ListRequestClientState extends State<ListRequestClient> {
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
    return Scaffold(
        body: Container(
      child: Text("Aqui va la lista"),
    ));
  }
}
