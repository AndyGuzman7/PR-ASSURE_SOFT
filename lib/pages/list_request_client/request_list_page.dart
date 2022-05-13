import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/pages/list_request_client/location.dart';
import 'package:taxi_segurito_app/pages/list_request_client/request_list_functionality.dart';
import 'package:taxi_segurito_app/pages/list_request_client/widgets/request_list.dart';
import 'package:taxi_segurito_app/pages/list_request_client/widgets/request_list_item.dart';


class ListRequestClient extends StatefulWidget {
  ListRequestClient({Key? key}) : super(key: key);

  @override
  State<ListRequestClient> createState() => _ListRequestClientState();
}

class _ListRequestClientState extends State<ListRequestClient> {
  late List<ClienRequest> listRequest;
  late GlobalKey<RefreshIndicatorState> refreshListKey;
  RequestList requestList = new RequestList(); 

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

    refreshListKey = new GlobalKey<RefreshIndicatorState>();
    listRequest = new List<ClienRequest>.empty(growable: true);
  }

  Widget showList(){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Container(
      height: height,
      width: width,
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: requestList.listRequest!.length,
        itemBuilder: (BuildContext context, int index){
          return rowItem(context, index); 
        }
      )
    );
  }

  Widget rowItem(context, index){
      dynamic dinamycOb = requestList.listRequest![index];
      
      return Dismissible(
        key: Key(listRequest[index].toString()),
        onDismissed: (direction){
          var item = listRequest[index];
          showSnackBar(context, item, index);
          removeItem(index);   
        },
        resizeDuration: new Duration(seconds:2),
        background: deleteItem(),
        
        child: Card(
          
          child: new RequestListItem(
            clientRequest: dinamycOb,
            callbackRequest: (value) {
            requestList.callback!(value);},
          ),
        ),
      );
  }

  showSnackBar(context, item, index){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$item removido de la lista'),
        action: SnackBarAction(
          label: "NO REMOVER SOLICITUD",
          onPressed: (){
            undoDelete(index, item);
          }
        ),
      )
    );
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    addRandomItem();
    return null;
  }

  addRandomItem(){
    listRequestClientFunctionality.updateListRequest = ((value) {
      setState(() {
        listRequest = value;
        requestList.listRequest = listRequest;
        requestList.listRequest!.add(listRequest);
      });
    });
  }

  undoDelete(index, item){
    setState(() {
      listRequest.insert(index, item);
    });
  }

  removeItem(index){
    setState((){
      listRequest.removeAt(index);
    });
  }

  Widget deleteItem(){
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20),
      color: Colors.blue,
      child: Icon(Icons.delete, color: Colors.white),

    );
  }

  @override
  Widget build(BuildContext context) {
   
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
          ],
        ),
      ),
    );
  }
}
