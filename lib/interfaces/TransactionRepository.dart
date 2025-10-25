import 'package:expenses_tracker/models/BudgetEntry.dart';
import 'package:flutter/material.dart';

abstract class ITransactionRepository 
{
  // Create
  Future<void> addTransaction(TransactionModel newTransaction);

  // Read
  Future<TransactionModel?> getTransactionById(int id);
  Future<List<TransactionModel>?> getTransactionsByYearAndMonth(DateTime dateYearMonthOnly);

  // Update
  Future<void> updateTransactionById(int id, TransactionModel newTransactionData);

  // Delete
  Future<void> deleteTransactionById(int id);
}