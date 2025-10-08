import 'package:flutter/material.dart';

class VerticalCounterLabel extends StatelessWidget {
  VerticalCounterLabel(
    {
      super.key, String label = "", String counterVal = "", double spacing = 0,
      TextStyle? labelStyle, TextStyle? counterStyle 
    }
  ):
  _labelText = label,
  _counterValue = counterVal,
  _spacing = spacing,
  _labelStyle = labelStyle,
  _counterStyle = counterStyle;

  final String _labelText;
  String _counterValue;

  final double _spacing;
  final TextStyle? _labelStyle;
  final TextStyle? _counterStyle;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _labelText,
          style: _labelStyle
        ),

        SizedBox(height: _spacing),

        Text(
          _counterValue,
          style:_counterStyle
        ),
      ],
    );
  }
}