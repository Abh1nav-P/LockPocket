import 'package:flutter/material.dart';
import '../models/monthly_summary.dart';

class BudgetAlertBanner extends StatelessWidget {
  final MonthlySummary? summary;

  const BudgetAlertBanner({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final double planned = summary?.plannedBudget ?? 0;
    if (planned <= 0) return const SizedBox.shrink();

    final double spent = summary?.expense ?? 0;
    final double progress = (spent / planned).clamp(0.0, 1.0);
    final double remaining = planned - spent;
    final int percent = (progress * 100).round();

    final bool isOver = spent > planned;
    final bool isNear = percent >= 80 && !isOver;

    final Color bg = isOver
        ? const Color(0xffFFF0F0)
        : isNear
            ? const Color(0xffFFFBF0)
            : const Color(0xffF0FFF8);

    final Color borderColor = isOver
        ? const Color(0xffFF4D4D)
        : isNear
            ? const Color(0xffFFB020)
            : const Color(0xff00C97A);

    final Color textColor = isOver
        ? const Color(0xffCC0000)
        : isNear
            ? const Color(0xffB36A00)
            : const Color(0xff007A4D);

    final IconData icon = isOver
        ? Icons.warning_rounded
        : isNear
            ? Icons.error_outline_rounded
            : Icons.savings_rounded;

    final String title = isOver
        ? '⚠️ Over Budget!'
        : isNear
            ? '🔔 Budget Alert'
            : '💰 This Month\'s Budget';

    final String message = isOver
        ? 'You\'ve exceeded by ₹${(spent - planned).toStringAsFixed(0)}. Review your expenses.'
        : isNear
            ? 'Only ₹${remaining.toStringAsFixed(0)} left of your ₹${planned.toStringAsFixed(0)} budget!'
            : '₹${remaining.toStringAsFixed(0)} remaining from ₹${planned.toStringAsFixed(0)}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: borderColor.withOpacity(.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: borderColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: TextStyle(
                        color: textColor.withOpacity(.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: borderColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$percent%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: borderColor.withOpacity(.15),
              valueColor: AlwaysStoppedAnimation(borderColor),
            ),
          ),
        ],
      ),
    );
  }
}
