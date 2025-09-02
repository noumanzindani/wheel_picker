library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WheelPicker extends StatefulWidget {
  final List<int> values;
  final int initialValue;
  final Color selectedColor;
  final Color unselectedColor;
  final Color lineColor;
  final double height;
  final double width;
  final double itemExtent;
  final ValueChanged<int>? onSelected;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;

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

class _WheelPickerState extends State<WheelPicker> {
  late FixedExtentScrollController _controller;
  late int selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
    _controller = FixedExtentScrollController(
      initialItem: widget.values.indexOf(widget.initialValue),
    );
  }

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
