import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taxi_segurito_app/services/server.dart';
import 'package:taxi_segurito_app/models/company.dart';

class CompanyService {
  Future<bool> insert(Company company) async {
    try {
      var path = "${Server.url}/Company/company_controller.php";
      final response = await http.post(
        Uri.parse(path),
        body: jsonEncode({
          'name': company.companyName,
          'nit': company.nit,
        }),
      );
      print(response.body);
      return response.statusCode == 200;
    } catch (exception) {
      return false;
    }
  }

  Future<bool> update(Company company) async {
    try {
      var path = "${Server.url}/Company/company_controller.php";
      final response = await http.put(
        Uri.parse(path),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'name': company.companyName,
            'nit': company.nit,
            'id': company.idCompany,
            'status': 1,
          },
        ),
      );

      if (response.statusCode == 200) {
        String result = json.decode(response.body);
        return result == "success";
      }
      return false;
    } catch (exception) {
      return false;
    }
  }

  Future<List<Company>> selectCompany() async {
    try {
      String path = "${Server.url}/Company/company_controller.php";
      var response = await http.get(Uri.parse(path));
      print(response.statusCode);
      if (response.statusCode == 200) {
        return convertToList(response);
      }
      return [];
    } catch (exception) {
      return [];
    }
  }

  List<Company> convertToList(response) {
    List<Company> listCompany = [];
    for (var singleOwner in json.decode(response.body)) {
      listCompany.add(
        Company.fromJson(singleOwner),
      );
    }
    return listCompany;
  }

  Future<List<Company>> selectCompanyByCriteria(criteria) async {
    try {
      final queryParams = {'criteria': criteria};
      final endpoint = Uri.http(
        Server.host,
        "${Server.baseEndpoint}/Company/company_controller.php",
        queryParams,
      );

      var response = await http.get(endpoint);
      if (response.statusCode == 200) {
        return convertToList(response);
      }
      return [];
    } catch (exception) {
      return [];
    }
  }
}
