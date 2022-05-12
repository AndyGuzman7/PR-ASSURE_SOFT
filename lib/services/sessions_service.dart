import 'package:shared_preferences/shared_preferences.dart';

class SessionsService {
  //metodo para agregar variables de session
  addSessionValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

//metodo para obtener el valor de una session
  getSessionValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    print(value);
    return value;
  }

  //metodo para verificar si existe una variable de session true=existe
  Future<bool> verificationSession(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkValue = prefs.containsKey(key);
    return checkValue;
  }

//metodo para eliminar una session
  removeValuesSession(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
