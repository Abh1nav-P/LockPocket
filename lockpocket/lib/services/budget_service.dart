import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/budget_model.dart';
import '../models/transaction_model.dart';

class BudgetService {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<void> saveBudget(BudgetModel budget) async {
    await _db.insertBudget(budget);
  }

  Future<void> updateBudget(BudgetModel budget) async {
    await _db.updateBudget(budget);
  }

  Future<void> deleteBudget(int id) async {
    await _db.deleteBudget(id);
  }

  Future<List<BudgetModel>> getBudgets(String month) async {
    return await _db.getBudgetsByMonth(month);
  }

  Future<void> markComplete(BudgetModel budget, double actualSpent) async {
    final now = DateTime.now();
    final currentMonth = DateFormat('MMMM yyyy').format(now);
    final currentDate = DateFormat('yyyy-MM-dd').format(now);
    final notes = budget.notes.isNotEmpty ? budget.notes : budget.reason;

    int txnId;

    if (budget.transactionId != null) {
      // Already completed before — update the existing expense
      txnId = budget.transactionId!;
      await _db.updateTransaction(
        TransactionModel(
          id: txnId,
          type: 'expense',
          amount: actualSpent,
          category: budget.reason,
          month: currentMonth,
          date: currentDate,
          notes: notes,
        ),
      );
    } else {
      // First time completing — insert new expense
      txnId = await _db.insertTransaction(
        TransactionModel(
          type: 'expense',
          amount: actualSpent,
          category: budget.reason,
          month: currentMonth,
          date: currentDate,
          notes: notes,
        ),
      );
    }

    await _db.updateBudget(
      BudgetModel(
        id: budget.id,
        reason: budget.reason,
        amount: budget.amount,
        month: budget.month,
        notes: budget.notes,
        isCompleted: true,
        actualSpent: actualSpent,
        transactionId: txnId,
      ),
    );
  }
}