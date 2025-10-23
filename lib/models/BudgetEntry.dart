import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum TransactionType { income, expense, transfer }

class TransactionModel {
  TransactionModel({
    String? id,
    required this.title,
    required this.category,
    required this.transactionDate,
    required this.transactionAmount,
    required this.transType,
    this.transferFees = 0.0,
    this.account = "",
    this.fromAccount = "",
    this.toAccount = "",
    this.description = "",
    this.icon,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String title;
  final String category;
  final TransactionType transType;
  final String account;
  final String fromAccount;
  final String toAccount;
  final double transactionAmount;
  final double transferFees;
  final DateTime transactionDate;
  final String description;
  final Icon? icon;

  TransactionModel copyWith({
    String? id,
    String? title,
    String? category,
    String? account,
    String? fromAccount,
    String? toAccount,
    double? transaction,
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
      transactionAmount: transaction ?? this.transactionAmount,
      transferFees: transferFees ?? this.transferFees,
      transactionDate: date ?? this.transactionDate,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      transType: transType ?? this.transType,
    );
  }
}