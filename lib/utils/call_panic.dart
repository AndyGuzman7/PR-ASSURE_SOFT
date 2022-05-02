import 'dart:developer';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:taxi_segurito_app/models/emergencyContact.dart';
import 'package:taxi_segurito_app/services/emergency_contact_service.dart';

class CallPanic {
  Future<bool> callNumber() async {
    List<EmergencyContact>? contacts = await getListNumbers();
    if (contacts != null) {
      try {
        String num = getListNumberAsString(contacts).first;
        FlutterPhoneDirectCaller.directCall(num);
        return true;
      } catch (e) {
        FlutterPhoneDirectCaller.directCall("911");
        return true;
      }
    }
    return false;
  }

  Future<bool> sendSms() async {
    SmsSender sender = new SmsSender();
    List<EmergencyContact>? contacts = await getListNumbers();
    if (contacts != null) {
      if (contacts.length > 0) {
        List<String> address = getListNumberAsString(contacts);
        try {
          for (var x in address) {
            await sender.sendSms(new SmsMessage(
                x, "Este teléfono envió un mensaje de alerta desde un taxi."));
          }
          return true;
        } catch (e) {
          log(e.toString());
          return false;
        }
      } else {
        await sender.sendSms(new SmsMessage(
            "911", "Este teléfono envió un mensaje de alerta desde un taxi."));
        log("Sin NRO Registrado");
        return true;
      }
    } else {
      await sender.sendSms(new SmsMessage(
          "911", "Este teléfono envió un mensaje de alerta desde un taxi."));
      return true;
    }
  }

  Future<bool> btnpanic() async {
    try {
      bool controlSms = false, controlCall = false;
      await CallPanic().sendSms().then((value) => {
            if (value == true) {controlSms = value}
          });
      log("sendSms Execute");
      await CallPanic().callNumber().then((value) => {
            if (value == true) {controlCall = value}
          });
      if (controlSms == true && controlCall == true) {
        log("Se Ejecuta");
        return true;
      } else {
        log("Hubo Algun Fallo");
        return false;
      }
    } catch (e) {
      log(e.toString() + " btnpanic()");
      return false;
    }
  }

  Future<List<EmergencyContact>?> getListNumbers() async {
    EmergencyContactService emergencyContactService =
        new EmergencyContactService();
    List<EmergencyContact>? contacts =
        await emergencyContactService.getEmergencyContacts();
    return contacts;
  }

  List<String> getListNumberAsString(List<EmergencyContact> contacts) {
    List<String> numbers = contacts.map((c) => c.number).toList();
    return numbers;
  }
}
