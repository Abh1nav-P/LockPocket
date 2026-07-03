class MonthlySummary {
  final double salary;
  final double income;
  final double expense;
  final double balance;
  final double plannedBudget;

  MonthlySummary({
    required this.salary,
    required this.income,
    required this.expense,
    required this.balance,
    this.plannedBudget = 0,
  });
}