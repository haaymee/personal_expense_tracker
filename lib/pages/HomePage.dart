import 'dart:math';
import 'dart:ui';

import 'package:expenses_tracker/colors.dart';
import 'package:expenses_tracker/models/BudgetEntry.dart';
import 'package:expenses_tracker/pages/AddTransactionPopUp.dart';
import 'package:expenses_tracker/services/TransactionService.dart';
import 'package:expenses_tracker/utils/StringUtils.dart';
import 'package:expenses_tracker/widgets/Cards.dart';
import 'package:expenses_tracker/widgets/Inputs.dart';
import 'package:expenses_tracker/widgets/Labels.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:svg_flutter/svg_flutter.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) 
  {
    final _transactions = context.watch<TransactionService>().transactionsGroupedByDate;

    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBackgroundColor,
        surfaceTintColor: appBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Row(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: SvgPicture.asset(
                "assets/icons/navigation/chevron-left.svg",
                width: 35,
                height: 35,  
              ),

              onPressed: () {

              },
            ),

            Text(
              DateFormat("MMMM").format(DateTime.now()),
              style: GoogleFonts.lexend(
                fontSize: 24,
                fontWeight: FontWeight.bold
              )
            ),

            IconButton(
              icon: SvgPicture.asset(
                "assets/icons/navigation/chevron-right.svg",
                width: 35,
                height: 35,  
              ),

              onPressed: () {
                
              },
            ),
          ],
        ),

      ),

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 70),
            child: CustomScrollView(
              slivers: [
                for (final date in _transactions.keys) ...[

                  MultiSliver(
                    pushPinnedChildren: true,
                    children: [
                      Builder(
                        builder: (context) {

                          double netExpenses = context.watch<TransactionService>()
                            .getTransactionsNetExpense(_transactions[date]!);

                          return DatedExpensesPinnedHeader(
                            date: date, 
                            label: getFormattedCurrencyAmount(netExpenses),
                            isNetGain: netExpenses > 0,
                            dateStyle: GoogleFonts.lexend(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: fadedBlack
                            ),
                            labelStyle: GoogleFonts.lexend(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: fadedBlack
                            ),
                          );
                        }
                      ),
                    
                      SliverList(delegate: SliverChildBuilderDelegate(
                          (content, index)
                          {
                            bool shouldAddDivider = index != _transactions[date]!.length-1;

                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: ExpenseCard(budgetEntry: _transactions[date]![index]),
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
                          childCount: _transactions[date]!.length
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
              balance: 0,
              expenses: context.watch<TransactionService>().getTotalExpenses(),
              income: context.watch<TransactionService>().getTotalIncome(),
            
              height: 75,
              dividerHeight: 50,
              dividerThickness: 1.75,
            )
          ),
          
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Column(
              spacing: 15,
              children: [
            
                Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 45),
                    child: Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: secondaryColor,
                        border: BoxBorder.all(color: secondaryColorShadow, width: .5),
                        boxShadow: [
                          BoxShadow(
                            color: secondaryColorShadow,
                            offset: Offset(2, 4),
                            blurRadius: 2,
                          )
                        ]
                      ),

                      child: IconButton(
                        icon: Icon(Icons.add),
                        color: appBackgroundColor,
                        onPressed: () {
                          
                          showBlurredFormDialog(context);

                        },
                      ),
                    ),
                  ),
                ),
            
                FloatingBottomBar(),
              ],
            )
          )
        ],
      ),

    );
  }
}

class FloatingBottomBar extends StatelessWidget {
  FloatingBottomBar({
    super.key,
  });

