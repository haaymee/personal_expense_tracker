import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:svg_flutter/svg.dart';

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
      mainAxisAlignment: MainAxisAlignment.center,
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
      super.key, DateTime? date, String label = "", this.spacing = 0,
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
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      spacing: spacing,
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

class LabeledIcon extends StatelessWidget {
  const LabeledIcon({
    super.key,
    required this.iconSrc,
    required this.label,
    this.iconWidth = 12,
    this.iconHeight = 12,
    this.iconColor = Colors.black,
    this.labelStyle
  });

  final String iconSrc;
  final String label;

  final Color iconColor;
  final double iconWidth;
  final double iconHeight;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SvgPicture.asset(
          iconSrc,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          width: iconWidth,
          height: iconHeight,
          
        ),
    
        Text(
          label,
          style: labelStyle
        )
      ],
    );
  }
}