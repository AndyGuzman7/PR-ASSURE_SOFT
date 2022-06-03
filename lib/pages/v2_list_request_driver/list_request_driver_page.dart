import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/components/buttons/CustomButtonWithLinearBorder.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/models/estimate_taxi.dart';

import 'package:taxi_segurito_app/pages/v2_list_request_driver/list_request_driver_functionality.dart';
import 'package:taxi_segurito_app/pages/v2_list_request_driver/widgets/request_list_driver.dart';
import 'package:taxi_segurito_app/pages/v2_taxi_request/taxi_request_functionality.dart';
import 'package:taxi_segurito_app/pages/v2_list_request_driver/widgets/request_list_driver_item.dart';


import '../../components/buttons/CustomButton.dart';
import '../../components/slider/slider.dart';

import 'package:taxi_segurito_app/services/notifications.dart';

class ListRequestDriver extends StatefulWidget {
  String idRequest;
  ListRequestDriver({Key? key, required this.idRequest}) : super(key: key);

  @override
  State<ListRequestDriver> createState() => _ListRequestDriverState();
}

class _ListRequestDriverState extends State<ListRequestDriver> {
  List<EstimateTaxi> listRequest = [];
  RequestListDriver requestList = RequestListDriver();
  ListRequestDriverFunctionality listRequestDriverFunctionality =
      new ListRequestDriverFunctionality();
  late CustomSlider customSlider;
  late GlobalKey<RefreshIndicatorState> refreshListKey;
  final NotificationsFirebase notificationsFirebase = new NotificationsFirebase();
  @override
  void initState() {
    super.initState();
    
    notificationsFirebase.subscribeToTopic(Topic: 'ConfirmEstimate');
    listRequestDriverFunctionality.initUbication().then((value) {
      if (value) {
        listRequestDriverFunctionality.initServiceRequest();
      } else {
        print('null aqui en linea 27');
      }
    });

    refreshListKey = new GlobalKey<RefreshIndicatorState>();
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

  Widget showList() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Container(
        height: height,
        width: width,
        child: ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: requestList.listRequest!.length,
            itemBuilder: (BuildContext context, int index) {
              return rowItem(context, index);
            }));
  }

  Widget rowItem(context, index) {
    dynamic dinamycOb = requestList.listRequest![index];

    return Dismissible(
      key: Key(listRequest[index].toString()),
      onDismissed: (direction) {
        var item = listRequest[index];
        showSnackBar(context, item, index);
        removeItem(index);
      },

      resizeDuration: new Duration(seconds: 2),
      background: deleteItem(),

      child: Card(
        child: new RequestListItemDriver(
          driverRequest: dinamycOb,
          callbackRequest: (value) {
            requestList.callback!(value);
          },
        ),
      ),
    );
  }

  showSnackBar(context, item, index) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Elemento removido de la lista'),
      action: SnackBarAction(
          label: "NO REMOVER COTIZACION",
          onPressed: () {
            undoDelete(index, item);
          }),
    ));
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    addRandomItem();
    return null;
  }

  addRandomItem() {
    
    listRequestDriverFunctionality.updateListRequest = ((value) {
      setState(() {
        listRequest = value;
        requestList.listRequest = listRequest;
        requestList.listRequest!.add(listRequest);
      });
    });

  }

  undoDelete(index, item) {
    setState(() {
      listRequest.insert(index, item);
    });
  }

  removeItem(index) {
    setState(() {
      listRequest.removeAt(index);
    });
  }

  Widget deleteItem() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20),
      color: Colors.blue,
      child: Icon(Icons.delete, color: Colors.white),
    );
  }


  @override
  Widget build(BuildContext context) {
    listRequestDriverFunctionality.context = context;
    
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
                child: RefreshIndicator(
                  key: refreshListKey,
                  child: showList(),
                  onRefresh: () async {
                    await refreshList();
                  },                 
                ),
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
