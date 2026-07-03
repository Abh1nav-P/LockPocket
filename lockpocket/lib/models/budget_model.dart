class BudgetModel {
  int? id;
  String reason;
  double amount;
  String month;
  String notes;
  bool isCompleted;
  double? actualSpent;
  int? transactionId;

  BudgetModel({
    this.id,
    required this.reason,
    required this.amount,
    required this.month,
    required this.notes,
    this.isCompleted = false,
    this.actualSpent,
    this.transactionId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reason': reason,
      'amount': amount,
      'month': month,
      'notes': notes,
      'is_completed': isCompleted ? 1 : 0,
      'actual_spent': actualSpent,
      'transaction_id': transactionId,
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'],
      reason: map['reason'],
      amount: (map['amount'] as num).toDouble(),
      month: map['month'],
      notes: map['notes'] ?? '',
      isCompleted: (map['is_completed'] ?? 0) == 1,
      actualSpent: map['actual_spent'] != null
          ? (map['actual_spent'] as num).toDouble()
          : null,
      transactionId: map['transaction_id'],
    );
  }
}