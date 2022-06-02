import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:taxi_segurito_app/components/buttons/Button_app.dart';
import 'package:taxi_segurito_app/components/sidemenu/side_menu.dart';
import 'package:taxi_segurito_app/models/driver.dart';
import 'package:taxi_segurito_app/models/report_car.dart';
import 'package:taxi_segurito_app/models/vehicle.dart';
import 'package:taxi_segurito_app/services/auth_service.dart';
import 'package:taxi_segurito_app/services/report_car_service.dart';

class CalificationPage extends StatefulWidget {
  ReportCar reportCar = new ReportCar();
  int idTaxiuser;

  CalificationPage(this.idTaxiuser) {
    reportCar.idVehicule = idTaxiuser;
  }

  @override
  State<CalificationPage> createState() => _CalificationPageState();
}

class _CalificationPageState extends State<CalificationPage> {
  ReportCarService _reportCarService = ReportCarService();
  AuthService _authService = AuthService();
  TextEditingController txtComent = new TextEditingController();

  void _getUserId() async {
    widget.reportCar.idClientuser = await _authService.getCurrentId();
  }

  Future<void> _showDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mensaje'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  insertDataBase() async {
    _getUserId();
    widget.reportCar.comment = txtComent.text;
    _reportCarService.insertReportCar(widget.reportCar).then(
      (value) async {
        if (value) {
          await _showDialog("Muchas gracias por agregar tu reseña!");
        } else {
          await _showDialog(
              "Ups! no se registró tu reseña, inténtalo otra vez.");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 0, //Cambie el color del appBar
        title: Text('Agregar reseña'),
      ),
      drawer: SideMenu(),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              'Califica a tu conductor',
              style: TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            SizedBox(height: 5),
            RatingBar.builder(
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              initialRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemPadding: EdgeInsets.symmetric(horizontal: 4),
              unratedColor: Colors.grey[300],
              onRatingUpdate: (rating) {
                print(rating);
                widget.reportCar.calification = rating;
              },
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              child: TextField(
                controller: txtComent,
                maxLines: 5,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Deja un comentario'),
              ),
            ),
            _buttonCalificate(context),
          ],
        ),
      ),
    );
  }

  Widget _buttonCalificate(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ButtonApp(
          onPressed: () {
            Navigator.pop(context);
          },
          text: 'Cancelar',
          textColor: Colors.amber,
          color: Colors.white,
        ),
        ButtonApp(
          onPressed: () {
            insertDataBase();
          },
          text: 'Enviar',
          color: Colors.amber,
        ),
      ],
    );
  }
}
