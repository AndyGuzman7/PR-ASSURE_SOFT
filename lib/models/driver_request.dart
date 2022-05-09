class DriverRequest {
  double latitud;
  double longitud;
  late int idUserTaxi;
  late String idRequestUserFirebase;
  late String idRequestTaxiFirebase;
  late double estimacion;
  late double rango;


  DriverRequest(this.idUserTaxi, this.idRequestTaxiFirebase,
      this.idRequestUserFirebase, this.estimacion, this.latitud, this.longitud);
  DriverRequest.fromJson(Map<dynamic, dynamic> json)
      : idUserTaxi = json['idUserTaxi'],
        idRequestUserFirebase = json['idRequestUserFirebase'],
        idRequestTaxiFirebase = json['idRequestTaxiFirebase'],
        estimacion = json['estimacion'],
        latitud = json['latitudOrigen'],
        longitud = json['longitudOrigen'],
        rango = json['rango'];

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'idUserTaxi': idUserTaxi,
        'idRequestUserFirebase': idRequestUserFirebase,
        'idRequestTaxiFirebase': idRequestTaxiFirebase,
        'estimacion': estimacion,
        'latidud': latitud,
        'longitud': longitud,
        'rango':rango
      };
}
