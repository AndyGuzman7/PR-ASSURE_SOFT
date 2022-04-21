import 'package:flutter/cupertino.dart';

class ClienRequest {
  late String origen;
  late String destino;
  late int numeroPasageros;
  late double rango;
  late double latitud;
  late double longitud;
  ClienRequest(this.origen, this.destino, this.numeroPasageros, this.latitud,
      this.longitud, this.rango);

  ClienRequest.fromJson(Map<dynamic, dynamic> json)
      : origen = json['origen'] as String,
        destino = json['destino'] as String,
        numeroPasageros = int.parse(json['numeroPasajeros'] as String),
        rango = double.parse(json['rango'] as String),
        latitud = double.parse(json['latitud'] as String),
        longitud = double.parse(json['longitud'] as String);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'origen': origen,
        'destino': destino,
        'numeroPasajeros': numeroPasageros,
        'rango': rango,
        'latitud': latitud,
        'longitud': longitud
      };
}
