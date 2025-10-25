import 'package:expenses_tracker/interfaces/TransactionRepository.dart';
import 'package:expenses_tracker/models/BudgetEntry.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class TransactionRepositoryProvider extends ChangeNotifier 
{
  final ITransactionRepository repo;

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  Map<DateTime, List<TransactionModel>> _sortedTransactions = {};
  Map<DateTime, List<TransactionModel>> get sortedTransactions => _sortedTransactions;

  TransactionRepositoryProvider(this.repo);

  Future<void> loadTransactionsByYearAndMonth(int year, int month) async
  {
    DateTime query = DateTime(year, month);
    _transactions = await repo.getTransactionsByYearAndMonth(query) ?? [];
    await getTransactionsMappedByDay();

    notifyListeners();
  }

  Future<void> getTransactionsMappedByDay() async
  {
    sortedTransactions.clear();

    for (TransactionModel trans in _transactions)
    {
      sortedTransactions.putIfAbsent(
        trans.transactionDateTime.dateOnly, 
        () => []
      ).add(trans);
    }

    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel newTransaction) async
  {
    await repo.addTransaction(newTransaction);
    
    notifyListeners();
  }

  Future<TransactionModel?> getTransactionById(int id) async
  {
    TransactionModel? transaction = await repo.getTransactionById(id);
    notifyListeners();
    return transaction;
  }
  
  Future<List<TransactionModel>?> getTransactionsByYearAndMonth(DateTime dateYearMonthOnly) async
  {
    List<TransactionModel>? transaction = await repo.getTransactionsByYearAndMonth(dateYearMonthOnly);
    notifyListeners();
    return transaction;
  }

  Future<void> updateTransactionById(int id, TransactionModel newTransactionData) async
  {
    await repo.updateTransactionById(id, newTransactionData);
    notifyListeners();
  }

  Future<void> deleteTransactionById(int id) async
  {
    await repo.deleteTransactionById(id);
    notifyListeners();
  }

  double getTransactionsNetExpense(List<TransactionModel> list) 
  {
    double total = 0;
    for (TransactionModel x in list)
    {
      switch (x.transType) {
        case TransactionType.income:
          total -= x.transactionAmount;
        case TransactionType.expense:
          total += x.transactionAmount;
        case TransactionType.transfer:
          total += x.transferFees;          
      }
    }

    return total;
  }

  double getTotalExpenses() 
  {
    double total = 0;
    for (TransactionModel x in _transactions)
    {
      if (x.transType == TransactionType.expense)
      {
        total += x.transactionAmount;
      } else if (x.transType == TransactionType.transfer)
      {
        total += x.transferFees;
      }
    }

    return total;
  }

  double getTotalIncome() 
  {
    double total = 0;
    for (TransactionModel x in _transactions)
    {
      if (x.transType == TransactionType.income)
      {
        total += x.transactionAmount;
      } 
    }

    return total;
  }
}

extension DateTimeFormatting on DateTime
{
  DateTime get dateOnly => DateTime(year, month, day);
}