
import 'dart:ffi';
import 'dart:math';

import 'package:expenses_tracker/delegates/SliverPersistentHeaderDelegates.dart';
import 'package:expenses_tracker/models/BudgetEntry.dart';
import 'package:expenses_tracker/slivers/delegates.dart';
import 'package:expenses_tracker/utils/StringUtils.dart';
import 'package:expenses_tracker/widgets/Cards.dart';
import 'package:expenses_tracker/widgets/Footers.dart';
import 'package:expenses_tracker/widgets/Labels.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliver_tools/sliver_tools.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final Color bgColor = Color.fromRGBO(245, 238, 255, 1);
  final Color netLossColor = Colors.pink;
  final Color netGainColor = Colors.green;

  final Map<DateTime, List<BudgetEntry>> _budgets = {
    DateTime.now() : 
    List<BudgetEntry>.generate(
      10,
      (index) => BudgetEntry(
        title: "Entry $index", 
        description: "Description #$index",
        category: "Food", 
        date: DateTime.now(), 
        transaction: Random().nextDouble() * 1000,
        icon: Icon(Icons.dining, size: 50)
      )
    ),

    DateTime.now().subtract(Duration(days: 1)) : 
    List<BudgetEntry>.generate(
      10,
      (index) => BudgetEntry(
        title: "Entry $index", 
        description: "Description #$index",
        category: "Food", 
        date: DateTime.now().subtract(Duration(days: 1)), 
        transaction: Random().nextDouble() * 1000,
        icon: Icon(Icons.dining, size: 50)
      )
    ),

    DateTime.now().subtract(Duration(days: 2)) : 
    List<BudgetEntry>.generate(
      10,
      (index) => BudgetEntry(
        title: "Entry $index", 
        description: "Description #$index",
        category: "Food", 
        date: DateTime.now().subtract(Duration(days: 2)), 
        transaction: Random().nextDouble() * 1000,
        icon: Icon(Icons.dining, size: 50)
      )
    )
  };

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: bgColor,
        elevation: 0,
        centerTitle: true,
        title: Text("Home", style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.menu, size: 30, weight: 10, color: Colors.black),
          onPressed: () {},
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {}, 
                  icon: Icon(Icons.search_rounded, size: 30, weight: 10, color: Colors.black)
                ),
                
                IconButton(
                  onPressed: () {}, 
                  icon: Icon(Icons.calendar_month, size: 30, weight: 10, color: Colors.black)
                ),
              ],
            ),
          ),
        ],
      ),


      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 70),
            child: CustomScrollView(
              slivers: [
                for (final date in _budgets.keys) ...[
                  MultiSliver(
                    pushPinnedChildren: true,
                    children: [
                      DatedExpensesPinnedHeader(
                        date: date, 
                        label: getFormattedCurrencyAmount(100000),
                        isNetGain: Random().nextBool(),
                        dateStyle: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                        labelStyle: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                      ),
                    
                      SliverList(delegate: SliverChildBuilderDelegate(
                          (content, index)
                          {
                            bool shouldAddDivider = index != _budgets[date]!.length-1;

                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: ExpenseCard(budgetEntry: _budgets[date]![index]),
                                ),
                                if (shouldAddDivider) 
                                Divider(
                                  height: 21,
                                  thickness: 1.85,
                                  color: Color.fromARGB(32, 0, 0, 0),
                                ),
                              ],
                            );
                          },
                          childCount: _budgets[date]!.length
                        )
                      )
                    ],
                  ),
                ]
              ],
            ),
          ),
          
          IgnorePointer(
            child: HeadingBalanceContainer(
              height: 75,
              dividerHeight: 50,
              dividerThickness: 1.75,
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: BoxBorder.fromLTRB(
            top: BorderSide(
              color: const Color.fromARGB(210, 129, 61, 255),
              width: 2
            )
          )
        ),

        child: BottomAppBar(
          elevation: 10,
          height: 50,
          color: bgColor,

          child: Row(
            spacing: 100,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.home_filled, color: Colors.deepPurple, size: 35),
                onPressed: () {},
              ),
          
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.settings, size: 35),
                onPressed: () {},
              ),
            ]
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: const Color.fromARGB(210, 129, 61, 255),
            width: 2
          )
        ),
        backgroundColor: const Color.fromARGB(255, 221, 195, 255),
        onPressed: () {},
        tooltip: "Add Transaction",
        child: Icon(Icons.add),
      ),
    );
  }
}

