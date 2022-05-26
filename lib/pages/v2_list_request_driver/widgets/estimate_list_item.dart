import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/components/buttons/CustomButtonWithLinearBorder.dart';
import 'package:taxi_segurito_app/models/estimate_taxi.dart';

class EstimateListItem extends StatefulWidget {
  void Function(EstimateTaxi estimateTaxi) callbackRequest;
  EstimateTaxi? estimateTaxi;
  EstimateListItem({Key? key, this.estimateTaxi, required this.callbackRequest})
      : super(key: key);

  @override
  _RequestListItemState createState() => _RequestListItemState();
}

class _RequestListItemState extends State<EstimateListItem> {
  Color colorMain = Color.fromRGBO(255, 193, 7, 1);
  Color colorMainDanger = Color.fromRGBO(242, 78, 30, 1);
  Color colorMainNull = Color.fromRGBO(153, 153, 153, 1);

  @override
  Widget build(BuildContext context) {
    Image imagedefault = new Image.asset(
      "assets/images/user_default.png",
    );

    boxData(value) {
      return new Container(
        alignment: Alignment.centerLeft,
        child: value,
      );
    }

    Container columnOne = new Container(
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 70,
          height: 70,
          margin: EdgeInsets.all(0),
          decoration: BoxDecoration(
              image:
                  DecorationImage(image: imagedefault.image, fit: BoxFit.cover),
              shape: BoxShape.circle),
        ),
      ),
    );

    Container columnTwo = new Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
        left: 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          boxData(
            Text(
              'Precio: ' + widget.estimateTaxi!.estimacion.toString(),
            ),
          ),
          boxData(Text(
            'Distancia: ' + widget.estimateTaxi!.distancia.toString() + ' Km',
          )),
          boxData(Text(
            "Placa: " + widget.estimateTaxi!.placa.toString(),
          )),
        ],
      ),
    );

    Container columnThree = new Container(
      height: 60,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Align(
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
                alignment: Alignment.center,
              ),
            )
          ],
        ),
      ),
    );

    Container containerOwnerData = new Container(
      height: 110,
      color: Color.fromARGB(255, 187, 187, 187),
      margin:
          new EdgeInsets.only(top: 5.0, bottom: 5.0, left: 00.0, right: 00.0),
      child: Material(
        child: InkWell(
          onTap: () {
            widget.callbackRequest(widget.estimateTaxi!);
          },
          child: Container(
            margin: new EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              left: 20.0,
              right: 20.0,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 0,
                  child: columnOne,
                ),
                Expanded(
                  flex: 1,
                  child: columnTwo,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return containerOwnerData;
  }
}
