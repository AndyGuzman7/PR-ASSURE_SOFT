import 'package:flutter/cupertino.dart';
import 'package:taxi_segurito_app/pages/v2_list_request_driver/widgets/request_list_driver_item.dart';

class RequestListDriver extends StatefulWidget {
  List<dynamic>? listRequest = [];
  void Function(dynamic dynamicObject)? callback;
  _RequestListState _containerListViewState = new _RequestListState();
  RequestListDriver({Key? key, this.callback, this.listRequest})
      : super(key: key);

  @override
  _RequestListState createState() {
    return _containerListViewState;
  }

  set setCallback(function) {
    this.callback = function;
  }
}

class _RequestListState extends State<RequestListDriver> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Container(
      width: width,
      height: height,
      child: ListView.builder(
          itemCount: widget.listRequest?.length,
          itemBuilder: (context, index) {
            dynamic dynamicObj = widget.listRequest![index];

            print(index);
            return new RequestListItemDriver(
              driverRequest: dynamicObj,
              callbackRequest: (value) {
                widget.callback!(value);
              },
            );
          }),
    );
  }
}
