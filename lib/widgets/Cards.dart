import 'package:expenses_tracker/models/BudgetEntry.dart';
import 'package:expenses_tracker/utils/StringUtils.dart';
import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard(
    {
      super.key, required BudgetEntry budgetEntry
    }
  ): _budgetEntry = budgetEntry;

  final BudgetEntry _budgetEntry;

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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  )
                ),


                SizedBox(
                  width: 175,
                  child: Text(
                    _budgetEntry.description,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color.fromARGB(255, 133, 133, 133)
                    )
                  ),
                ),
              ],
            ),
          ],
        ),

        Text(
          getFormattedCurrencyAmount(_budgetEntry.expense),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        )
      ],
    );
  }
}