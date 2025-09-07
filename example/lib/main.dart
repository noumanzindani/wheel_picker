import 'package:flutter/material.dart';
import 'package:scroll_wheel_selector/scroll_wheel_selector.dart';

/// Example application for demonstrating the [WheelPicker] widget.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: WheelPicker(
            values: List.generate(50, (i) => i),
            initialValue: 10,
            lineColor: Colors.blue,
            selectedColor: Colors.white,
            unselectedColor: Colors.grey,
            onSelected: (value) {
              debugPrint("Selected value: $value");
            },
          ),
        ),
      ),
    );
  }
}
