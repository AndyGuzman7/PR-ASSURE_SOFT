class EstimateTaxi {
  double latitud;
  double longitud;
  late int idUserTaxi;
  late String idRequestUserFirebase;
  late String idRequestTaxiFirebase;
  late double estimacion;

  late String placa;
  late double distancia;
  late bool confirmation = false;

  EstimateTaxi(
      this.idUserTaxi,
      this.idRequestTaxiFirebase,
      this.idRequestUserFirebase,
      this.estimacion,
      this.latitud,
      this.longitud,
      this.placa);
  EstimateTaxi.fromJson(Map<dynamic, dynamic> json)
      : idUserTaxi = json['idUserTaxi'],
        idRequestUserFirebase = json['idRequestUserFirebase'],
        idRequestTaxiFirebase = json['idRequestTaxiFirebase'],
        estimacion = json['estimacion'],
        latitud = json['latidud'],
        longitud = json['longitud'],
        placa = json['placa'],
        confirmation = json['confirmation'];

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'idUserTaxi': idUserTaxi,
        'idRequestUserFirebase': idRequestUserFirebase,
        'idRequestTaxiFirebase': idRequestTaxiFirebase,
        'estimacion': estimacion,
        'latidud': latitud,
        'longitud': longitud,
        'placa': placa,
        'confirmation': confirmation
      };
}
