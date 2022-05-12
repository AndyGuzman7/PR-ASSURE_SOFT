import 'package:flutter/material.dart';

class PruebaClase extends StatefulWidget {
  PruebaClase({Key? key}) : super(key: key);

  @override
  State<PruebaClase> createState() => _PruebaClaseState();
}

class _PruebaClaseState extends State<PruebaClase> with WidgetsBindingObserver {
  late AppLifecycleState _notification;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
