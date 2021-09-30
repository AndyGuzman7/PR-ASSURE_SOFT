import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/models/Driver.dart';

class CustomCardSimple extends StatefulWidget {
  _CustomCardSimpleState _customCardSimpleState = new _CustomCardSimpleState();
  String? headerText;
  String? namePerson;
  String? ciPerson;
  String? phonePerson;
  VoidCallback ontap;
  VoidCallback ontapCloseDialog;
  Driver? driver;
  CustomCardSimple(
      {Key? key, required this.ontap, required this.ontapCloseDialog})
      : super(key: key);

  @override
  _CustomCardSimpleState createState() {
    return _customCardSimpleState;
  }

  updateParamaters(Driver driver) {
    _customCardSimpleState.updateParamaters(driver);
  }

  bool getIsValid() {
    return _customCardSimpleState.validateDrown();
  }

  Driver? getDriver() {
    return driver;
  }
}

class _CustomCardSimpleState extends State<CustomCardSimple> {
  updateParamaters(Driver driver) {
    setState(() {
      widget.driver = driver;
      widget.ciPerson = driver.dni;
      widget.namePerson = driver.name;
      widget.phonePerson = driver.phone;
    });
    widget.ontapCloseDialog();
  }

  String? dropdownError;
  Color colorBorder = Colors.transparent;
  bool validateDrown() {
    bool isValid = true;

    if (widget.ciPerson == null) {
      setState(() => dropdownError = "Campo vacio");
      colorBorder = Colors.red;
      isValid = false;
    } else {
      setState(() => dropdownError = null);
      colorBorder = Colors.transparent;
      isValid = true;
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(children: [
      Card(
        shape: Border.all(color: colorBorder),
        borderOnForeground: true,
        child: Column(children: [
          Container(
            padding: EdgeInsets.all(10),
            //width: width,
            child: Text("Conductor Seleccionado",
                textAlign: TextAlign.left, style: TextStyle(fontSize: 13)),
          ),
          InkWell(
            child: ListTile(
              title: widget.namePerson == null
                  ? Text(
                      "no seleccionado",
                      style: TextStyle(fontSize: 13),
                    )
                  : Text(widget.namePerson!, style: TextStyle(fontSize: 13)),
              subtitle: Row(
                children: [
                  Expanded(
                      child: widget.ciPerson == null
                          ? Text("CI: " + "00000000",
                              style: TextStyle(fontSize: 13))
                          : Text("CI: " + widget.ciPerson!,
                              style: TextStyle(fontSize: 13))),
                  Expanded(
                      child: widget.phonePerson == null
                          ? Text("Celular: " + "00000000",
                              style: TextStyle(fontSize: 13))
                          : Text("Celular: " + widget.phonePerson!,
                              style: TextStyle(fontSize: 13)))
                ],
              ),
              trailing: Icon(Icons.add),
            ),
            onTap: () {
              widget.ontap();
            },
          )
        ]),
      ),
      Container(
        width: width,
        padding: EdgeInsets.only(left: 10, right: 10),
        child: dropdownError == null
            ? SizedBox()
            : Container(
                margin: new EdgeInsets.only(),
                child: Text(
                  dropdownError ?? "",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                )),
      ),
    ]);
  }
}
