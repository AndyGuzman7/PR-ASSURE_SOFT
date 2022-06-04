import 'package:flutter/material.dart';

import '../../../components/map/view_map.dart';

class ReceiveLocationDriver extends StatefulWidget {
  @override
  _ReceiveLocationDriver createState() => _ReceiveLocationDriver();
}

class _ReceiveLocationDriver extends State<ReceiveLocationDriver> {
  ViewMap viewMap = new ViewMap();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Taxista en camino...'),
        ),
        body: viewMap);
  }
}
