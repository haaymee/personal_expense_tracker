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

class TransactionRepositoryNotifier extends ChangeNotifier 
{
  final ITransactionRepository repo;

  TransactionRepositoryNotifier(this.repo);
  
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
}