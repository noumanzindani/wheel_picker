import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A customizable scroll wheel picker widget.
///
/// The [WheelPicker] displays a scrollable list of values in a wheel-like
/// UI, allowing users to select one item at a time.
///
/// Example:
/// ```dart
/// WheelPicker(
///   values: List.generate(50, (i) => i),
///   initialValue: 10,
///   lineColor: Colors.blue,
///   selectedColor: Colors.white,
///   unselectedColor: Colors.grey,
///   onSelected: (value) {
///     print("Selected value: $value");
///   },
/// )
/// ```
class WheelPicker extends StatefulWidget {
  /// List of integer values to be displayed in the picker.
  final List<int> values;

  /// The value that should be initially selected.
  final int initialValue;

  /// Color for the currently selected value text.
  final Color selectedColor;

  /// Color for the unselected values text.
  final Color unselectedColor;

  /// Color of the horizontal selection indicator lines.
  final Color lineColor;

  /// Height of the picker widget.
  final double height;

  /// Width of the picker widget.
  final double width;

  /// The vertical space each item occupies in the wheel.
  final double itemExtent;

  /// Callback triggered when a value is selected.
  final ValueChanged<int>? onSelected;

  /// Custom text style for the selected value (optional).
  final TextStyle? selectedTextStyle;

  /// Custom text style for unselected values (optional).
  final TextStyle? unselectedTextStyle;

  /// Creates a new [WheelPicker].
  const WheelPicker({
    super.key,
    required this.values,
    this.initialValue = 0,
    this.selectedColor = Colors.white,
    this.unselectedColor = Colors.grey,
    this.lineColor = Colors.red,
    this.height = 420,
    this.width = 80,
    this.itemExtent = 70,
    this.onSelected,
    this.selectedTextStyle,
    this.unselectedTextStyle,
  });

  @override
  State<WheelPicker> createState() => _WheelPickerState();
}

/// State class for [WheelPicker].
///
/// Handles scrolling, selection updates, and rendering of the picker.
class _WheelPickerState extends State<WheelPicker> {
  late FixedExtentScrollController _controller;
  late int selectedValue;

  /// Initializes the scroll controller and sets the initial selected value.
  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
    _controller = FixedExtentScrollController(
      initialItem: widget.values.indexOf(widget.initialValue),
    );
  }

  /// Builds the wheel picker UI with selection lines and scrollable values.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Stack(
        children: [
          // Top line
          Positioned(
            top: widget.height / 2 - widget.itemExtent / 2,
            left: 0,
            right: 0,
            child: Container(height: 3, color: widget.lineColor),
          ),
          // Bottom line
          Positioned(
            top: widget.height / 2 + widget.itemExtent / 2,
            left: 0,
            right: 0,
            child: Container(height: 3, color: widget.lineColor),
          ),
          // Wheel picker
          ListWheelScrollView(
            controller: _controller,
            itemExtent: widget.itemExtent,
            perspective: 0.002,
            diameterRatio: 2.0,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) async {
              setState(() {
                selectedValue = widget.values[index];
              });
              try {
                HapticFeedback.vibrate();
              } catch (_) {}
              widget.onSelected?.call(selectedValue);
            },
            children: widget.values.map((value) {
              final bool isSelected = value == selectedValue;
              return Center(
                child: Text(
                  '$value',
                  style: isSelected
                      ? (widget.selectedTextStyle ??
                          TextStyle(
                            fontSize: 55,
                            color: widget.selectedColor,
                            fontWeight: FontWeight.bold,
                          ))
                      : (widget.unselectedTextStyle ??
                          TextStyle(
                            fontSize: 55,
                            color: widget.unselectedColor,
                            fontWeight: FontWeight.normal,
                          )),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Disposes the scroll controller to free resources.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
