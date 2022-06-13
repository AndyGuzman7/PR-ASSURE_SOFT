import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/models/owner.dart';
import 'package:taxi_segurito_app/models/company.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taxi_segurito_app/services/company_service.dart';
import 'package:taxi_segurito_app/services/owner_service.dart';

class RegisterOwnerFunctionality {
  BuildContext? context;
  String? names;
  String? lastName;
  String? lastNameSecond;
  String? fullName;
  String? cellphone;
  String? email;
  String? password;
  String? ci;
  String? address;
  VoidCallback? activeShowDialog;
  Owner? owner = new Owner.init();
  Company? company = new Company();

  OwnerService _ownerService = OwnerService();
  CompanyService _companyService = CompanyService();

  RegisterOwnerFunctionality(
      {this.context, this.company, this.owner, this.activeShowDialog});

  set setContext(context) {
    this.context = context;
  }

  onPressedbtnRegisterCar() async {
    owner!.idCompany = company!.idCompany;
    final success = await _ownerService.insert(owner!);
    if (success) {
      activeShowDialog!();
    }
  }

  Future<List<Company>?> getCompanies() async {
    List<Company> companyList = [];
    companyList.clear();
    try {
      companyList = await _companyService.selectCompany();
      return companyList;
    } catch (exception) {
      print(exception);
      return null;
    }
  }

  onPressedbtnDeleteOwner() {}

  onPressedbtnUpdateOwner() {
    update(owner!).then((value) {
      if (value) {
        activeShowDialog!();
        Fluttertoast.showToast(
            msg: "Dueño se actualizo ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.purple,
            textColor: Colors.white);
      } else {
        log(" palle gaso");
      }
    });
    print(owner!.fullName);
  }

  closeNavigator() {
    Navigator.of(context!).pop();
  }

  onPressedbtnCancelRegisterCar() {
    closeNavigator();
  }
}
