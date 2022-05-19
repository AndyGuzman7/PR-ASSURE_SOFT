import 'package:flutter/cupertino.dart';

class ClienRequest {
  late int idUser;
  late String idFirebase;
  late double latitudOrigen;
  late double longitudOrigen;
  late int numeroPasageros;
  late double rango;
  late double latitudDestino;
  late double longitudDestino;
  ClienRequest(
      this.idUser,
      this.idFirebase,
      this.latitudOrigen,
      this.longitudOrigen,
      this.numeroPasageros,
      this.latitudDestino,
      this.longitudDestino,
      this.rango);

  ClienRequest.init();

  ClienRequest.updateRange(this.idFirebase, this.rango);

  ClienRequest.fromJson(Map<dynamic, dynamic> json)
      : idUser = json['idUser'] as int,
        idFirebase = json['idFirebase'],
        latitudOrigen = json['latitudOrigen'],
        longitudOrigen = json['longitudOrigen'],
        numeroPasageros = json['numeroPasajeros'],
        rango = json['rangoBusqueda'] * 1.0,
        latitudDestino = json['latitudDestino'],
        longitudDestino = json['longitudDestino'];

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'idUser': idUser,
        'idFirebase': idFirebase,
        'latitudOrigen': latitudOrigen,
        'longitudOrigen': longitudOrigen,
        'numeroPasajeros': numeroPasageros,
        'rangoBusqueda': rango,
        'latitudDestino': latitudDestino,
        'longitudDestino': longitudDestino
      };
}
