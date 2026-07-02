import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../models/monthly_summary.dart';

class TransactionService {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Save or update salary
  Future<void> saveSalary(TransactionModel transaction) async {
    await _databaseHelper.insertOrUpdateSalary(transaction);
  }

  // Save income
  Future<void> saveIncome(TransactionModel transaction) async {
    await _databaseHelper.insertTransaction(transaction);
  }

  // Save expense
  Future<void> saveExpense(TransactionModel transaction) async {
    await _databaseHelper.insertTransaction(transaction);
  }

  // Get all transactions
  Future<List<TransactionModel>> getTransactions() async {
    return await _databaseHelper.getTransactions();
  }

  // Get monthly transactions
  Future<List<TransactionModel>> getMonthlyTransactions(String month) async {
    return await _databaseHelper.getTransactionsByMonth(month);
  }

  // Delete transaction
  Future<void> deleteTransaction(int id) async {
    await _databaseHelper.deleteTransaction(id);
  }

  // Update transaction
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _databaseHelper.updateTransaction(transaction);
  }

  Future<MonthlySummary> getMonthlySummary(String month) async {
  return await _databaseHelper.getMonthlySummary(month);
}
}