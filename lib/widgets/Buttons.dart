import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RaisedButton extends StatelessWidget {
  final String _hintText;
  final double _padding;
  final TextInputType _inputType;
  
  const RaisedButton({
    super.key,
    String hintText = "",
    double padding = 0,
    TextInputType inputType = TextInputType.text
  }) :
  _hintText = hintText,
  _padding = padding,
  _inputType = inputType;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.5,
      shadowColor: Color.fromARGB(255, 255, 255, 255),
    
      child: Padding(
        padding: EdgeInsets.all(_padding),
        child: TextField(
          decoration: InputDecoration(
    
            hint: Padding(
              padding: const EdgeInsets.fromLTRB(20,0,0,0),
              child: Text(
                _hintText,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Color.fromARGB(255, 161, 161, 161)),
              ),
            ),
            
            contentPadding: EdgeInsets.all(20),
    
            border: InputBorder.none,
    
            counterText: "",
          ),
    
          maxLength:254,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          keyboardType: _inputType,
        ),
      ),
    );
  }
}