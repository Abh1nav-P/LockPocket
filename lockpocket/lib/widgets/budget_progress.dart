import 'package:flutter/material.dart';
import '../models/monthly_summary.dart';

class BudgetProgress extends StatelessWidget {
  final MonthlySummary? summary;

  const BudgetProgress({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final double budget = summary?.plannedBudget ?? 0;
    final double spent = summary?.expense ?? 0;
    final bool hasBudget = budget > 0;
    final double progress = hasBudget ? (spent / budget).clamp(0.0, 1.0) : 0.0;
    final double remaining = budget - spent;
    final int percent = (progress * 100).round();
    final Color barColor = percent >= 100
        ? Colors.red
        : percent >= 80
            ? Colors.orange
            : const Color(0xff6C63FF);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Budget Progress",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: hasBudget
              ? Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            color: const Color(0xffEDE9FE),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.savings_rounded,
                            color: Color(0xff6C63FF),
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Expected Expenses",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "₹${budget.toStringAsFixed(0)}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: barColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            "$percent%",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(barColor),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Spent",
                                style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 5),
                            Text(
                              "₹${spent.toStringAsFixed(0)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("Remaining",
                                style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 5),
                            Text(
                              "₹${remaining.toStringAsFixed(0)}",
                              style: TextStyle(
                                color: remaining >= 0
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xffEDE9FE),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.savings_rounded,
                        color: Color(0xff6C63FF),
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Text(
                        "No budget set for this month",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
