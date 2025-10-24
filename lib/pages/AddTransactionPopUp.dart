import 'dart:ui';
import 'package:expenses_tracker/colors.dart';
import 'package:expenses_tracker/models/BudgetEntry.dart';
import 'package:expenses_tracker/services/TransactionService.dart';
import 'package:expenses_tracker/widgets/Inputs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TransactionWindow extends StatefulWidget {
  TransactionWindow({
    super.key,
    required this.inputLabelHeaderStyle,
  });

  final TextStyle inputLabelHeaderStyle;

  final List<String> accounts = [
    "Cash",
    "GoTyme Savings",
    "Unionbank Savings",
    "GCash"
  ];

  final List<String> categories = [
    "Food",
    "Household",
    "Tech",
    "School"
  ];

  @override
  State<TransactionWindow> createState() => _TransactionWindowState();
}


class _TransactionWindowState extends State<TransactionWindow> {
  final TransactionModel _transactionToAdd = TransactionModel(
    title: "", 
    category: "", 
    transactionDateTime: DateTime.now(), 
    transactionAmount: 0.00, 
    transType: TransactionType.income,
  );

  @override
  void initState() {
    super.initState();

    _transactionToAdd.category = widget.categories[0];

    _transactionToAdd.account = widget.accounts[0];
    _transactionToAdd.fromAccount = widget.accounts[0];
    _transactionToAdd.toAccount = widget.accounts[0];
  }

  void updateTransactionType(String? newTransType)
  {
    if (newTransType != null)
    {
      setState(() {
        _transactionToAdd.transType = TransactionType.values.byName(newTransType.toLowerCase());
      }); 
    }    
  }

  void updateTransactionDate(DateTime newDate)
  {
    setState(() {
      _transactionToAdd.transactionDateTime = _transactionToAdd.transactionDateTime.copyWith(
        year: newDate.year,
        month: newDate.month,
        day: newDate.day
      );
    }); 
  }

  void updateTransactionTime(TimeOfDay newDateTimeOfDay)
  {
    setState(() {
      _transactionToAdd.transactionDateTime = _transactionToAdd.transactionDateTime.copyWith(
        hour: newDateTimeOfDay.hour,
        minute: newDateTimeOfDay.minute
      );
    });     
  }

  void updateTransactionAmount(double newTransactionAmount)
  {
    _transactionToAdd.transactionAmount = newTransactionAmount;
  }

  void updateTransactionCategory(String? newCategory)
  {
    if (newCategory != null)
    {
      _transactionToAdd.category = newCategory;
    }
  }

  void updateTransactionAccount(String? newAccount)
  {
    if (newAccount != null)
    {
      _transactionToAdd.account = newAccount;
    }
  }

  void updateTransactionTitle(String? newTitle)
  {
    if (newTitle != null)
    {
      _transactionToAdd.title = newTitle;
    }
  }

  void updateTransactionDescription(String? newDescription)
  {
    if (newDescription != null)
    {
      _transactionToAdd.description = newDescription;
    }
  }

  void updateTransactionTransferOutgoingAccount(String? outgoingAcc)
  {
    if (outgoingAcc != null)
    {
      _transactionToAdd.fromAccount = outgoingAcc;
    }
  }

  void updateTransactionTransferIncomingAccount(String? incomingAcc)
  {
    if (incomingAcc != null)
    {
      _transactionToAdd.toAccount = incomingAcc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: BoxBorder.all(color: primaryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: primaryColorShadow,
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 1
          )
        ]
      ),
      
