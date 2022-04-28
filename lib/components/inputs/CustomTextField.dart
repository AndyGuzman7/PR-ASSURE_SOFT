import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class CustomTextField extends StatefulWidget {
  void Function(String value)? assignValue;
  String hint;
  String value;
  double marginLeft;
  double marginRight;
  double marginBotton;
  double marginTop;
  MultiValidator? multiValidator;
  double heightNum;
  bool obscureText;
  bool readOnly;
  bool filled;
  Color fillColor;
  _CustomTextFieldState _customTextFieldState = new _CustomTextFieldState();
  TextEditingController _controller = TextEditingController();

  TextEditingController get controller {
    return _controller;
  }

  CustomTextField({
    Key? key,
    this.hint = "Campo de text",
    this.marginLeft = 50,
    this.marginRight = 50,
    this.marginTop = 5,
    this.marginBotton = 5,
    this.heightNum = 35,
    this.obscureText = false,
    this.readOnly = false,
    this.filled = false,
    this.fillColor = Colors.yellow,
    this.value = '',
    this.multiValidator,
    this.assignValue,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() {
    _controller.text = value;
    return _customTextFieldState;
  }

  String getValue() {
    value = _controller.text;
    return value;
  }

  setValue(String value) {
    _customTextFieldState.setValue(value);
  }

  void changeHeightTextField(double num) {
    _customTextFieldState.changeHeightTextField(num);
  }
}

class _CustomTextFieldState extends State<CustomTextField> {
  changeHeightTextField(double num) {
    setState(() {
      widget.heightNum = num;
    });
  }

  setValue(String value) {
    setState(() {
      widget._controller.text = value;
    });
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        new Container(
          margin: EdgeInsets.only(
              top: widget.marginTop,
              bottom: widget.marginBotton,
              left: widget.marginLeft,
              right: widget.marginRight),
          width: width,
          height: widget.heightNum,
          alignment: Alignment.bottomCenter,
          child: new TextFormField(
            onChanged: widget.assignValue,
            obscureText: widget.obscureText,
            readOnly: widget.readOnly,
            textCapitalization: TextCapitalization.sentences,
            validator: (value) {
              var validators = widget.multiValidator!.validators;
              for (FieldValidator validator in validators) {
                if (!validator.isValid(value)) {
                  changeHeightTextField(60);
                  return validator.errorText;
                } else {
                  changeHeightTextField(35);
                  //return null;
                }
              }
            },
            textAlignVertical: TextAlignVertical.center,
            controller: widget._controller,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 13),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              hintText: widget.hint,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(width: 2, color: Colors.amber),
              ),
              filled: widget.filled,
              fillColor: widget.fillColor,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 0.0),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
