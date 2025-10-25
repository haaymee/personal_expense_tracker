import 'package:expenses_tracker/interfaces/TransactionRepository.dart';
import 'package:expenses_tracker/models/BudgetEntry.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalTransactionRepository implements ITransactionRepository
{
  static const _dbName = "transactions.db";
  static const _tableName = "transactions";
  Database? _db;

  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, _dbName),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(''' 
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            category TEXT,
            account TEXT,
            fromAccount TEXT,
            toAccount TEXT,
            transactionAmount REAL,
            transferFees REAL,
            transactionDateTime TEXT,
            transactionType TEXT
          )
        ''');
      },
    );
  }

  @override
  Future<void> addTransaction(TransactionModel newTransaction) async {
    await _db?.insert(_tableName, newTransaction.toMap());
  }

  @override
  Future<void> deleteTransactionById(int id) async {
    await _db?.delete(_tableName, where: "id = ?", whereArgs: [id]);
  }

  @override
  Future<TransactionModel?> getTransactionById(int id) async {
    final result = await _db?.query(
      _tableName,
      where: "id = ?",
      whereArgs: [id]
    );

    if (result!.isEmpty) return null;
    return TransactionModel.fromMap(result[0]);
  }

  @override
  Future<List<TransactionModel>?> getTransactionsByYearAndMonth(DateTime dateYearMonthOnly) async{
    final start = DateTime(dateYearMonthOnly.year, dateYearMonthOnly.month);
    final end = DateTime(dateYearMonthOnly.year, dateYearMonthOnly.month + 1, 0);

    final result = await _db!.query(
      _tableName,
      where: 'transactionDateTime BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: "transactionDateTime DESC",
    );

    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  @override
  Future<void> updateTransactionById(int id, TransactionModel newTransactionData) async {
    await _db!.update(
      _tableName,
      newTransactionData.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}