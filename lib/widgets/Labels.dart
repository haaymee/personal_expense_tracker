import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class HorizontalDatedLabel extends StatelessWidget {
  HorizontalDatedLabel(
    {
      super.key, DateTime? date, String label = "", 
      TextStyle? dateStyle, TextStyle? labelStyle, String? dateFormat = "d MMMM y"
    }
  ):
  _label = label,
  _date = date,
  _dateStyle = dateStyle,
  _labelStyle = labelStyle,
  _dateFormat = dateFormat;


  final String _label;
  final DateTime? _date;
  final TextStyle? _dateStyle;
  final TextStyle? _labelStyle;
  final String? _dateFormat;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          DateFormat(_dateFormat).format(_date!),
          style: _dateStyle
        ),

        Text(
          _label,
          style: _labelStyle
        )
      ],
    );
  }
}