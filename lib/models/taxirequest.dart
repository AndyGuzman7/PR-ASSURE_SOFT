import 'package:flutter/cupertino.dart';

class RequestTaxi {
  late String idUser;
  late String idRequest;
  late String idTaxista;
  late String status;

  RequestTaxi(this.idUser, this.idRequest, this.idTaxista, this.status);

  RequestTaxi.fromJson(Map<dynamic, dynamic> json)
      : idUser = json['idCliente'],
        idRequest = json['idRequest'],
        idTaxista = json['idTaxista'],
        status = json['estado'];

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'idCliente': idUser,
        'idRequest': idRequest,
        'idTaxista': idTaxista,
        'estado': status,
      };
}
