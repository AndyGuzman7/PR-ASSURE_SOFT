import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/components/buttons/CustomButtonWithLinearBorder.dart';
import 'package:taxi_segurito_app/pages/v2_view_user_request/view_taxi_request_functionality.dart';

class ViewUserRequest extends StatefulWidget {
  String idRequest;
  ViewUserRequest({Key? key, required this.idRequest}) : super(key: key);

  @override
  State<ViewUserRequest> createState() => _ViewUserRequestState();
}

class _ViewUserRequestState extends State<ViewUserRequest> {
  ViewTaxiRequestFunctionality viewTaxiRequestFunctionality =
      new ViewTaxiRequestFunctionality();

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
      showAlert();
    };

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Color.fromARGB(255, 248, 248, 248),
        child: Column(children: []),
      ),
    );
  }

  //AlertDialog confirm request
  void showAlert() {
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
          "Su solicitud fue cancelada por el taxista",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
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
            ),
          ],
        ),
      ),
    );
  }
}
