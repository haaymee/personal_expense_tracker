import 'dart:async';
import 'dart:math';

import 'package:expenses_tracker/interfaces/TransactionRepository.dart';
import 'package:expenses_tracker/models/BudgetEntry.dart';
import 'package:expenses_tracker/services/TransactionService.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class TransactionListProvider extends ChangeNotifier 
{
  final TransactionService transactionService;
  TransactionListProvider(this.transactionService);

  DateTime _currentDateView = DateTime.now().monthYearOnly;
  DateTime get currentDateView  => _currentDateView;

  List<TransactionModel> _currentMonthTransactions = [];
  List<TransactionModel> get currentMonthTransactions =>_currentMonthTransactions;
  List<TransactionModel> _previousMonthTransactions = [];
  List<TransactionModel> get previousMonthTransactions =>_previousMonthTransactions;
  List<TransactionModel> _nextMonthTransactions = [];
  List<TransactionModel> get nextMonthTransactions =>_nextMonthTransactions;

  Map<DateTime, List<TransactionModel>> _currentMonthSortedTransactions = {};
  Map<DateTime, List<TransactionModel>> get currentMonthSortedTransactions => _currentMonthSortedTransactions;
  Map<DateTime, List<TransactionModel>> _previousMonthSortedTransactions = {}; 
  Map<DateTime, List<TransactionModel>> get previousMonthSortedTransactions => _previousMonthSortedTransactions; 
  Map<DateTime, List<TransactionModel>> _nextMonthSortedTransactions = {}; 
  Map<DateTime, List<TransactionModel>> get nextMonthSortedTransactions => _nextMonthSortedTransactions; 

  double _currentMonthNetExpenses = 0;
  double get currentMonthNetExpenses => _currentMonthNetExpenses;
  double _currentMonthTotalExpenses = 0;
  double get currentMonthTotalExpenses => _currentMonthTotalExpenses;
  double _currentMonthTotalIncome = 0;
  double get currentMonthTotalIncome => _currentMonthTotalIncome;

  Future<void> updateNextTransactionLists() async
  {
    _currentDateView = currentDateView.copyWith(month: currentDateView.month+1);
    DateTime nextDateView = currentDateView.copyWith(month: currentDateView.month+1);

    _previousMonthTransactions = _currentMonthTransactions;
    _currentMonthTransactions = _nextMonthTransactions;
    _nextMonthTransactions = await transactionService.getTransactionsByYearAndMonth(nextDateView) ?? [];

    _currentMonthSortedTransactions = await transactionService.sortTransactionsByDay(_currentMonthTransactions);
    _nextMonthSortedTransactions = await transactionService.sortTransactionsByDay(_nextMonthTransactions);
    _previousMonthSortedTransactions = await transactionService.sortTransactionsByDay(_previousMonthTransactions);

    await updateLoadedMonthlyTotals();

    notifyListeners();
  }

  Future<void> updatePreviousTransactionLists() async
  {
    _currentDateView = currentDateView.copyWith(month: currentDateView.month-1);
    DateTime previousDateView = currentDateView.copyWith(month: currentDateView.month-1);

    _nextMonthTransactions = currentMonthTransactions;
    _currentMonthTransactions = previousMonthTransactions;
    _previousMonthTransactions = await transactionService.getTransactionsByYearAndMonth(previousDateView) ?? [];

    _currentMonthSortedTransactions = await transactionService.sortTransactionsByDay(_currentMonthTransactions);
    _nextMonthSortedTransactions = await transactionService.sortTransactionsByDay(_nextMonthTransactions);
    _previousMonthSortedTransactions = await transactionService.sortTransactionsByDay(_previousMonthTransactions);

    await updateLoadedMonthlyTotals();

    notifyListeners();
  }

  Future<void> updateTransactionLists(DateTime yearAndMonth) async
  {
    _currentDateView = yearAndMonth.monthYearOnly;
    DateTime previousDateView = _currentDateView.copyWith(month: _currentDateView.month-1);
    DateTime nextDateView = _currentDateView.copyWith(month: _currentDateView.month+1);

    _nextMonthTransactions = await transactionService.getTransactionsByYearAndMonth(nextDateView) ?? [];
    _currentMonthTransactions = await transactionService.getTransactionsByYearAndMonth(_currentDateView) ?? [];
    _previousMonthTransactions = await transactionService.getTransactionsByYearAndMonth(previousDateView) ?? [];

    _currentMonthSortedTransactions = await transactionService.sortTransactionsByDay(_currentMonthTransactions);
    _nextMonthSortedTransactions = await transactionService.sortTransactionsByDay(_nextMonthTransactions);
    _previousMonthSortedTransactions = await transactionService.sortTransactionsByDay(_previousMonthTransactions);

    await updateLoadedMonthlyTotals();

    notifyListeners();
  }

  Future<void> updateLoadedMonthlyTotals()  async
  {
    _currentMonthNetExpenses = await transactionService.getNetExpenses(currentMonthTransactions);
    _currentMonthTotalExpenses = await transactionService.getTotalExpenses(currentMonthTransactions);
    _currentMonthTotalIncome = await transactionService.getTotalIncome(currentMonthTransactions);

    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel newTransaction) async
  {
    await transactionService.repo.addTransaction(newTransaction);
    notifyListeners();
  }

  Future<TransactionModel?> getTransactionById(int id) async
  {
    TransactionModel? transaction = await transactionService.getTransactionById(id);
    notifyListeners();
    return transaction;
  }
  
  Future<void> updateTransactionById(int id, TransactionModel newTransactionData) async
  {
    await transactionService.updateTransactionById(id, newTransactionData);
    notifyListeners();
  }

  Future<void> deleteTransactionById(int id) async
  {
    await transactionService.deleteTransactionById(id);
    notifyListeners();
  }
}