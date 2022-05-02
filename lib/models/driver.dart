import 'dart:typed_data';
import 'package:taxi_segurito_app/models/person.dart';
import 'package:taxi_segurito_app/providers/ImageFromBase64Provider.dart';

class Driver extends Person {
  late String idDriver;
  late String ci;
  late String license;
  late Uint8List picture;
  late String? pictureStr;
  late int? ownerId;

  Driver(String fullName, this.ci, String cellphone)
      : super.insert(fullName, cellphone);

  Driver.update({
    required String idDriver,
    required String fullName,
    required String cellphone,
    required this.license,
    required this.ci,
  });

  Driver.insert({
    required String fullName,
    required String cellphone,
    required this.license,
    required this.ci,
    required this.pictureStr,
    this.ownerId,
  }) : super.insert(fullName, cellphone);

  Driver.fromJson(Map<String, dynamic> json) {
    super.idPerson = json['id'] as int;
    super.fullName = json['fullname'] as String;
    super.cellphone = json['cellphone'] as String;
    this.license = json['license'] as String;
    this.ci = json['ci'] as String;
    this.ownerId = json['ownerId'] as int;
    super.status = json['status'] as int;

    String pictureBase64 = json['picture'] as String;
    picture = bytesFromBase64String(pictureBase64);
  }

  Driver.init();
}
