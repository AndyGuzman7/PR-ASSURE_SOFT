import 'package:flutter/cupertino.dart';

class ClienRequest {
  late double idUser;
  late double latitudOrigen;
  late double longitudOrigen;
  late int numeroPasageros;
  late double rango;
  late double latitudDestino;
  late double longitudDestino;
  ClienRequest(
      this.idUser,
      this.latitudOrigen,
      this.longitudOrigen,
      this.numeroPasageros,
      this.latitudDestino,
      this.longitudDestino,
      this.rango);

  ClienRequest.fromJson(Map<dynamic, dynamic> json)
      : idUser = double.parse(json['idUser'] as String),
        latitudOrigen = double.parse(json['latitudOrigen'] as String),
        longitudOrigen = double.parse(json['longitudOrigen'] as String),
        numeroPasageros = int.parse(json['numeroPasajeros'] as String),
        rango = double.parse(json['rango'] as String),
        latitudDestino = double.parse(json['latitudDestino'] as String),
        longitudDestino = double.parse(json['longitudDestino'] as String);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'idUser': idUser,
        'latitudOrigen': latitudOrigen,
        'longitudOrigen': longitudOrigen,
        'numeroPasajeros': numeroPasageros,
        'rango': rango,
        'latitudDestino': latitudDestino,
        'longitudDestino': longitudDestino
      };
}
