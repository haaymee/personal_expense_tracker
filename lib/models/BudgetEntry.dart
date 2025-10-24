import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

enum TransactionType { income, expense, transfer }

class TransactionModel {
  TransactionModel({
    String? id,
    required this.title,
    required this.category,
    required this.transactionDateTime,
    required this.transactionAmount,
    required this.transType,
    this.transferFees = 0.0,
    this.account = "",
    this.fromAccount = "",
    this.toAccount = "",
    this.description = "",
    this.icon,
  }) : id = id ?? const Uuid().v4();

  String id;
  String title;
  String category;
  TransactionType transType;
  String account;
  String fromAccount;
  String toAccount;
  double transactionAmount;
  double transferFees;
  DateTime transactionDateTime;
  String description;
  Icon? icon;

  DateTime get dateOnly => DateTime(
    transactionDateTime.year, 
    transactionDateTime.month,
    transactionDateTime.day
  );

  TransactionModel copyWith({
    String? id,
    String? title,
    String? category,
    String? account,
    String? fromAccount,
    String? toAccount,
    double? transactionAmount,
    double? transferFees,
    DateTime? date,
    String? description,
    Icon? icon,
    TransactionType? transType,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      account: account ?? this.account,
      fromAccount: fromAccount ?? this.fromAccount,
      toAccount: toAccount ?? this.toAccount,
      transactionAmount: transactionAmount ?? this.transactionAmount,
      transferFees: transferFees ?? this.transferFees,
      transactionDateTime: date ?? this.transactionDateTime,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      transType: transType ?? this.transType,
    );
  }

  void printTransaction()
  {
    print('''
      Transaction Type: ${transType.name}
      Date: ${DateFormat("dd/MM/yy (E)").format(transactionDateTime)},
      Transaction Amount: $transactionAmount
      Category: $category,
      Account: $account,
      Title: $title,
      Description: $description,

      From Acc: $fromAccount,
      To Acc: $toAccount,
      Transfer Fees: $transferFees
    ''');
  }
}