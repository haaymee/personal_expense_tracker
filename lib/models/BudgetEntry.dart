import 'package:flutter/material.dart';

class BudgetEntry
{
  String _title;
  String _category;
  String _description;
  Icon? _icon;

  DateTime _date = DateTime.now();

  double _expense = 0.0;

  set title(x) {_title = x;}
  set category(x) {_category = x;}
  set description(x) {_description = x;}
  set icon(x) {_icon = x;}
  set date(x) {_date = x;}
  set expense(x) {_expense = x;}

  String get title => _title;
  String get category => _category;
  String get description => _description;
  Icon? get icon => _icon;
  DateTime get date => _date;
  double get expense => _expense;

  BudgetEntry(
    {
      required String title, required String category, 
      required DateTime date, required double expense,
      String description = "", Icon? icon, 
    }
  ): 
  _title = title,
  _category = category,
  _date = date,
  _expense = expense,
  _description = description,
  _icon = icon;

}