      child: Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        children: [
          
          Center(
            child: Text(
              "Add Transaction",
              style: GoogleFonts.lexend(
                color: fadedBlack,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
    
          TransactionTypeInput(
            inputLabelHeaderStyle: widget.inputLabelHeaderStyle,
            transactionType: _transactionToAdd.transType,
            updateTransactionModelCallback: updateTransactionType,
          ),
    
          DateInput(
            inputLabelHeaderStyle: widget.inputLabelHeaderStyle,
            dateTimeToShow: _transactionToAdd.transactionDateTime,
            updateDateCallback: updateTransactionDate,
            updateTimeCallback: updateTransactionTime,
          ),
    
          AmountInput(
            widget: widget,
            updateTransactionAmountCallback: updateTransactionAmount,
          ),
    
          if (_transactionToAdd.transType != TransactionType.transfer) ...[
            CategoryInput(
              widget: widget,
              categoryChoices: widget.categories,

              updateTransactionCategoryCallback: updateTransactionCategory,
            ),
    
            AccountInput(
              widget: widget,
              accountChoices: widget.accounts,
              updateTransactionAccountInputCallback: updateTransactionAccount,
            ),
          ] else ...[
            AccountInput(
              widget: widget,
              accountChoices: widget.accounts,

              inputLabel: "From: ",
              borderColor: netLossColor,

              updateTransactionAccountInputCallback: updateTransactionTransferOutgoingAccount,
            ),

            AccountInput(
              widget: widget,
              accountChoices: widget.accounts,

              inputLabel: "To: ",
              borderColor: netGainColor,

              updateTransactionAccountInputCallback: updateTransactionTransferIncomingAccount,
            ),
          ],

          
    
          TitleInput(
            widget: widget,
            onTitleChangedCallback: updateTransactionTitle,
          ),
    
          DescriptionInput(
            widget: widget,
            onDescriptionChangedCallback: updateTransactionDescription,
          ),
    
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              DiscardButton(),
    
              ConfirmButton(
                onButtonPressed: () {
                  context.read<TransactionService>().addTransaction(_transactionToAdd);
                  Navigator.of(context).pop();
                },
              )  
            ],
          ),
        ],
      ),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({
    super.key,
    required this.onButtonPressed
  });

  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(150, 50)),
        backgroundColor: WidgetStatePropertyAll(netGainColor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            side: BorderSide(
              color: netGainColorAlternative,
              width: 1,
            ),
            borderRadius: BorderRadiusGeometry.circular(4)
          )
        )
      ),

      onPressed: onButtonPressed, 

      child: Text(
        "Confirm",
        style: GoogleFonts.lexend(
          color: fadedBlack,
          fontWeight: FontWeight.bold,
          fontSize: 18
        ),
      ),
    );
  }
}

class DiscardButton extends StatelessWidget {
  const DiscardButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(150, 50)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            side: BorderSide(
              color: netLossColor,
              width: 1,
            ),
            borderRadius: BorderRadiusGeometry.circular(4)
          )
        )
      ),
      child: Text(
        "Discard",
        style: GoogleFonts.lexend(
          color: fadedBlack, 
          fontWeight: FontWeight.w300,
          fontSize: 16
        ),
      ),
      onPressed: () {
    
      }, 
    );
  }
}

class DescriptionInput extends StatelessWidget {
  const DescriptionInput({
    super.key,
    required this.widget,
    required this.onDescriptionChangedCallback
  });

  final TransactionWindow widget;
  final Function(String?) onDescriptionChangedCallback;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [
          Text(
          "Description:",
          style: widget.inputLabelHeaderStyle,
        ),
        
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 100),
            child: Container(
              decoration: BoxDecoration(
                color: appBackgroundColor,
                border: BoxBorder.all(color: fadedBlack, width: 2),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: fadedBlack,
                    offset: Offset(2, 2),
                    blurRadius: 4
                  )
                ]
              ),
              child: TextField(
                minLines: 1,
                maxLines: 10,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  border: InputBorder.none
                ),
                style: GoogleFonts.lexend(
                  color: fadedBlack,
                  fontWeight: FontWeight.w300,
                  fontSize: 14
                ),
                onChanged: onDescriptionChangedCallback,
              ),
            ),
          )
        ),
      ],
    );
  }
}

class TitleInput extends StatelessWidget {
  const TitleInput({
    super.key,
    required this.widget,
    required this.onTitleChangedCallback
  });

