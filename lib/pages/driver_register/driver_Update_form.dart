import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:taxi_segurito_app/components/inputs/CustomTextField.dart';
import 'package:taxi_segurito_app/models/driver.dart';
import 'package:taxi_segurito_app/providers/ImageFromBase64Provider.dart';
import 'package:taxi_segurito_app/providers/ImagesFileAdapter.dart';
import 'package:taxi_segurito_app/validators/TextFieldValidators.dart';

class DriverUpdateForm extends StatefulWidget {
  Driver _driver;
  GlobalKey<FormState> formKey;
  DriverUpdateForm(this.formKey, this._driver);

  _DriverUpdateFormState _state = _DriverUpdateFormState();

  @override
  _DriverUpdateFormState createState() => _state;

  Driver? getDriverIfIsValid() {
    bool isImageValid = _state.fieldImage.validate();
    bool isFormValid = formKey.currentState!.validate();
    if (isImageValid && isFormValid) {
      return _state.getDriver();
    }
    return null;
  }
}

class _DriverUpdateFormState extends State<DriverUpdateForm> {
  late CustomTextField fullnameField,
      fieldCi,
      fieldLicense,
      fieldCellphone,
      iddriver;
  late ImagesFileAdapter fieldImage;

  Driver getDriver() {
    widget._driver.fullName = fullnameField.getValue();
    widget._driver.cellphone = fieldCellphone.getValue();
    widget._driver.license = fieldLicense.getValue();
    widget._driver.ci = fieldCi.getValue();
    widget._driver.pictureStr = fieldImage.getImageBase64();
    widget._driver.picture = base64Decode(fieldImage.getImageBase64());
    return widget._driver;
  }

  @override
  Widget build(BuildContext context) {
    fieldImage = ImagesFileAdapter(
      imageMainBase64: stringFromBase64Bytes(widget._driver.picture),
      isShapeCircle: true,
    );

    fullnameField = CustomTextField(
      hint: "Nombre completo",
      multiValidator: MultiValidator([
        RequiredValidator(errorText: 'El nombre completo es requerido'),
        StringValidator(errorText: 'No puede ingresar valores numéricos')
      ]),
      marginLeft: 0,
      marginRight: 0,
      heightNum: 42,
      value: widget._driver.fullName,
    );

    fieldCi = new CustomTextField(
      hint: widget._driver.ci,
      multiValidator: MultiValidator([
        RequiredValidator(errorText: 'Número de carnet requerido'),
        NumberValidator(errorText: 'No puede ingresar letras')
      ]),
      marginLeft: 0,
      marginRight: 0,
      heightNum: 42,
      value: widget._driver.ci,
    );

    fieldLicense = new CustomTextField(
      hint: widget._driver.license,
      multiValidator: MultiValidator([
        RequiredValidator(errorText: 'Nivel de licencia de conducir requerido'),
        StringValidator(errorText: 'No puede ingresar valores numéricos'),
      ]),
      marginLeft: 0,
      marginRight: 0,
      heightNum: 42,
      value: widget._driver.license,
    );

    fieldCellphone = new CustomTextField(
      hint: widget._driver.cellphone,
      multiValidator: MultiValidator([
        RequiredValidator(errorText: 'Número de celular requerido'),
        NumberValidator(errorText: 'No puede ingresar letras')
      ]),
      marginLeft: 0,
      marginRight: 0,
      heightNum: 42,
      value: widget._driver.cellphone,
    );

    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        children: [
          SizedBox(height: 18),
          fieldImage,
          fullnameField,
          fieldCi,
          fieldLicense,
          fieldCellphone,
        ],
      ),
    );
  }
}
