import 'package:expenses_tracker/colors.dart';
import 'package:expenses_tracker/utils/StringUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:svg_flutter/svg.dart';

class ElevatedTextInput extends StatelessWidget {
  final String _hintText;
  final double _padding;
  final TextInputType _inputType;
  
  const ElevatedTextInput({
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

class DateTimePickerButton extends StatefulWidget {
  DateTimePickerButton({
    super.key,
    this.inputBoxDeco,
    this.timeTextStyle,
    this.dateTextStyle,
  });

  BoxDecoration? inputBoxDeco;
  TextStyle? dateTextStyle;
  TextStyle? timeTextStyle;

  @override
  State<DateTimePickerButton> createState() => _DateTimePickerButtonState();
}

class _DateTimePickerButtonState extends State<DateTimePickerButton> {
  
  DateTime? _selectedDateTime = DateTime.now();

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
    );

    if (date == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        _selectedDateTime!.hour,
        _selectedDateTime!.minute,
        _selectedDateTime!.second,
        _selectedDateTime!.millisecond,
        _selectedDateTime!.microsecond,
      );
    });
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.now()
    );

    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        _selectedDateTime!.year,
        _selectedDateTime!.month,
        _selectedDateTime!.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.inputBoxDeco ?? BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        border: BoxBorder.fromLTRB(
          bottom: BorderSide(
            color: fadedBlack,
            width: 2
          )
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            child: Text(
              DateFormat("dd/MM/yy (E)").format(_selectedDateTime!),
              style: widget.dateTextStyle ?? GoogleFonts.lexend(
                color: fadedBlack,
                fontWeight: FontWeight.w300,
                fontSize: 14
              ),
            ),
            onTap: () {
              _pickDate(context);
            },
          ),
    
          GestureDetector(
            child: Text(
              DateFormat("jm").format(_selectedDateTime!),
              style: widget.dateTextStyle ?? GoogleFonts.lexend(
                color: fadedBlack,
                fontWeight: FontWeight.w300,
                fontSize: 14
              ),
            ),

            onTap: () {
              _pickTime(context);
            },
          )
          
        ],
      ),
    );
  }
}

class TransactionTypeDropdownButton extends StatefulWidget {
  TransactionTypeDropdownButton({
    super.key,
    this.dropdownValues,
    this.inputBoxDeco,
    this.textStyle,
    this.idleIcon,
    this.activeIcon,
  });

  List<DropdownMenuItem<String>>? dropdownValues;

  BoxDecoration? inputBoxDeco;
  TextStyle? textStyle;
  SvgPicture? idleIcon;
  SvgPicture? activeIcon;


  @override
  State<TransactionTypeDropdownButton> createState() => TransactionTypeDropdownButtonState();
}

class TransactionTypeDropdownButtonState extends State<TransactionTypeDropdownButton> {

  Color transTypeColor = netGainColor;

  TextStyle itemTextStyle = GoogleFonts.lexend(
    color: fadedBlack, 
    fontWeight: FontWeight.w300,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(2,2),
            color: transTypeColor,
            blurRadius: 4
          )
        ]
      ),

      child: LayoutBuilder(
        builder: (context, constraints) {
          return DropdownMenu<String>(
            width: double.infinity,
            initialSelection: "income",
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: appBackgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: transTypeColor, width: 2)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: transTypeColor, width: 2)),
          
            ),
            textStyle: itemTextStyle,
            menuStyle: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(appBackgroundColor),
              elevation: WidgetStatePropertyAll(6),
              maximumSize: WidgetStatePropertyAll(Size.fromWidth(constraints.maxWidth)),
              shadowColor: WidgetStatePropertyAll(const Color.fromARGB(164, 0, 0, 0)),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(4)),
              ),
            ),
          
            trailingIcon: widget.idleIcon ?? SvgPicture.asset("assets/icons/navigation/chevron-down.svg"),
            selectedTrailingIcon: widget.activeIcon ?? SvgPicture.asset("assets/icons/navigation/chevron-up.svg"),
          
            dropdownMenuEntries: [
              DropdownMenuEntry(value: "income", label: "Income", style: ButtonStyle(textStyle: WidgetStatePropertyAll(itemTextStyle))),
              DropdownMenuEntry(value: "expenses", label: "Expenses", style: ButtonStyle(textStyle: WidgetStatePropertyAll(itemTextStyle))),
            ],
            onSelected:(value) {
              setState(() {
                transTypeColor = value == "income" ?  netGainColor : netLossColor;
              });
            }
          );
        }
      ),
    );
  }


}

class TransactionAmountInputButton extends StatefulWidget {
  TransactionAmountInputButton({
    super.key,
    this.inputBoxDeco,
    this.currencyTextStyle
  });

  BoxDecoration? inputBoxDeco;
  TextStyle? currencyTextStyle;

  @override
  State<TransactionAmountInputButton> createState() => _TransactionAmountInputButtonState();
}

class _TransactionAmountInputButtonState extends State<TransactionAmountInputButton> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.inputBoxDeco ?? BoxDecoration(
        border: BoxBorder.fromLTRB(
          bottom: BorderSide(
            color: fadedBlack,
            width: 2
          )
        )
      ),

      child: TextFormField(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          CurrencyInputFormatter(
            useSymbolPadding: true,
            leadingSymbol: "₱"
          ),
        ],
        style: widget.currencyTextStyle ?? GoogleFonts.lexend(
          color: fadedBlack,
          fontWeight: FontWeight.w300
        ),
        decoration: InputDecoration(
          isDense: true,
          border:InputBorder.none,
          hintText: "₱ 0.00",
          hintStyle: widget.currencyTextStyle ?? GoogleFonts.lexend(
            color: fadedBlack.withValues(alpha: .4),
            fontWeight: FontWeight.w300
          )
        ),
      ),
    );
  }
}