  final TransactionWindow widget;
  final Function(String?) onTitleChangedCallback;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [
          Text(
          "Title:",
          style: widget.inputLabelHeaderStyle,
        ),
        
        Flexible(
          child: DebouncedAutocomplete(
            onTitleSelectedCallback: onTitleChangedCallback,
          )
        ),
      ],
    );
  }
}

class AccountInput extends StatelessWidget {
  const AccountInput({
    super.key,
    required this.widget,
    required this.updateTransactionAccountInputCallback,
    required this.accountChoices,
    this.inputLabel,
    this.borderColor,
  });

  final TransactionWindow widget;
  final Function(String?) updateTransactionAccountInputCallback;

  final String? inputLabel;
  final Color? borderColor;
  final List<String> accountChoices;


  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [
          Text(
          inputLabel ?? "Account:",
          style: widget.inputLabelHeaderStyle,
        ),
        
        Flexible(
          child: GenericDropdownButton(
            borderColor: borderColor ?? primaryColor,
            dropdownValues: accountChoices,
            onSelectedCallback: updateTransactionAccountInputCallback,
          )
        ),
      ],
    );
  }
}

class CategoryInput extends StatelessWidget {
  const CategoryInput({
    super.key,
    required this.widget,
    required this.updateTransactionCategoryCallback,
    required this.categoryChoices,
  });

  final TransactionWindow widget;
  final Function(String?) updateTransactionCategoryCallback;
  
  final List<String> categoryChoices;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [
          Text(
          "Category:",
          style: widget.inputLabelHeaderStyle,
        ),
        
        Flexible(
          child: GenericDropdownButton(
            dropdownValues: categoryChoices,
            onSelectedCallback: updateTransactionCategoryCallback,
          )
        ),
      ],
    );
  }
}

class AmountInput extends StatelessWidget {
  const AmountInput({
    super.key,
    required this.widget,
    required this.updateTransactionAmountCallback
  });

  final TransactionWindow widget;
  final Function(double) updateTransactionAmountCallback;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [
          Text(
          "Amount:",
          style: widget.inputLabelHeaderStyle,
        ),
        
        Flexible(
          child: TransactionAmountInputButton(
            onAmountInputChangedCallback: updateTransactionAmountCallback,
          )
        ),
      ],
    );
  }
}

class DateInput extends StatelessWidget {
  DateInput({
    super.key,
    required this.inputLabelHeaderStyle,
    required this.dateTimeToShow,
    required this.updateDateCallback,
    required this.updateTimeCallback,
  });

  DateTime dateTimeToShow;
  Function(DateTime) updateDateCallback;
  Function(TimeOfDay) updateTimeCallback;


  final TextStyle inputLabelHeaderStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [
        Text(
          "Date:",
          style: inputLabelHeaderStyle,
        ),
    
        Flexible(
          child: DateTimePickerButton(
            dateTimeToShow: dateTimeToShow,
            updateDateCallback: updateDateCallback,
            updateTimeCallback: updateTimeCallback,
          )
        ),
      ],
    );
  }
}

class TransactionTypeInput extends StatelessWidget {
  const TransactionTypeInput({
    super.key,
    required this.inputLabelHeaderStyle,
    required this.transactionType,
    required this.updateTransactionModelCallback
  });

  final TextStyle inputLabelHeaderStyle;
  final TransactionType transactionType;
  final Function(String?) updateTransactionModelCallback;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [
        Text(
          "Transaction Type:",
          style: inputLabelHeaderStyle,
        ),
    
        Expanded(
          child: GenericDropdownButton(
            borderColor: switch (transactionType) {

              TransactionType.income => netGainColor,
              TransactionType.expense => netLossColor,
              TransactionType.transfer => secondaryColor,

            },
            dropdownValues: [
              "Income",
              "Expense",
              "Transfer"
            ],
            onSelectedCallback: updateTransactionModelCallback,
          ),
        ),
      ],
    );
  }
}