import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/components/buttons/CustomButtonWithLinearBorder.dart';
import 'package:taxi_segurito_app/models/estimate_taxi.dart';
import 'package:taxi_segurito_app/pages/v2_list_request_driver/widgets/request_list_driver_item_functionality.dart';
import 'package:taxi_segurito_app/services/notifications.dart';

class RequestListItemDriver extends StatefulWidget {
  void Function(EstimateTaxi estimateTaxi) callbackRequest;
  EstimateTaxi? driverRequest;
  RequestListItemDriver(
      {Key? key, this.driverRequest, required this.callbackRequest})
      : super(key: key);

  @override
  _RequestListItemState createState() => _RequestListItemState();
}

class _RequestListItemState extends State<RequestListItemDriver> {
  Color colorMain = Color.fromRGBO(255, 193, 7, 1);
  Color colorMainDanger = Color.fromRGBO(242, 78, 30, 1);
  Color colorMainNull = Color.fromRGBO(153, 153, 153, 1);
  //ListRequestDriverFunctionality listRequestDriverFunctionality = new ListRequestDriverFunctionality();
  RequestListItemFunctionality requestListItemFunctionality =
      new RequestListItemFunctionality();

  final NotificationsFirebase notificationsFirebase = new NotificationsFirebase();
  @override
  void initState() {
    super.initState();
    
    notificationsFirebase.subscribeToTopic(Topic: 'ConfirmEstimate');
  }

  sendNotificationConfirm(){
      String title = "Cotizacion aceptada";
      String body = "Se acepto la cotizacion del cliente";
      String token = "e53nf4hyRVGCGbJ9-1wIrP:APA91bH8JqmbIBng_R4xh68yJgO3GUM5LVTEq75afZwE-MU5CCjC604UNmwAWhwoBwWx5m2st3ZdGQ_G6sXVP_fRf-fFTnwVg0a-iNX6HwIdLEIWizsVkVik_PabugvdbaihZSDLvzgh";
      String client = "Marco Aurelio";
      notificationsFirebase.sendNotificationToTaxi(Token: token, Title: title, Body: body, Client: client);
  }

  @override
  Widget build(BuildContext context) {
    requestListItemFunctionality.context = context;
    Image imagedefault = new Image.asset(
      "assets/images/user_default.png",
    );

    //evento donde se envia el mensaje de confirmado al taxista
    final btnAceptar = new CustomButtonWithLinearBorder(
      onTap: () {
        requestListItemFunctionality.confirmationEstimate(widget.driverRequest!.idRequestTaxiFirebase);
        sendNotificationConfirm();
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

    boxData(value) {
      return new Container(
        alignment: Alignment.centerLeft,
        child: value,
      );
    }


    showMessage() {
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

    //evento click para confirmar la cotizacion
    final btnConfirm = new CustomButtonWithLinearBorder(
      onTap: () {
        Navigator.pop(context);
        showMessage();
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

    //pantalla emergente para confirmar la cotizacion
    showAlertDialog() {
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
                    'Precio: ' + widget.driverRequest!.estimacion.toString(),
                  ),
                ),
                boxData(Text(
                  'Distancia: ' +
                      widget.driverRequest!.distancia.toString() +
                      ' Km',
                )),
                boxData(Text(
                  "Placa: " + widget.driverRequest!.placa.toString(),
                )),
                btnConfirm
              ],
            ),
          );
        },
      );
    }

    Container columnOne = new Container(
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 70,
          height: 70,
          margin: EdgeInsets.all(0),
          decoration: BoxDecoration(
              image:
                  DecorationImage(image: imagedefault.image, fit: BoxFit.cover),
              shape: BoxShape.circle),
        ),
      ),
    );

    Container columnTwo = new Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
        left: 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          boxData(
            Text(
              'Precio: ' + widget.driverRequest!.estimacion.toString(),
            ),
          ),
          boxData(Text(
            'Distancia: ' + widget.driverRequest!.distancia.toString() + ' Km',
          )),
          boxData(Text(
            "Placa: " + widget.driverRequest!.placa.toString(),
          )),
        ],
      ),
    );

    Container columnThree = new Container(
      height: 60,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Align(
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
                alignment: Alignment.center,
              ),
            )
          ],
        ),
      ),
    );

    Container containerOwnerData = new Container(
      height: 110,
      color: Color.fromARGB(255, 187, 187, 187),
      margin:
          new EdgeInsets.only(top: 5.0, bottom: 5.0, left: 00.0, right: 00.0),
      child: Material(
        child: InkWell(
          onTap: () {
            showAlertDialog();
          },
          child: Container(
            margin: new EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              left: 20.0,
              right: 20.0,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 0,
                  child: columnOne,
                ),
                Expanded(
                  flex: 1,
                  child: columnTwo,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return containerOwnerData;
  }
}
