import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/components/buttons/CustomButton.dart';
import 'package:taxi_segurito_app/components/slider/slider.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/pages/list_request_client/list_request_client_functionality.dart';

class ListRequestClient extends StatefulWidget {
  ListRequestClient({Key? key}) : super(key: key);

  @override
  State<ListRequestClient> createState() => _ListRequestClientState();
}

class _ListRequestClientState extends State<ListRequestClient> {
  ListRequestClientFunctionality listRequestClientFunctionality =
      new ListRequestClientFunctionality();
  //rango
  late CustomSlider customSlider;

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
    //rango
    customSlider = new CustomSlider();

    final btnActualizar = new CustomButton(
      onTap: () {
        ClienRequest clienRequest = new ClienRequest.updateRange(
            '-N19THZozQ9wurM6uzLF', customSlider.getValue());
        listRequestClientFunctionality.update(clienRequest);
      },
      buttonText: "Actualizar rango",
      buttonColor: Color.fromRGBO(255, 193, 7, 1),
      buttonTextColor: Colors.white,
      marginBotton: 0,
      marginLeft: 5,
      marginRight: 0,
      marginTop: 0,
    );
    //rango
    Container containerRange = new Container(
      alignment: Alignment.centerLeft,
      margin: new EdgeInsets.only(
        top: 10.0,
        bottom: 10.0,
        left: 5.0,
        right: 5.0,
      ),
      padding: EdgeInsets.all(13),
      decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(203, 203, 203, 1),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              'Establecer nuevo rango: ',
            ),
            alignment: Alignment.topLeft,
          ),
          Container(
            child: customSlider,
            alignment: Alignment.topLeft,
          ),
          btnActualizar
        ],
      ),
    );

    return Scaffold(
        body: Container(
      child: containerRange,
    ));
  }
}
