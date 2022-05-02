import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/components/buttons/CustomButtonWithLinearBorder.dart';
import 'package:taxi_segurito_app/models/client_request.dart';
import 'package:taxi_segurito_app/models/company.dart';
import 'package:taxi_segurito_app/pages/company_screen/company_edit_screen.dart';

class RequestListItem extends StatefulWidget {
  void Function(ClienRequest clienRequest) callbackRequest;
  ClienRequest? clientRequest;
  RequestListItem({Key? key, this.clientRequest, required this.callbackRequest})
      : super(key: key);

  @override
  _RequestListItemState createState() => _RequestListItemState();
}

class _RequestListItemState extends State<RequestListItem> {
  Color colorMain = Color.fromRGBO(255, 193, 7, 1);
  Color colorMainDanger = Color.fromRGBO(242, 78, 30, 1);
  Color colorMainNull = Color.fromRGBO(153, 153, 153, 1);

  @override
  Widget build(BuildContext context) {
    Image imagedefault = new Image.asset(
      "assets/images/company.png",
    );
    Color colorMain = Color.fromRGBO(255, 193, 7, 1);

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
      margin: EdgeInsets.only(
        left: 10,
      ),
      //height: 60,
      child: Container(
        //color: Colors.red,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListTile(
              title: Text(
                widget.clientRequest!.numeroPasageros.toString(),
              ),
              subtitle: Text(
                "Nit: " + widget.clientRequest!.rango.toString(),
              ),
            )
          ],
        ),
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
                      onPressed: () {
                        //showAlertDialog();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        /* Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new CompanyEditScreen(widget.clientRequest),
                          ),
                        );*/
                      },
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
      color: Color.fromRGBO(246, 246, 246, 1),
      margin:
          new EdgeInsets.only(top: 5.0, bottom: 5.0, left: 00.0, right: 00.0),
      child: Material(
        child: InkWell(
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
                Expanded(
                  flex: 0,
                  child: columnThree,
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
