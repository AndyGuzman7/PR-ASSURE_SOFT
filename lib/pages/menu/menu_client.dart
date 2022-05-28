import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/components/buttons/Button_app.dart';
import 'package:taxi_segurito_app/components/sidemenu/side_menu.dart';
import 'package:taxi_segurito_app/pages/forgetObjects/forgetObjectMain.dart';
import 'package:taxi_segurito_app/pages/menu/menu_client_functionality.dart';
import 'package:taxi_segurito_app/pages/v2_taxi_request/taxi_request_page.dart';

class ClientMenu extends StatefulWidget {
  String? name;
  ClientMenu({Key? key, required this.name}) : super(key: key);

  @override
  State<ClientMenu> createState() => _ClientMenuState();
}

class _ClientMenuState extends State<ClientMenu> {
  get borderRadius => BorderRadius.circular(8.0);
  @override
  Widget build(BuildContext context) {
    MenuClientFunctionality functionality = new MenuClientFunctionality(context);
    final List<Center> items = [
      Center(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Material(
          elevation: 10,
          borderRadius: borderRadius,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaxiRequestPage(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(0.0),
                height: 80.0,//MediaQuery.of(context).size.width * .08,
                width: MediaQuery.of(context).size.width,//MediaQuery.of(context).size.width * .3,
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                ),
                child: Row(
                  children: <Widget>[
                    LayoutBuilder(builder: (context, constraints) {
                      //print(constraints);
                      return Container(
                        height: constraints.maxHeight,
                        width: constraints.maxHeight,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 193, 7, 1),
                          borderRadius: borderRadius,
                        ),
                        child: Icon(
                          Icons.emoji_objects,
                          color: Colors.white,
                        ),
                      );
                    }),
                    Expanded(
                      child: Text(
                        'Servicio Taxi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ),
      Center(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Material(
          elevation: 10,
          borderRadius: borderRadius,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePageForgetObject(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(0.0),
                height: 80.0,//MediaQuery.of(context).size.width * .08,
                width: MediaQuery.of(context).size.width,//MediaQuery.of(context).size.width * .3,
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                ),
                child: Row(
                  children: <Widget>[
                    LayoutBuilder(builder: (context, constraints) {
                      //print(constraints);
                      return Container(
                        height: constraints.maxHeight,
                        width: constraints.maxHeight,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 193, 7, 1),
                          borderRadius: borderRadius,
                        ),
                        child: Icon(
                          Icons.emoji_objects,
                          color: Colors.white,
                        ),
                      );
                    }),
                    Expanded(
                      child: Text(
                        'Registrar Objetos Perdidos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ),
      Center(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Material(
          elevation: 10,
          borderRadius: borderRadius,
            child: InkWell(
              onTap: () {
                functionality.onPressedbtnContactEmergency();
              },
              child: Container(
                padding: EdgeInsets.all(0.0),
                height: 80.0,//MediaQuery.of(context).size.width * .08,
                width: MediaQuery.of(context).size.width,//MediaQuery.of(context).size.width * .3,
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                ),
                child: Row(
                  children: <Widget>[
                    LayoutBuilder(builder: (context, constraints) {
                      //print(constraints);
                      return Container(
                        height: constraints.maxHeight,
                        width: constraints.maxHeight,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 193, 7, 1),
                          borderRadius: borderRadius,
                        ),
                        child: Icon(
                          Icons.contact_page_rounded,
                          color: Colors.white,
                        ),
                      );
                    }),
                    Expanded(
                      child: Text(
                        'Contactos de Emergencia',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ),
      Center(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Material(
          elevation: 10,
          borderRadius: borderRadius,
            child: InkWell(
              onTap: () {
                functionality.onPressedbtnCallPanic();
              },
              child: Container(
                padding: EdgeInsets.all(0.0),
                height: 80.0,//MediaQuery.of(context).size.width * .08,
                width: MediaQuery.of(context).size.width,//MediaQuery.of(context).size.width * .3,
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                ),
                child: Row(
                  children: <Widget>[
                    LayoutBuilder(builder: (context, constraints) {
                      //print(constraints);
                      return Container(
                        height: constraints.maxHeight,
                        width: constraints.maxHeight,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 193, 7, 1),
                          borderRadius: borderRadius,
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                      );
                    }),
                    Expanded(
                      child: Text(
                        'Compartir Ubicacion',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ),
      Center(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Material(
          elevation: 10,
          borderRadius: borderRadius,
            child: InkWell(
              onTap: () {
                functionality.onPressedTimePressedFault();
              },
              child: Container(
                padding: EdgeInsets.all(0.0),
                height: 80.0,//MediaQuery.of(context).size.width * .08,
                width: MediaQuery.of(context).size.width,//MediaQuery.of(context).size.width * .3,
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                ),
                child: Row(
                  children: <Widget>[
                    LayoutBuilder(builder: (context, constraints) {
                      //print(constraints);
                      return Container(
                        height: constraints.maxHeight,
                        width: constraints.maxHeight,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 193, 7, 1),
                          borderRadius: borderRadius,
                        ),
                        child: Icon(
                          Icons.warning_rounded,
                          color: Colors.white,
                        ),
                      );
                    }),
                    Expanded(
                      child: Text(
                        'Boton de Panico',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ),
      Center(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Material(
          elevation: 10,
          borderRadius: borderRadius,
            child: InkWell(
              onTap: () {
                functionality.onPressedLogOut();
              },
              child: Container(
                padding: EdgeInsets.all(0.0),
                height: 80.0,//MediaQuery.of(context).size.width * .08,
                width: MediaQuery.of(context).size.width,//MediaQuery.of(context).size.width * .3,
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                ),
                child: Row(
                  children: <Widget>[
                    LayoutBuilder(builder: (context, constraints) {
                      //print(constraints);
                      return Container(
                        height: constraints.maxHeight,
                        width: constraints.maxHeight,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 193, 7, 1),
                          borderRadius: borderRadius,
                        ),
                        child: Icon(
                          Icons.logout  ,
                          color: Colors.white,
                        ),
                      );
                    }),
                    Expanded(
                      child: Text(
                        'Cerrar Sesion',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ),
    
    ];
    return Scaffold(
      drawer: SideMenu(
        username: widget.name,
      ),
      appBar: AppBar(
        elevation: 0,
      ),
      body: Material(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate:
                  MySliverAppBar(expandedHeight: 150, nameUser: widget.name!),
              pinned: true,
            ),
            SliverPadding(padding: EdgeInsets.only(bottom: 48.0)),
            SliverList(delegate: SliverChildListDelegate(items))
          ],
          
        ),
      ),
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  String nameUser;
  MySliverAppBar({required this.expandedHeight, required this.nameUser});
  Color colorMain = Color.fromRGBO(255, 193, 7, 1);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [colorMain, colorMain],
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 2 - shrinkOffset,
          left: 20,
          right: 20,
          child: Opacity(
              opacity: (1 - shrinkOffset / expandedHeight),
              child: Material(
                borderRadius: BorderRadiusGeometry.lerp(
                    BorderRadius.all(Radius.circular(20)),
                    BorderRadius.all(Radius.circular(20)),
                    2),
                elevation: 4,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: Colors.white,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text("Bienvenido\n" + nameUser,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ))),
                    )),
              )),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
