import 'package:flutter/material.dart';
import '../request_list_functionality.dart';
import 'request_list_item.dart';

class RequestList extends StatefulWidget {
  List<dynamic>? listRequest = [];
  void Function(dynamic dynamicObject)? callback;
  _RequestListState _containerListViewState = new _RequestListState();
  RequestList({Key? key, this.callback, this.listRequest}) : super(key: key);

  @override
  _RequestListState createState() {
    return _containerListViewState;
  }

  set setCallbak(function) {
    this.callback = function;
  }

  /* updateListView() { 
    _containerListViewState.updateListView();
  }*/
}

class _RequestListState extends State<RequestList> {
  /*updateListView() {
    setState(
      () {
        widget.listRequest = listCompany;
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Container(
      height: height,
      width: width,
      child: ListView.builder(
        itemCount: widget.listRequest!.length,
        itemBuilder: (context, index) {
          dynamic dinamycOb = widget.listRequest![index];
          return new RequestListItem(
            clientRequest: dinamycOb,
            callbackRequest: (value) {
              widget.callback!(value);
            },
          );
        },
      ),
    );
  }
}
