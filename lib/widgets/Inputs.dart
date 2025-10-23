import 'dart:async';

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
    required this.dateTimeToShow,
    required this.updateDateCallback,
    required this.updateTimeCallback,
    this.inputBoxDeco,
    this.timeTextStyle,
    this.dateTextStyle,
  });

  DateTime dateTimeToShow;
  Function(DateTime) updateDateCallback;
  Function(TimeOfDay) updateTimeCallback;

  BoxDecoration? inputBoxDeco;
  TextStyle? dateTextStyle;
  TextStyle? timeTextStyle;

  @override
  State<DateTimePickerButton> createState() => _DateTimePickerButtonState();
}

class _DateTimePickerButtonState extends State<DateTimePickerButton> {
  
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
    );

    if (date == null) return;

    widget.updateDateCallback(date);
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.now()
    );

    if (time == null) return;

    widget.updateTimeCallback(time);
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
              DateFormat("dd/MM/yy (E)").format(widget.dateTimeToShow),
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
              DateFormat("jm").format(widget.dateTimeToShow),
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
    required this.onAmountInputChangedCallback,

    this.inputBoxDeco,
    this.currencyTextStyle
  });

  Function(double) onAmountInputChangedCallback;

  BoxDecoration? inputBoxDeco;
  TextStyle? currencyTextStyle;

  double inputAmount = 0.00;

  @override
  State<TransactionAmountInputButton> createState() => _TransactionAmountInputButtonState();
}

class _TransactionAmountInputButtonState extends State<TransactionAmountInputButton> {

  Timer? _debounceTimer;

  void onAmountInputChanged(double newAmount)
  {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 0), () {

      widget.inputAmount = newAmount;
      widget.onAmountInputChangedCallback(widget.inputAmount);

    });
  }

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
          hintText: "₱ ${widget.inputAmount.toStringAsFixed(2)}",
          hintStyle: widget.currencyTextStyle ?? GoogleFonts.lexend(
            color: fadedBlack.withValues(alpha: .4),
            fontWeight: FontWeight.w300
          )
        ),

        onChanged: (value) {

          String cleaned = value.replaceAll(RegExp(r'[^\d.]'), '');
          double parsedAmount = double.tryParse(cleaned) ?? 0.0;

          onAmountInputChanged(parsedAmount);
        },
      ),
    );
  }
}

class GenericDropdownButton extends StatelessWidget {
  GenericDropdownButton({
    super.key,
    this.itemTextStyle,
    this.activeIcon,
    this.idleIcon,
    this.onSelectedCallback,
    this.borderColor,
    required this.dropdownValues,
  });

  final TextStyle? itemTextStyle;
  final SvgPicture? activeIcon;
  final SvgPicture? idleIcon;
  Color? borderColor;

  List<String> dropdownValues;  

  Function(String?)? onSelectedCallback;
  

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(2,2),
            color: borderColor ?? fadedBlack,
            blurRadius: 4
          )
        ]
      ),

      child: LayoutBuilder(
        builder: (context, constraints) {
          return DropdownMenu<String>(
            width: double.infinity,
            initialSelection: dropdownValues[0],
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: appBackgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor ?? fadedBlack, width: 2)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor ?? fadedBlack, width: 2)),
          
            ),
            textStyle: itemTextStyle ?? GoogleFonts.lexend(color: fadedBlack, fontWeight: FontWeight.w300),
            menuStyle: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(appBackgroundColor),
              elevation: WidgetStatePropertyAll(6),
              maximumSize: WidgetStatePropertyAll(Size.fromWidth(constraints.maxWidth)),
              shadowColor: WidgetStatePropertyAll(const Color.fromARGB(164, 0, 0, 0)),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(4)),
              ),
            ),
          
            trailingIcon: idleIcon ?? SvgPicture.asset("assets/icons/navigation/chevron-down.svg"),
            selectedTrailingIcon: activeIcon ?? SvgPicture.asset("assets/icons/navigation/chevron-up.svg"),
          
            dropdownMenuEntries:  [

              for (final entry in dropdownValues) ...[
                DropdownMenuEntry(
                  value: entry, 
                  label: entry, 
                  style: ButtonStyle(
                    textStyle: WidgetStatePropertyAll(
                      itemTextStyle ?? GoogleFonts.lexend(color: fadedBlack, fontWeight: FontWeight.w300)
                    )
                  )
                ),
              ]
            ],
            onSelected: onSelectedCallback ?? (selected) {}
          );
        }
      ),
    );
  }
}

class DebouncedAutocomplete extends StatefulWidget {
  DebouncedAutocomplete({
    super.key,
    this.inputBoxDeco,
    this.listBoxDeco,
    this.labelTextStyle,
    required this.onTitleSelectedCallback
  });

  BoxDecoration? inputBoxDeco;
  BoxDecoration? listBoxDeco;

  TextStyle? labelTextStyle;
  
  final Function(String?) onTitleSelectedCallback;

  @override
  State<DebouncedAutocomplete> createState() => _DebouncedAutocompleteState();
}

class _DebouncedAutocompleteState extends State<DebouncedAutocomplete> {
  final List<String> allTitles = [
    'Groceries',
    'Electric Bill',
    'Internet',
    'Rent',
    'Coffee',
    'Transportation',
    'Gas',
    'Insurance',
    'Gym',
    'Subscriptions',
    'Movies',
    'Dining Out',
    'Clothes',
    'Gadgets',
  ];

  Timer? _debounce;
  final ValueNotifier<List<String>> _filtered = ValueNotifier([]);

  void _debounceFilter(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 0), () {
      final filtered = allTitles
          .where((title) => title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _filtered.value = filtered;


    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _filtered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        final query = textEditingValue.text.trim();

        // Trigger debounced filtering
        _debounceFilter(query);

        widget.onTitleSelectedCallback(query);

        // Return the latest computed results (via ValueNotifier)
        return _filtered.value;
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
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
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              isDense: true,
              hintText: "Enter Title",
              hintStyle: widget.labelTextStyle ?? GoogleFonts.lexend(color: fadedBlack.withValues(alpha: .4)),
              border: InputBorder.none,
            ),
            style: widget.labelTextStyle ?? GoogleFonts.lexend(color: fadedBlack, fontWeight: FontWeight.w300),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        final optList = options.toList();

        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 250),
          child: Container(
            decoration: widget.inputBoxDeco ?? BoxDecoration(
              color: const Color.fromARGB(255, 243, 243, 243),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .4),
                  offset: Offset(2, 2),
                  blurRadius: 8
                )
              ]
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: optList.length,
              itemBuilder: (context, index) {
                final title = optList[index];
                return ListTile(
                  title: Text(
                    title,
                    style: widget.labelTextStyle ?? GoogleFonts.lexend(
                      color: fadedBlack,
                      fontWeight: FontWeight.w300
                    ),
                  ),
                  onTap: () => onSelected(title),
                );
              },
            ),
          ),
        );
      },
      
      onSelected: (value) {
        widget.onTitleSelectedCallback(value);
      },
    );
  }
}