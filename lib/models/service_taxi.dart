class ServiceTaxi {
  late String estadoTaxi;
  late double latitudActual;
  late double longitudActual;

  ServiceTaxi(this.estadoTaxi, this.latitudActual, this.longitudActual);

  ServiceTaxi.fromJson(Map<dynamic, dynamic> json)
      : estadoTaxi = json['estadoTaxi'],
        latitudActual = json['latitudActual'],
        longitudActual = json['longitudActual'];

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'estadoTaxi': estadoTaxi,
        'latitudActual': latitudActual,
        'longitudActual': longitudActual,
      };
}
