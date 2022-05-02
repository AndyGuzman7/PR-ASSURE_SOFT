import 'package:flutter/cupertino.dart';

class ClienRequest {
  late int idUser;
  late String iduserFirebase;
  late double latitudOrigen;
  late double longitudOrigen;
  late int numeroPasageros;
  late double rango;
  late double latitudDestino;
  late double longitudDestino;
  ClienRequest(
      this.idUser,
      this.iduserFirebase,
      this.latitudOrigen,
      this.longitudOrigen,
      this.numeroPasageros,
      this.latitudDestino,
      this.longitudDestino,
      this.rango);

  ClienRequest.fromJson(Map<dynamic, dynamic> json)
      : idUser = json['idUser'],
        iduserFirebase = json['iduserFirebase'],
        latitudOrigen = json['latitudOrigen'],
        longitudOrigen = json['longitudOrigen'],
        numeroPasageros = json['numeroPasajeros'],
        rango = json['rango'] * 1.0,
        latitudDestino = json['latitudDestino'],
        longitudDestino = json['longitudDestino'];

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'idUser': idUser,
        'iduserFirebase': iduserFirebase,
        'latitudOrigen': latitudOrigen,
        'longitudOrigen': longitudOrigen,
        'numeroPasajeros': numeroPasageros,
        'rango': rango,
        'latitudDestino': latitudDestino,
        'longitudDestino': longitudDestino
      };
}