class DatedExpensesPinnedHeader extends StatelessWidget {
  DatedExpensesPinnedHeader({
    super.key,
    required this.date,
    required this.label,
    required this.isNetGain,
    this.dateStyle,
    this.labelStyle,
    this.spacing = 0,
    this.boxDecoration,
  })
  {
    Color gainColor = const Color.fromARGB(255, 41, 169, 255);
    Color lossColor = Colors.pink;

    boxDecoration ??= BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      border: BoxBorder.fromLTRB(
        top: BorderSide(
          color: isNetGain ? gainColor : lossColor,
          width: 2
        ),
        bottom: BorderSide(
          color: isNetGain ? gainColor : lossColor,
          width: 2
        ),
        left: BorderSide(
          color: isNetGain ? gainColor : lossColor,
          width: 2
        ),
        right: BorderSide(
          color: isNetGain ? gainColor : lossColor,
          width: 2
        )
      ),
      color: Color.fromRGBO(245, 238, 255, 1),
      boxShadow: [
        BoxShadow(
          color: isNetGain ? gainColor : lossColor,
          blurRadius: 6,
          offset: Offset(0, 3)
        )
      ]
    );
  }

  bool isNetGain = true;
  final DateTime date;
  final String label;
  final TextStyle? dateStyle;
  final TextStyle? labelStyle;

  final double spacing;
  BoxDecoration? boxDecoration;



  @override
  Widget build(BuildContext context) {
    return SliverPinnedHeader(
      child: Container(
        decoration: boxDecoration, 
        height: 50,
        width: double.infinity,
        child: HorizontalDatedLabel(
          date: date,
          label: label,
                
          spacing: 100,
          dateStyle: dateStyle,
          labelStyle: labelStyle
        ),
      )
    );
  }
}

class HeadingBalanceContainer extends StatelessWidget {
  const HeadingBalanceContainer({
    super.key,
    this.width, 
    this.height,
    this.dividerThickness,
    this.dividerHeight
  });

  final double? width;
  final double? height;
  final double? dividerThickness;
  final double? dividerHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color:  const Color.fromARGB(255, 76, 0, 216).withValues(alpha: .6),
            blurRadius: 2,
            offset: const Offset(0, 4)
          ),
        ],
        borderRadius: BorderRadius.circular(3),
        color: Color.fromARGB(255, 177, 94, 255)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            VerticalCounterLabel(
              label: "Expenses",
              labelStyle: TextStyle(),
              
              counterVal: getFormattedCurrencyAmount(3000),
              counterStyle: TextStyle(
                fontWeight: FontWeight.bold
              ),
    
              spacing: 2,
    
            ),
    
            Container(
              color: Colors.black.withValues(alpha: 1),
              width: dividerThickness,
              height: dividerHeight,
            ),
            
            VerticalCounterLabel(
              label: "Income",
              labelStyle: TextStyle(),
              
              counterVal: getFormattedCurrencyAmount(60000),
              counterStyle: TextStyle(
                fontWeight: FontWeight.bold
              ),
    
              spacing: 2,
    
            ),
    
            Container(
              color: Colors.black.withValues(alpha: 1),
              width: dividerThickness,
              height: dividerHeight,
            ),

            VerticalCounterLabel(
              label: "Balance",
              labelStyle: TextStyle(),
              
              counterVal: getFormattedCurrencyAmount(57000),
              counterStyle: TextStyle(
                fontWeight: FontWeight.bold
              ),
    
              spacing: 2,
    
            ),
          ],
        ),
      ),
    );
  }
}