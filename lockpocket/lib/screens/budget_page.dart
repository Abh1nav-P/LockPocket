import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../models/budget_model.dart';
import '../services/budget_service.dart';
import 'add_budget_page.dart';

class BudgetPage extends StatefulWidget {
  final VoidCallback? onChanged;
  const BudgetPage({super.key, this.onChanged});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final BudgetService budgetService = BudgetService();

  late DateTime selectedMonth;
  List<BudgetModel> budgets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedMonth = DateTime.now();
    loadBudgets();
  }

  Future<void> loadBudgets() async {
    setState(() => isLoading = true);
    final data = await budgetService.getBudgets(
      DateFormat('MMMM yyyy').format(selectedMonth),
    );
    setState(() {
      budgets = data;
      isLoading = false;
    });
  }

  Future<void> pickMonth() async {
    final picked = await showMonthYearPicker(
      context: context,
      initialDate: selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => selectedMonth = picked);
      loadBudgets();
    }
  }

  double get totalPlanned => budgets.fold(0, (s, b) => s + b.amount);
  double get totalSpent => budgets
      .where((b) => b.isCompleted)
      .fold(0, (s, b) => s + (b.actualSpent ?? 0));
  int get completedCount => budgets.where((b) => b.isCompleted).length;

  Future<void> editBudget(BudgetModel budget) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddBudgetPage(budget: budget)),
    );
    if (result == true) loadBudgets();
  }

  Future<void> deleteBudget(BudgetModel budget) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Budget'),
        content: Text('Delete "${budget.reason}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await budgetService.deleteBudget(budget.id!);
    loadBudgets();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Budget Deleted')),
    );
  }

  Future<void> markDone(BudgetModel budget) async {
    final controller = TextEditingController(
      text: budget.actualSpent?.toStringAsFixed(0) ?? '',
    );

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          budget.isCompleted ? 'Update Actual Spent' : 'Mark as Done',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              budget.reason,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Planned: ₹${budget.amount.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Actual Amount Spent',
                prefixIcon: const Icon(Icons.currency_rupee),
                filled: true,
                fillColor: const Color(0xffF7F8FC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff6C63FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final spent = double.tryParse(
      controller.text.trim().replaceAll(',', ''),
    );
    if (spent == null || spent < 0) return;

    await budgetService.markComplete(budget, spent);
    loadBudgets();
    widget.onChanged?.call();
  }

  Color _statusColor(BudgetModel b) {
    if (!b.isCompleted) return const Color(0xff6C63FF);
    final ratio = (b.actualSpent ?? 0) / b.amount;
    if (ratio <= 1.0) return Colors.green;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Budget Planner',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff6C63FF),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddBudgetPage(initialMonth: selectedMonth),
            ),
          );
          if (result == true) loadBudgets();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Month selector
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: InkWell(
                    onTap: pickMonth,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month,
                              color: Color(0xff6C63FF)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              DateFormat('MMMM yyyy').format(selectedMonth),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down,
                              color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),

                // Summary card
                if (budgets.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff6C63FF), Color(0xff9C8FFF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _SummaryTile(
                              label: 'Planned',
                              value: '₹${totalPlanned.toStringAsFixed(0)}',
                            ),
                          ),
                          Container(
                              width: 1,
                              height: 40,
                              color: Colors.white24),
                          Expanded(
                            child: _SummaryTile(
                              label: 'Spent',
                              value: '₹${totalSpent.toStringAsFixed(0)}',
                            ),
                          ),
                          Container(
                              width: 1,
                              height: 40,
                              color: Colors.white24),
                          Expanded(
                            child: _SummaryTile(
                              label: 'Done',
                              value: '$completedCount/${budgets.length}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // List
                Expanded(
                  child: budgets.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.savings_outlined,
                                  size: 64,
                                  color: Colors.grey.shade300),
                              const SizedBox(height: 12),
                              Text(
                                'No budgets for\n${DateFormat('MMMM yyyy').format(selectedMonth)}',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade400),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                          itemCount: budgets.length,
                          itemBuilder: (context, index) {
                            final b = budgets[index];
                            final color = _statusColor(b);
                            final progress = b.isCompleted
                                ? ((b.actualSpent ?? 0) / b.amount).clamp(
                                    0.0, 1.0)
                                : 0.0;

                            return GestureDetector(
                              onLongPress: () => deleteBudget(b),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.06),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor:
                                              color.withOpacity(.12),
                                          child: Icon(
                                            b.isCompleted
                                                ? Icons.check_circle
                                                : Icons.savings_outlined,
                                            color: color,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                b.reason,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  decoration: b.isCompleted
                                                      ? TextDecoration.none
                                                      : null,
                                                ),
                                              ),
                                              if (b.notes.isNotEmpty)
                                                Text(
                                                  b.notes,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '₹${b.amount.toStringAsFixed(0)}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            if (b.isCompleted)
                                              Text(
                                                'spent ₹${b.actualSpent!.toStringAsFixed(0)}',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: color,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    if (b.isCompleted) ...[
                                      const SizedBox(height: 10),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: LinearProgressIndicator(
                                          value: progress,
                                          minHeight: 6,
                                          backgroundColor:
                                              color.withOpacity(.15),
                                          valueColor:
                                              AlwaysStoppedAnimation(color),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        progress <= 1.0
                                            ? 'Under budget 🎉'
                                            : 'Over budget by ₹${((b.actualSpent! - b.amount)).toStringAsFixed(0)}',
                                        style: TextStyle(
                                            fontSize: 11, color: color),
                                      ),
                                    ],

                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            onPressed: () => editBudget(b),
                                            icon: const Icon(Icons.edit,
                                                size: 14),
                                            label: const Text('Edit'),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor:
                                                  const Color(0xff6C63FF),
                                              side: const BorderSide(
                                                  color: Color(0xff6C63FF)),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () => markDone(b),
                                            icon: Icon(
                                              b.isCompleted
                                                  ? Icons.edit_note
                                                  : Icons.check,
                                              size: 14,
                                            ),
                                            label: Text(b.isCompleted
                                                ? 'Update'
                                                : 'Mark Done'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: color,
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
