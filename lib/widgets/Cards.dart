import 'package:expenses_tracker/colors.dart';
import 'package:expenses_tracker/models/BudgetEntry.dart';
import 'package:expenses_tracker/utils/StringUtils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard(
    {
      super.key, required TransactionModel budgetEntry
    }
  ): _budgetEntry = budgetEntry;

  final TransactionModel _budgetEntry;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 13,
          children: [
            _budgetEntry.icon != null ? _budgetEntry.icon! : Icon(Icons.disabled_by_default),
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _budgetEntry.title,
                  style: GoogleFonts.lexend(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: fadedBlack
                  ),
                ),


                SizedBox(
                  width: 175,
                  child: Text(
                    _budgetEntry.description,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lexend(
                      color: Color.fromARGB(255, 133, 133, 133),
                      fontWeight: FontWeight.lerp(FontWeight.w300, FontWeight.w400, .35)
                    ), 
                  ),
                ),
              ],
            ),
          ],
        ),

        Text(
          getFormattedCurrencyAmount(_budgetEntry.transactionAmount),
          style: GoogleFonts.lexend(
            fontWeight: FontWeight.w300,
            color: switch (_budgetEntry.transType) {
              TransactionType.income => netGainColor,
              TransactionType.expense => netLossColor,
              TransactionType.transfer => secondaryColor,
            },
            fontSize: 15,
          ),
        )
      ],
    );
  }
}