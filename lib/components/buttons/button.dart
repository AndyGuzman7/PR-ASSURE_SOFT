import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final bool isSelected;
  final int exampleNumber;
  //final VoidCallback onPressed;

  const Button({
    required Key? key,
    required this.isSelected,
    required this.exampleNumber,
    //required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        //width: MediaQuery.of(context).size.height,
        //constraints: BoxConstraints.expand(height: 100),
        child: TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: isSelected ? Colors.grey : Colors.grey[800],
      ),
      child: Text("comis"),
      onPressed: () {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          alignment: 0.5,
        );
        //onPressed();
      },
    ));
  }
}
