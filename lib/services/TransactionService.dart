import 'dart:async';
import 'dart:math';

import 'package:expenses_tracker/interfaces/TransactionRepository.dart';
import 'package:expenses_tracker/models/BudgetEntry.dart';
import 'package:expenses_tracker/repositories/LocalRepository.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class TransactionService
{
  late ITransactionRepository _repo;
  ITransactionRepository get repo => _repo;

  TransactionService()
  {
    _repo = LocalTransactionRepository();
  }

  Future<void> init() async
  {
    await _repo.init();
  }

  Future<Map<DateTime,List<TransactionModel>>> sortTransactionsByDay(List<TransactionModel> transactions) async
  {
    Map<DateTime, List<TransactionModel>> sortedTransactions = {};

    for (TransactionModel trans in transactions)
    {
      sortedTransactions.putIfAbsent(
        trans.transactionDateTime.dateOnly, 
        () => []
      ).add(trans);
    }

    return sortedTransactions;
  }

  Future<Map<DateTime, List<TransactionModel>>?> getGroupedTransactionsPerDayInMonth(DateTime yearAndMonth) async
  {
    List<TransactionModel>? transactions = await _repo.getTransactionsByYearAndMonth(yearAndMonth);
    if (transactions == null)
    {
      return null;
    }

    Map<DateTime, List<TransactionModel>> sortedTransactions = {};

    for (TransactionModel trans in transactions)
    {
      sortedTransactions.putIfAbsent(
        trans.transactionDateTime.dateOnly, 
        () => []
      ).add(trans);
    }

    return sortedTransactions;
  }

  Future<double> getNetExpenses(List<TransactionModel> list) async
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

  Future<double> getTotalExpenses(List<TransactionModel> transactions) async
  {
    double total = 0;
    for (TransactionModel x in transactions)
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

  Future<double> getTotalIncome(List<TransactionModel> transactions) async
  {
    double total = 0;
    for (TransactionModel x in transactions)
    {
      if (x.transType == TransactionType.income)
      {
        total += x.transactionAmount;
      } 
    }
    return total;
  }

  Future<void> addTransaction(TransactionModel newTransaction) async 
  {
    await repo.addTransaction(newTransaction);
  }

  Future<TransactionModel?> getTransactionById(int id) async 
  {
    return await repo.getTransactionById(id);
  }

  Future<List<TransactionModel>?> getTransactionsByYearAndMonth(DateTime dateYearMonthOnly) async
  {
    return await repo.getTransactionsByYearAndMonth(dateYearMonthOnly);
  }

  Future<void> updateTransactionById(int id, TransactionModel newTransactionData) async 
  {
    await repo.updateTransactionById(id, newTransactionData);
  }

  Future<void> deleteTransactionById(int id) async
  {
    await repo.deleteTransactionById(id);
  }
}