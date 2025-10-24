import 'package:expenses_tracker/models/BudgetEntry.dart';
import 'package:flutter/material.dart';

class TransactionService extends ChangeNotifier
{
  final List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  final Map<DateTime, List<TransactionModel>> _transactionsGroupedByDate = {};
  Map<DateTime, List<TransactionModel>> get transactionsGroupedByDate => _transactionsGroupedByDate;


  void addTransaction(TransactionModel newTransaction)
  {
    transactions.add(newTransaction);

    if (_transactionsGroupedByDate.containsKey(newTransaction.dateOnly))
    {
      _transactionsGroupedByDate[newTransaction.dateOnly]!.add(newTransaction);
    }
    else
    {
      _transactionsGroupedByDate[newTransaction.dateOnly] = [newTransaction];
    }

    notifyListeners();
  }

  double getTransactionsNetExpense(List<TransactionModel> transactions)
  {
    double total = 0;
    for (TransactionModel transaction in transactions)
    {
      switch (transaction.transType) {
        case TransactionType.income:
          total += transaction.transactionAmount;
        case TransactionType.expense:
          total -= transaction.transactionAmount;
        case TransactionType.transfer:
      }
    }

    return total;
  }

  double getTotalExpenses()
  {
    double total = 0;
    for (TransactionModel transaction in _transactions)
    {
      if (transaction.transType == TransactionType.expense)
      {
        total += transaction.transactionAmount;
      }
    }

    return total;
  }

  double getTotalIncome()
  {
    double total = 0;
    for (TransactionModel transaction in _transactions)
    {
      if (transaction.transType == TransactionType.income)
      {
        total += transaction.transactionAmount;
      }
    }

    return total;
  }
}