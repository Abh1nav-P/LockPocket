import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/transaction_model.dart';

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
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(
    Database db,
    int version,
  ) async {
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
  }
  Future<int> insertTransaction(TransactionModel transaction) async {
  final db = await database;

  return await db.insert(
    'transactions',
    transaction.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
}