  final TextStyle labelStyle = GoogleFonts.lexend(
    color: fadedBlack,
    fontSize:10
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: appBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: secondaryColor,
            width: 3
          ),
          boxShadow: [
            BoxShadow(
              color: secondaryColorShadow,
              offset: Offset(2, 2),
              blurRadius: 2
            )
          ]
        ),
                
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: LabeledIcon(
                iconSrc: "assets/icons/navigation/receipt.svg",
                label: "Transactions",
                labelStyle: labelStyle,
                iconWidth: 32,
                iconHeight: 32,
                iconColor: fadedBlack,
              ),

              onPressed: () {

              },
            ),

            IconButton(
              icon: LabeledIcon(
                iconSrc: "assets/icons/navigation/chart.svg",
                label: "Stats",
                labelStyle: labelStyle,
                iconWidth: 32,
                iconHeight: 32,
                iconColor: fadedBlack,
              ),

              onPressed: () {

              },
            ),

            IconButton(
              icon: LabeledIcon(
                iconSrc: "assets/icons/navigation/account.svg",
                label: "Accounts",
                labelStyle:labelStyle,
                iconWidth: 32,
                iconHeight: 32,
                iconColor: fadedBlack,
              ),

              onPressed: () {
                
              },
            ),

            IconButton(
              icon: LabeledIcon(
                iconSrc: "assets/icons/navigation/settings.svg",
                label: "Settings",
                labelStyle: labelStyle,
                iconWidth: 32,
                iconHeight: 32,
                iconColor: fadedBlack,
              ),

              onPressed: () {
                
              },
            )
          ],
        ),
                
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

    boxDecoration ??= BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      border: BoxBorder.fromLTRB(
        top: BorderSide(
          color: isNetGain ? netGainColor : netLossColor,
          width: 2
        ),
        bottom: BorderSide(
          color: isNetGain ? netGainColor : netLossColor,
          width: 2
        ),
        left: BorderSide(
          color: isNetGain ? netGainColor : netLossColor,
          width: 2
        ),
        right: BorderSide(
          color: isNetGain ? netGainColor :  netLossColor,
          width: 2
        )
      ),
      color: appBackgroundColor,
      boxShadow: [
        BoxShadow(
          color: isNetGain ? netGainColor : netLossColor,
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
    required this.expenses,
    required this.income,
    required this.balance,

    this.width, 
    this.height,
    this.dividerThickness,
    this.dividerHeight
  });

  final double expenses;
  final double income;
  final double balance;

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
            color:  Colors.black.withValues(alpha: .4),
            blurRadius: 4,
            offset: const Offset(2, 2)
          ),
        ],
        borderRadius: BorderRadius.circular(3),
        color: primaryColor
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            VerticalCounterLabel(
              label: "Expenses",
              labelStyle: GoogleFonts.lexend(
                fontWeight: FontWeight.bold,
                color: appBackgroundColor
              ),
              
              counterVal: getFormattedCurrencyAmount(expenses),
              counterStyle: GoogleFonts.lexend(
                color: appBackgroundColor
              ),
              spacing: 2,
    
            ),
    
            Container(
              color: appBackgroundColor,
              width: dividerThickness,
              height: dividerHeight,
            ),
            
            VerticalCounterLabel(
              label: "Income",
              labelStyle: GoogleFonts.lexend(
                fontWeight: FontWeight.bold,
                color: appBackgroundColor
              ),

              counterVal: getFormattedCurrencyAmount(income),
              counterStyle: GoogleFonts.lexend(
                color: appBackgroundColor
              ),
    
              spacing: 2,
    
            ),
    
            Container(
              color: appBackgroundColor,
              width: dividerThickness,
              height: dividerHeight,
            ),

            VerticalCounterLabel(
              label: "Balance",
              labelStyle: GoogleFonts.lexend(
                fontWeight: FontWeight.bold,
                color: appBackgroundColor
              ),
              

              counterVal: getFormattedCurrencyAmount(balance),
              counterStyle: GoogleFonts.lexend(
                color: appBackgroundColor
              ),

              spacing: 2,
    
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showBlurredFormDialog(BuildContext context) async {
  
  TextStyle inputLabelHeaderStyle = GoogleFonts.lexend(
    color: fadedBlack,
    fontWeight: FontWeight.bold,
    fontSize: 16
  );

  await showGeneralDialog(
    context: context,
    barrierLabel: "Form",
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: .3), // dark overlay
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, animation, secondaryAnimation) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TransactionWindow(inputLabelHeaderStyle: inputLabelHeaderStyle),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      // Fade + Slide animation
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.05), // slight upward slide
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}