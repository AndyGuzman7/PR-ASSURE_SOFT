import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/components/sidemenu/side_menu.dart';

class ClientMenu extends StatefulWidget {
  String? name;
  ClientMenu({Key? key, required this.name}) : super(key: key);

  @override
  State<ClientMenu> createState() => _ClientMenuState();
}

class _ClientMenuState extends State<ClientMenu> {
  @override
  Widget build(BuildContext context) {
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
