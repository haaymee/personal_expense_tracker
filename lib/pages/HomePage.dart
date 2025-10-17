
import 'dart:ffi';
import 'dart:math';

import 'package:expenses_tracker/delegates/SliverPersistentHeaderDelegates.dart';
import 'package:expenses_tracker/models/BudgetEntry.dart';
import 'package:expenses_tracker/slivers/delegates.dart';
import 'package:expenses_tracker/widgets/Cards.dart';
import 'package:expenses_tracker/widgets/Labels.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliver_tools/sliver_tools.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final Color bgColor = Color.fromRGBO(245, 238, 255, 1);

  final Map<DateTime, List<BudgetEntry>> _budgets = {
    DateTime.now() : 
    List<BudgetEntry>.generate(
      10,
      (index) => BudgetEntry(
        title: "Entry $index", 
        description: "Description #$index",
        category: "Food", 
        date: DateTime.now(), 
        expense: Random().nextDouble() * 1000,
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
        expense: Random().nextDouble() * 1000,
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
        expense: Random().nextDouble() * 1000,
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
            padding: const EdgeInsets.only(top: 75),
            child: CustomScrollView(
              slivers: [
                for (final date in _budgets.keys) ...[
                  MultiSliver(
                    pushPinnedChildren: true,
                    children: [
                      SliverPinnedHeader(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color:  const Color.fromARGB(255, 255, 0, 106)!.withValues(alpha: .8),
                                blurRadius: 12,
                                offset: const Offset(0, 4)
                              ),
                            ],
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.pink[200]
                          ), 
            
                          height: 50,
                          width: double.infinity,
                          child: HorizontalDatedLabel(
                            date: date,
                            label: 10000.toString(),
            
                            spacing: 100,
                            dateStyle: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                            ),
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                            ),
                          ),
                        )
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
          
          HeadingBalanceContainer(
            height: 75,
            dividerHeight: 50,
            dividerThickness: 1.75,
          )

        ],
      ),

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
            color:  const Color.fromARGB(255, 0, 0, 0).withValues(alpha: .1),
            blurRadius: 5,
            offset: const Offset(0, 3)
          ),
        ],
        borderRadius: BorderRadius.circular(6),
        color: Color.fromARGB(255, 163, 223, 255)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            VerticalCounterLabel(
              label: "Expenses",
              labelStyle: TextStyle(),
              
              counterVal: "3,000",
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
              
              counterVal: "60,000",
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
              
              counterVal: "57,000",
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