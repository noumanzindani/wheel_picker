import 'package:flutter/material.dart';
import 'package:scroll_wheel_selector/scroll_wheel_selector.dart';

/// Entry point of the example application.
///
/// Runs the [MyApp] widget which demonstrates how to use
/// the [WheelPicker] from the `scroll_wheel_selector` package.
void main() {
  runApp(const MyApp());
}

/// Example application for demonstrating the [WheelPicker] widget.
///
/// This app shows a scrollable wheel with values from 0 to 49.
/// The user can select a value, and the selected value will be
/// printed to the debug console.
class MyApp extends StatelessWidget {
  /// Creates an instance of [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          /// Example usage of [WheelPicker].
          ///
          /// In this case, the picker:
          /// - Displays numbers from 0 to 49.
          /// - Has an initial value of 10.
          /// - Highlights the selected value in white.
          /// - Colors unselected values in grey.
          /// - Uses a blue line as the selection indicator.
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
