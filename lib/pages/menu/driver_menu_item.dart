import 'package:flutter/material.dart';

class MenuDriverItem extends StatelessWidget {
  final String text;
  final String iconPath;
  final String pageRoute;

  MenuDriverItem(
      {required this.text, required this.iconPath, required this.pageRoute});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, this.pageRoute);
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.blueGrey.shade50,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FractionallySizedBox(
                widthFactor: 0.5,
                child: Image.asset(this.iconPath),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Text(
                  this.text,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
