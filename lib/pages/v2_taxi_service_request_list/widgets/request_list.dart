import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/models/estimate_taxi.dart';
import 'package:taxi_segurito_app/pages/v2_taxi_service_request_list/widgets/request_list_item.dart';
import 'package:taxi_segurito_app/pages/v2_taxi_services_estimate_list/widgets/estimate_list_item.dart';

class RequestList extends StatefulWidget {
  List<ClienRequest>? clienRequestList = [];
  List<ClienRequest>? clienRequestlistDelete = [];
  void Function(ClienRequest clienRequest)? callback;
  _RequestListState _containerListViewState = new _RequestListState();
  RequestList({Key? key, this.callback}) : super(key: key);

  @override
  _RequestListState createState() {
    return _containerListViewState;
  }

  set setCallback(function) {
    this.callback = function;
  }

  updateList(List<ClienRequest>? clienRequestList) {
    _containerListViewState.updateList(clienRequestList);
  }
}

class _RequestListState extends State<RequestList> {
  late GlobalKey<RefreshIndicatorState> refreshListKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    print("init state");
  }

  updateList(List<ClienRequest>? clienRequestList) {
    setState(() {
      widget.clienRequestList = clienRequestList;
    });
  }

  Widget showList() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Container(
      height: height,
      width: width,
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: widget.clienRequestList!.length,
        itemBuilder: (BuildContext context, int index) {
          return rowItem(context, index);
        },
      ),
    );
  }

  Widget rowItem(context, index) {
    dynamic dinamycOb = widget.clienRequestList![index];

    return Dismissible(
      key: Key(widget.clienRequestList![index].toString()),
      onDismissed: (direction) {
        var item = widget.clienRequestList![index];
        widget.clienRequestlistDelete!.add(item);
        //showSnackBar(context, item, index);
        removeItem(index);
      },
      resizeDuration: new Duration(seconds: 2),
      background: deleteItem(),
      child: Card(
        child: new RequestListItem(
          clientRequest: dinamycOb,
          callbackRequest: (value) {
            widget.callback!(value);
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
    /*taxiServicesEstimatesListFunctionality.updateListRequest = ((value) {
      setState(() {
        listEstimates = value;
      });
    });*/
  }

  undoDelete(index, item) {
    setState(() {
      widget.clienRequestList!.insert(index, item);
    });
  }

  removeItem(index) {
    setState(() {
      widget.clienRequestList!.removeAt(index);
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

  verificationItemsRemove() {
    List<ClienRequest>? clienRequestlistAuxDelete = [];
    widget.clienRequestList!.forEach((element) {
      if (widget.clienRequestlistDelete!
          .any((s) => s.idFirebase == element.idFirebase)) {
        clienRequestlistAuxDelete.add(element);
      }
    });

    widget.clienRequestList!
        .removeWhere((element) => clienRequestlistAuxDelete.contains(element));
  }

  @override
  Widget build(BuildContext context) {
    verificationItemsRemove();
    print("build");
    print(widget.clienRequestList!.length);
    //print(widget.clienRequestlistDelete!.length);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      key: UniqueKey(),
      child: showList(),
      onRefresh: () async {
        await refreshList();
      },
    );
  }
}
