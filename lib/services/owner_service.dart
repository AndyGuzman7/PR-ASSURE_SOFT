import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:taxi_segurito_app/services/server.dart';
import 'package:taxi_segurito_app/models/owner.dart';

class OwnerService {
  Future<bool> insert(Owner owner) async {
    String path = '${Server.url}/Owner/owner_controller.php';
    var response = await http.post(
      Uri.parse(path),
      body: jsonEncode({
        'fullName': owner.fullName,
        'cellphone': owner.cellPhone,
        'email': owner.email,
        'password': owner.password,
        'address': owner.address,
        'ci': owner.ci,
        'companyid': owner.idCompany,
      }),
      /*
      "fullName": "owner ownerdos",
        "cellphone": "63472984",
        "email": "owner2@gmail.com",
        "password": "236deedd81d60642a022746e81429d91",
        "address": "av. Reducto",
        "ci": "4892847",
        "companyid": 1
      
      */
    );

    return response.statusCode == 200;
  }

  Future<List<Owner>> select() async {
    String path = '${Server.url}/Owner/owner_controller.php';
    final response = await http.get(Uri.parse(path));

    if (response.statusCode == 200) {
      return convertToList(response);
    }
    throw 'Unable to retrieve owners';
  }

  Future<Owner> selectById(int ownerId) async {
    final queryParams = {'ownerId': ownerId.toString()};
    final endpoint = Uri.http(Server.host,
        '${Server.baseEndpoint}/Owner/owner_controller.php', queryParams);
    final response = await http.get(endpoint);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final owner = Owner.fromJson(body);
      return owner;
    }
    throw 'Unable to retrieve owner';
  }

  Future<bool> delete(Owner owner) async {
    try {
      String path = '${Server.url}/Owner/owner_controller.php';
      var response = await http.delete(
        Uri.parse(path),
        body: jsonEncode(
          {
            "idOwner": owner.idOwner,
          },
        ),
      );
      var result = jsonDecode(response.body);
      if (result == 1) {
        return true;
      } else {
        return false;
      }
    } catch (exception) {
      return false;
    }
  }

  Future<List<Owner>> selectByNameCiOrPhone(criteria) async {
    String path = '${Server.url}/Owner/owner_controller.php?criteria=$criteria';
    var response = await http.get(Uri.parse(path));

    if (response.statusCode == 200) {
      return convertToList(response);
    }
    throw 'Unable to retrieve owners';
  }

  Future<bool> update(Owner owner) async {
    try {
      String path = '${Server.url}/Owner/owner_controller.php';
      var response = await http.put(
        Uri.parse(path),
        body: jsonEncode(
          {
            "id": owner.idOwner,
            "fullName": owner.fullName,
            "phone": owner.cellPhone,
            "email": owner.email,
            "password": owner.password,
            "address": owner.address,
            "ci": owner.ci,
            "idCompany": owner.idCompany,
            "status": 1
          },
        ),
      );
      var result = jsonDecode(response.body);

      if (result == 'success') {
        return true;
      } else {
        return false;
      }
    } catch (exception) {
      return false;
    }
  }

  List<Owner> convertToList(response) {
    List<dynamic> body = jsonDecode(response.body);
    List<Owner> owners = body.map((o) => Owner.fromJson(o)).toList();
    return owners;
  }

  Future<bool> deleteOwner(Owner owner) async {
    try {
      String path = '${Server.url}/Owner/owner_controller.php';
      var response = await http.delete(Uri.parse(path),
          body: jsonEncode({"idOwner": owner.idOwner.toString()}));
      var result = jsonDecode(response.body);
      if (result == 1) {
        print("Borrado Exitosamente" + result.toString());
        return Future<bool>.value(true);
      } else {
        print("Error : " + result);
        return Future<bool>.value(false);
      }
    } catch (exception) {
      log(exception.toString());
      return Future<bool>.value(false);
    }
  }
}

Future<bool> update(Owner owner) async {
  try {
    String path = '${Server.url}/Owner/owner_controller.php';
    var response = await http.put(Uri.parse(path),
        body: jsonEncode({
          "id": owner.idOwner.toString(),
          "fullName": owner.fullName.toString(),
          "phone": owner.cellPhone.toString(),
          "email": owner.email.toString(),
          "password": owner.password.toString(),
          "address": owner.address.toString(),
          "ci": owner.ci.toString(),
          "idCompany": int.parse(owner.idCompany.toString()),
          "status": 1
        }));
    var result = jsonDecode(response.body);
    log(result);

    if (result == 'success') {
      return Future<bool>.value(true);
    } else {
      return Future<bool>.value(false);
    }
  } catch (exception) {
    log(exception.toString());
    return Future<bool>.value(false);
  }
}
