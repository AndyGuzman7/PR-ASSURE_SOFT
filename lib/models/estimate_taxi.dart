class EstimateTaxi {
  double latitud;
  double longitud;
  late int idUserTaxi;
  late String idTaxiServiceRequest;
  late String idFirebase;
  late double estimacion;

  late String placa;
  late double distancia;
  late String estadoCliente;
  late String estadoTaxi;
  late int id;
  late String motivoCancelacion = "No cancelado";

  EstimateTaxi(
      this.idUserTaxi,
      this.estadoCliente,
      this.estadoTaxi,
      this.idFirebase,
      this.idTaxiServiceRequest,
      this.estimacion,
      this.latitud,
      this.longitud,
      this.placa);
  EstimateTaxi.fromJson(Map<dynamic, dynamic> json)
      : idUserTaxi = json['idUserTaxi'],
        idTaxiServiceRequest = json['idTaxiServiceRequest'],
        idFirebase = json['idFirebase'],
        estimacion = json['estimacion'].toDouble(),
        latitud = json['latidud'],
        longitud = json['longitud'],
        placa = json['placa'],
        motivoCancelacion = json['motivoCancelacion'],
        estadoCliente = json['estadoCliente'],
        estadoTaxi = json['estadoTaxi'];

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'idUserTaxi': idUserTaxi,
        'idTaxiServiceRequest': idTaxiServiceRequest,
        'idFirebase': idFirebase,
        'estimacion': estimacion,
        'latidud': latitud,
        'longitud': longitud,
        'placa': placa,
        'estadoCliente': estadoCliente,
        'estadoTaxi': estadoTaxi,
        'motivoCancelacion': motivoCancelacion
      };
}
