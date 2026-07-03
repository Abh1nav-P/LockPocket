import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/transaction_model.dart';
import '../models/monthly_summary.dart';
import '../models/budget_model.dart';

class DatabaseHelper {
  DatabaseHelper._(); 

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(
      await getDatabasesPath(),
      "lockpocket.db",
    );

    return await openDatabase(
      path,
      version: 6,
      onCreate: _createDatabase,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        month TEXT NOT NULL,
        date TEXT NOT NULL,
        notes TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE budgets(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        reason TEXT NOT NULL,
        amount REAL NOT NULL,
        month TEXT NOT NULL,
        notes TEXT,
        is_completed INTEGER NOT NULL DEFAULT 0,
        actual_spent REAL,
        transaction_id INTEGER
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE budgets(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          reason TEXT NOT NULL,
          amount REAL NOT NULL,
          month TEXT NOT NULL,
          notes TEXT,
          is_completed INTEGER NOT NULL DEFAULT 0,
          actual_spent REAL,
          transaction_id INTEGER
        )
      ''');
    }
    if (oldVersion < 6) {
      try {
        await db.execute('ALTER TABLE budgets ADD COLUMN transaction_id INTEGER');
      } catch (_) {}
    }
  }

  // ==========================
  // INSERT NORMAL TRANSACTION
  // ==========================

  Future<int> insertTransaction(
    TransactionModel transaction,
  ) async {
    final db = await database;

    return await db.insert(
      'transactions',
      transaction.toMap(),
    );
  }

  // ==========================
  // INSERT OR UPDATE SALARY
  // ==========================

  Future<void> insertOrUpdateSalary(
    TransactionModel transaction,
  ) async {
    final db = await database;

    final existing = await db.query(
      'transactions',
      where: 'type = ? AND month = ?',
      whereArgs: [
        'salary',
        transaction.month,
      ],
    );

    if (existing.isNotEmpty) {
      final int id = existing.first['id'] as int;

      await db.update(
        'transactions',
        {
          'type': transaction.type,
          'amount': transaction.amount,
          'category': transaction.category,
          'month': transaction.month,
          'date': transaction.date,
          'notes': transaction.notes,
        },
        where: 'id = ?',
        whereArgs: [id],
      );
    } else {
      await db.insert(
        'transactions',
        transaction.toMap(),
      );
    }
  }

  // ==========================
  // GET ALL TRANSACTIONS
  // ==========================

  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;

    final result = await db.query(
      'transactions',
      orderBy: 'date DESC, id DESC',
    );

    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  // ==========================
  // DELETE TRANSACTION
  // ==========================

  Future<int> deleteTransaction(int id) async {
    final db = await database;

    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==========================
  // UPDATE TRANSACTION
  // ==========================

  Future<int> updateTransaction(
    TransactionModel transaction,
  ) async {
    final db = await database;

    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // ==========================
  // GET MONTHLY TRANSACTIONS
  // ==========================

  Future<List<TransactionModel>> getTransactionsByMonth(
      String month) async {
    final db = await database;

    final result = await db.query(
      'transactions',
      where: 'month = ?',
      whereArgs: [month],
      orderBy: 'date DESC, id DESC',
    );

    return result
        .map(
          (e) => TransactionModel.fromMap(e),
        )
        .toList();
  }

  // ==========================
  // CLEAR DATABASE (Testing)
  // ==========================

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('transactions');
  }

  // ==========================
  // BUDGET CRUD
  // ==========================

  Future<int> insertBudget(BudgetModel budget) async {
    final db = await database;
    return await db.insert(
      'budgets',
      {
        'reason': budget.reason,
        'amount': budget.amount,
        'month': budget.month,
        'notes': budget.notes,
        'is_completed': budget.isCompleted ? 1 : 0,
        'actual_spent': budget.actualSpent,
        'transaction_id': budget.transactionId,
      },
    );
  }

  Future<List<BudgetModel>> getBudgetsByMonth(String month) async {
  final db = await database;

  final result = await db.query(
    'budgets',
    where: 'month = ?',
    whereArgs: [month],
    orderBy: 'id DESC',
  );

  return result
      .map((e) => BudgetModel.fromMap(e))
      .toList();
}

  Future<int> updateBudget(BudgetModel budget) async {
    final db = await database;
    return await db.update(
      'budgets',
      {
        'reason': budget.reason,
        'amount': budget.amount,
        'month': budget.month,
        'notes': budget.notes,
        'is_completed': budget.isCompleted ? 1 : 0,
        'actual_spent': budget.actualSpent,
        'transaction_id': budget.transactionId,
      },
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

  Future<int> deleteBudget(int id) async {
    final db = await database;
    return await db.delete('budgets', where: 'id = ?', whereArgs: [id]);
  }

  Future<MonthlySummary> getMonthlySummary(String month) async {
    final db = await database;

    final result = await db.query(
      'transactions',
      where: 'month = ?',
      whereArgs: [month],
    );

    double salary = 0;
    double income = 0;
    double expense = 0;

    for (final row in result) {
      final type = row['type'] as String;
      final amount = (row['amount'] as num).toDouble();
      switch (type) {
        case 'salary': salary += amount; break;
        case 'income': income += amount; break;
        case 'expense': expense += amount; break;
      }
    }

    final budgetResult = await db.query(
      'budgets',
      where: 'month = ?',
      whereArgs: [month],
    );
    final plannedBudget = budgetResult.fold<double>(
      0, (sum, row) => sum + (row['amount'] as num).toDouble(),
    );

    return MonthlySummary(
      salary: salary,
      income: income,
      expense: expense,
      balance: (salary + income) - expense,
      plannedBudget: plannedBudget,
    );
  }

}