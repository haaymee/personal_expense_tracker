import 'package:expenses_tracker/widgets/Labels.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateHeaderDelegate extends SliverPersistentHeaderDelegate {
  final DateTime date;
  final double total;
  final double minExtentHeight;
  final double maxExtentHeight;
  final Color? bgColor;

  DateHeaderDelegate({
    required this.date,
    required this.total,
    this.minExtentHeight = 60,
    this.maxExtentHeight = 80,
    this.bgColor 
  });

  @override
  double get minExtent => minExtentHeight;

  @override
  double get maxExtent => maxExtentHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double opacity = 1 - (shrinkOffset / (maxExtent - minExtent)).clamp(0, 1);


    return Container(
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

      padding: EdgeInsets.only(top: 10),
      width: double.infinity,
      height: maxExtent,
      child: HorizontalDatedLabel(
        date: date,
        label: total.toStringAsFixed(2),

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
    );
  }
  
  @override
  bool shouldRebuild(covariant DateHeaderDelegate oldDelegate) {
    // Rebuild when date or totals change
    return false;
  }
}