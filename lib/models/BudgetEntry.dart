import 'package:flutter/material.dart';

class BudgetEntry
{
  BudgetEntry(
    {
      required this.title, required this.category, 
      required this.date, required this.transaction,
      this.description = "", this.icon, 
    }
  );

  String title;
  String category;
  DateTime date;
  double transaction;
  String description;
  Icon? icon;

}