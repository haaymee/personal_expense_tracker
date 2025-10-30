import 'dart:ui';

import 'package:expenses_tracker/colors.dart';
import 'package:expenses_tracker/models/BudgetEntry.dart';
import 'package:expenses_tracker/pages/AddTransactionPopUp.dart';
import 'package:expenses_tracker/providers/TransactionListProvider.dart';
import 'package:expenses_tracker/utils/StringUtils.dart';
import 'package:expenses_tracker/widgets/Cards.dart';
import 'package:expenses_tracker/widgets/Labels.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TransactionListController controller = TransactionListController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {      
      await context.read<TransactionListProvider>().updateTransactionLists(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) 
  {
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

              onPressed: () async {
                await context.read<TransactionListProvider>().updatePreviousTransactionLists();
                controller.showPrevious();
              },
            ),

            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 200),
              child: Center(
                child: Text(
                  DateFormat("MMMM yyyy").format(context.watch<TransactionListProvider>().currentDateView),
                  style: GoogleFonts.lexend(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
            ),

            IconButton(
              icon: SvgPicture.asset(
                "assets/icons/navigation/chevron-right.svg",
                width: 35,
                height: 35,  
              ),

              onPressed: () async {
                await context.read<TransactionListProvider>().updateNextTransactionLists();
                controller.showNext();
              },
            ),
          ],
        ),

      ),

      body: Stack(
        children: [

          TransactionPagesWidget(
            controller: controller,
          ),
            
          IgnorePointer(
            child: HeadingBalanceContainer(
              balance: 0,
              expenses: context.watch<TransactionListProvider>().currentMonthTotalExpenses,
              income: context.watch<TransactionListProvider>().currentMonthTotalIncome,
            
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

class TransactionPagesWidget extends StatefulWidget {
  TransactionPagesWidget(
    {
      super.key,
      required this.controller,
    }
  );

  TransactionListController controller;

  @override
  State<TransactionPagesWidget> createState() => _TransactionPagesWidgetState();
}

class _TransactionPagesWidgetState extends State<TransactionPagesWidget> {
  
  int _currentIndex = 1; // 0 = previous, 1 = current, 2 = next
  bool _isNext = true;

  @override
  void initState() {
    super.initState();
    widget.controller._attach(_showNext, _showPrevious);
  }

  void _showNext() {
    setState(() {
      _isNext = true;
      _currentIndex = (_currentIndex + 1) % 3;
    });
  }

  void _showPrevious() {
    setState(() {
      _isNext = false;
      _currentIndex = (_currentIndex - 1 + 3) % 3;
    });
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        final outAnimation = Tween<Offset>(
          begin: Offset(_isNext ? -1 : 1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));

        final inAnimation = Tween<Offset>(
          begin: Offset(_isNext ? 1 : -1, 0),
          end:  Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));

        return SlideTransition(
          position: child.key == ValueKey(_currentIndex)
              ? inAnimation // new child
              : outAnimation, // old child
          child: child,
        );
      },
      child: TransactionListWidget(
        groupedTransactions: context.watch<TransactionListProvider>().currentMonthSortedTransactions,
        key: ValueKey(_currentIndex), 
      ),
    );
  }
}

class TransactionListWidget extends StatelessWidget {
  const TransactionListWidget({
    super.key,
    required Map<DateTime, List<TransactionModel>> groupedTransactions,
  }) : _groupedTransactions = groupedTransactions;

  final Map<DateTime, List<TransactionModel>> _groupedTransactions;

  @override
  Widget build(BuildContext context) {
    return _groupedTransactions.isEmpty ? Center(child: Text("No Transactions"))
    : Padding(
    padding: const EdgeInsets.only(top: 70),
    child: CustomScrollView(
      slivers: [
        for (final date in _groupedTransactions.keys) ...[
    
          MultiSliver(
            pushPinnedChildren: true,
            children: [
              Builder(
                builder: (context) {
    
                  double netExpenses = context.watch<TransactionListProvider>()
                    .currentMonthNetExpenses;
    
                  return DatedExpensesPinnedHeader(
                    date: date, 
                    label: getFormattedCurrencyAmount(netExpenses * -1),
                    isNetGain: netExpenses < 0,
                    dateStyle: GoogleFonts.lexend(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: fadedBlack
                    ),
                    labelStyle: GoogleFonts.lexend(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      shadows: [
                        Shadow(
                          color: (netExpenses > 0 ? netLossColor : netGainColor).withValues(alpha: .6),
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        )
                      ],
                      color: fadedBlack
                    ),
                  );
                }
              ),
            
              SliverList(delegate: SliverChildBuilderDelegate(
                  (content, index)
                  {
                    bool shouldAddDivider = index != _groupedTransactions[date]!.length-1;
    
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ExpenseCard(budgetEntry: _groupedTransactions[date]![index]),
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
                  childCount: _groupedTransactions[date]!.length
                )
              )
            ],
          ),
        ]
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


class TransactionListController {
  void Function()? _next;
  void Function()? _previous;

  void _attach(void Function() next, void Function() previous) {
    _next = next;
    _previous = previous;
  }

  void showNext() => _next?.call();
  void showPrevious() => _previous?.call();
}