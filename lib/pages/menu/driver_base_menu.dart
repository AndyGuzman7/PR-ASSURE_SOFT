import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/pages/menu/driver_menu_item.dart';
import 'package:taxi_segurito_app/services/auth_service.dart';

abstract class MenuDriver extends StatelessWidget {
  final AuthService _authService = AuthService();
  late String? name;

  MenuDriver({this.name});

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      name = ModalRoute.of(context)!.settings.arguments as String;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              final success = await _authService.logOut();
              if (success) {
                Navigator.pushReplacementNamed(context, 'firstScreen');
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Bienvenido conductor\n$name.\n¿Que haremos hoy?",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(left: 24, right: 24),
              child: GridView.count(
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                crossAxisCount: 2,
                children: getDriverItems(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<MenuDriverItem> getDriverItems();
}
