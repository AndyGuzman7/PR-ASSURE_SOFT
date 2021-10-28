import 'dart:async';
import 'dart:developer';

//import 'package:custom_long_tap/custom_long_tap.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taxi_segurito_app/components/sidemenu/side_menu_functionality.dart';
import 'package:taxi_segurito_app/pages/mainWindow/MainWindow.dart';
import 'package:taxi_segurito_app/utils/call_panic.dart';
import 'package:taxi_segurito_app/utils/logOut.dart';
import 'package:taxi_segurito_app/pages/emergencyContact/listContact_page.dart';

class SideMenu extends StatelessWidget {
  late Timer timer;

  @override
  Widget build(BuildContext context) {
    SideMenUFunctionality sideMenUFunctionality =
        new SideMenUFunctionality(context);
    var divider = Divider(
      color: Colors.grey[350],
      height: 5,
      thickness: 1.5,
      indent: 10,
      endIndent: 10,
    );
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(25), bottomRight: Radius.circular(25)),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amber[300],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(
                          'http://assets.stickpng.com/images/585e4bd7cb11b227491c3397.png'),
                    ),
                  ),
                  Text("Nombre Usuario"),
                  Text(
                    "+591 xxxxxxxxx",
                    style: TextStyle(
                        color: Colors.grey[500], fontFamily: "Raleway"),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.access_time_outlined),
              title: Text('Historial De Reseñas'),
            ),
            divider,
            ListTile(
              onTap: () {
                sideMenUFunctionality.onPressedbtnContactEmergency();
              },
              leading: Icon(Icons.contact_page_rounded),
              title: Text('Contactos de Emergencia'),
            ),
            divider,
            GestureDetector(
              onPanCancel: () => timer.cancel(),
              onPanDown: (_) => {
                // time duration
                timer = Timer(Duration(seconds: 5), () async {
                  // your function here
                  sideMenUFunctionality.onPressedbtnCallPanic();
                })
              },
              child: ListTile(
                tileColor: Colors.red.shade100,
                leading: Icon(
                  Icons.warning_rounded,
                  color: Colors.red,
                ),
                onTap: () {
                  sideMenUFunctionality.onPressedTimePressedFault();
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
                sideMenUFunctionality.onPressedLogOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}