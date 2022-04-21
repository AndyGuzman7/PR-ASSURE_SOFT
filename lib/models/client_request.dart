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
}
