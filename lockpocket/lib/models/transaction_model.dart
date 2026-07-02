class TransactionModel {
  int? id;
  String type;
  double amount;
  String category;
  String month;
  String date;
  String notes;

  TransactionModel({
    this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.month,
    required this.date,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'category': category,
      'month': month,
      'date': date,
      'notes': notes,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      type: map['type'],
      amount: map['amount'],
      category: map['category'],
      month: map['month'],
      date: map['date'],
      notes: map['notes'],
    );
  }
}