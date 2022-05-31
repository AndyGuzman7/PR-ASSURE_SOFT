import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/components/buttons/CustomButtonWithLinearBorder.dart';
import 'package:taxi_segurito_app/models/driver.dart';
import 'package:taxi_segurito_app/pages/v2_view_user_request/calification_page.dart';
import 'package:taxi_segurito_app/pages/v2_view_user_request/view_user_request_functionality.dart';

class ViewUserRequest extends StatefulWidget {
  String idRequest;
  int idTaxi;
  ViewUserRequest({Key? key, required this.idRequest, required this.idTaxi})
      : super(key: key);

  @override
  State<ViewUserRequest> createState() => _ViewUserRequestState();
}

class _ViewUserRequestState extends State<ViewUserRequest> {
  ViewUserRequestFunctionality viewTaxiRequestFunctionality =
      new ViewUserRequestFunctionality();

  Color colorMain = Color.fromRGBO(255, 193, 7, 1);
  Color colorMainDanger = Color.fromRGBO(242, 78, 30, 1);
  Color colorMainNull = Color.fromARGB(255, 244, 123, 123);

  @override
  void initState() {
    super.initState();
    print(widget.idRequest);
    viewTaxiRequestFunctionality.initListenerNodeFirebase(widget.idRequest);
  }

  @override
  Widget build(BuildContext context) {
    viewTaxiRequestFunctionality.showConfirmation = () {
      showAlert(1, "Su solicitud fue cancelada por el taxista");
    };

    viewTaxiRequestFunctionality.showTerminateService = () {
      showAlert(2, "El servicio fue finalizado con exito");
    };

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Color.fromARGB(255, 248, 248, 248),
        child: Column(children: []),
      ),
    );
  }

  //AlertDialog confirm terminate service or cancel service
  void showAlert(int value, String message) {
    final text = Text(
      message,
      textAlign: TextAlign.center,
    );

    final buttonMenu = Row(
      children: [
        Expanded(
          child: new CustomButtonWithLinearBorder(
            onTap: () {
              Navigator.pop(context);
            },
            buttonText: "Volver al menu",
            buttonColor: Color.fromRGBO(255, 193, 7, 1),
            buttonTextColor: Colors.white,
            marginBotton: 0,
            buttonBorderColor: Color.fromRGBO(255, 193, 7, 1),
            marginLeft: 5,
            marginRight: 0,
            marginTop: 0,
          ),
        ),
      ],
    );

    final buttonsCalification = Row(
      children: [
        Expanded(
          child: new CustomButtonWithLinearBorder(
            onTap: () {
              Navigator.pop(context);
            },
            buttonText: "Volver al menu",
            buttonColor: Color.fromRGBO(255, 193, 7, 1),
            buttonTextColor: Colors.white,
            marginBotton: 0,
            buttonBorderColor: Color.fromRGBO(255, 193, 7, 1),
            marginLeft: 5,
            marginRight: 0,
            marginTop: 0,
          ),
        ),
        Expanded(
          child: new CustomButtonWithLinearBorder(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CalificationPage(widget.idTaxi)),
              );
            },
            buttonText: "Calificar",
            buttonColor: Color.fromRGBO(255, 193, 7, 1),
            buttonTextColor: Colors.white,
            marginBotton: 0,
            buttonBorderColor: Color.fromRGBO(255, 193, 7, 1),
            marginLeft: 5,
            marginRight: 0,
            marginTop: 0,
          ),
        ),
      ],
    );

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
        title: text,
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (value == 1) buttonMenu,
            if (value == 2) buttonsCalification,
          ],
        ),
      ),
    );
  }
}
