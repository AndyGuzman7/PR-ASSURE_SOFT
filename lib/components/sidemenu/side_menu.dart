import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/components/sidemenu/side_menu_functionality.dart';
import 'package:taxi_segurito_app/pages/forgetObjects/forgetObjectMain.dart';
import 'package:taxi_segurito_app/pages/v2_taxi_request/taxi_request_page.dart';

class SideMenu extends StatelessWidget {
  late Timer timer;
  String? username;
  SideMenu({this.username});
  Color colorMain = Color.fromRGBO(255, 193, 7, 1);
  @override
  Widget build(BuildContext context) {
    SideMenuFunctionality functionality = SideMenuFunctionality(context);
    var divider = Divider(
      color: Colors.grey[350],
      height: 5,
      thickness: 1.5,
      indent: 10,
      endIndent: 10,
    );
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(25),
        bottomRight: Radius.circular(25),
      ),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: colorMain,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(
                          'https://www.hispano-irish.com/wp-content/uploads/2020/05/PngItem_1300253.png'),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(this.username ?? "Nombre usuario"),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.emoji_objects),
              title: Text("Servicio Taxi"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaxiRequestPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.emoji_objects),
              title: Text("Registrar Objetos Perdidos"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePageForgetObject(),
                  ),
                );
              },
            ),
            divider,
            ListTile(
              onTap: () {
                functionality.onPressedbtnContactEmergency();
              },
              leading: Icon(Icons.contact_page_rounded),
              title: Text('Contactos de Emergencia'),
            ),
            divider,
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, 'listContact');
              },
              leading: Icon(Icons.location_on),
              title: Text('Compartir Ubicacion'),
            ),
            GestureDetector(
              onPanCancel: () => timer.cancel(),
              onPanDown: (_) => {
                timer = Timer(Duration(seconds: 5), () async {
                  functionality.onPressedbtnCallPanic();
                })
              },
              child: ListTile(
                tileColor: Colors.red.shade100,
                leading: Icon(
                  Icons.warning_rounded,
                  color: Colors.red,
                ),
                onTap: () {
                  functionality.onPressedTimePressedFault();
                },
                title: Text(
                  'Boton de Panico',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            divider,
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: Text(
                'Cerrar Sesion',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                functionality.onPressedLogOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
