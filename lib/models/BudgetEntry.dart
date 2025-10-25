import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

enum TransactionType { income, expense, transfer }

class TransactionModel {
  
  static TransactionModel fromMap(Map<String, Object?> map)
  {
    return TransactionModel(
      id: map["id"] == null ? -1 : map["id"] as int,
      title: map["title"] == null ? "" : map["title"] as String, 
      category: map["category"] == null ? "" : map["category"] as String, 
      description: map["description"] == null ? "" : map["description"] as String, 
      
      transactionDateTime: DateTime.tryParse(
        (map["transactionDateTime"] == null ? "" : map["transactionDateTime"] as String)
      ) ?? DateTime.now(),

      transactionAmount: map["transactionAmount"] == null ? 0.0 : map["transactionAmount"] as double,
      transType: TransactionType.values.byName(map["transactionType"] == null ? "" : map["transactionType"] as String),
      account: map["account"] == null ? "" : map["account"] as String,
      fromAccount: map["fromAccount"] == null ? "" : map["fromAccount"] as String,
      toAccount: map["toAccount"] == null ? "" : map["toAccount"] as String,
      transferFees: map["transferFees"] == null ? 0.0 : map["transferFees"] as double
    );
  }

  TransactionModel({
    int? id,
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
  }) : id = id ?? (Uuid().v4()).hashCode;

  int id;
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

  TransactionModel copyWith({
    int? id,
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

  Map<String, Object> toMap()
  {
    return {
      "title": title,
      "category": category,
      "account" : account,
      "fromAccount" : fromAccount,
      "toAccount" : toAccount,
      "transactionAmount" : transactionAmount,
      "transferFees" : transferFees,
      "transactionDateTime" : transactionDateTime.toIso8601String(),
      "description" : description,
      "transactionType" : transType.name,
    };
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