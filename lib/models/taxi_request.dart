import 'package:flutter/cupertino.dart';

class TaxiRequest {
  late int idUserTaxi;
  late String idRequestUserFirebase;
  late String idRequestTaxiFirebase;
  late double estimacion;

  TaxiRequest(this.idUserTaxi, this.idRequestUserFirebase,
      this.idRequestTaxiFirebase, this.estimacion);

  TaxiRequest.fromJson(Map<dynamic, dynamic> json)
      : idUserTaxi = json['idUserTaxi'],
        idRequestUserFirebase = json['idRequestUserFirebase'],
        idRequestTaxiFirebase = json['idRequestTaxiFirebase'],
        estimacion = json['estimacion'] * 1.0;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'idUserTaxi': idUserTaxi,
        'idRequestUserFirebase': idRequestUserFirebase,
        'idRequestTaxiFirebase': idRequestTaxiFirebase,
        'estimacion': estimacion,
      };
}
