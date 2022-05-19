import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  CustomSlider({Key? key}) : super(key: key);
  late double value = 2;

  @override
  State<CustomSlider> createState() => _CustomSliderState();
  double getValue() {
    return value;
  }
}

class _CustomSliderState extends State<CustomSlider> {
  @override
  Widget build(BuildContext context) {
    return Slider(
      value: widget.value,
      max: 3,
      divisions: 3,
      label: widget.value.round().toString(),
      onChanged: (double value) {
        setState(() {
          widget.value = value;
        });
      },
    );
  }
}
