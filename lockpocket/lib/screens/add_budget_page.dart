import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../models/budget_model.dart';
import '../services/budget_service.dart';

class AddBudgetPage extends StatefulWidget {
  final BudgetModel? budget;
  final DateTime? initialMonth;

  const AddBudgetPage({
    super.key,
    this.budget,
    this.initialMonth,
  });

  @override
  State<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  final BudgetService budgetService = BudgetService();

  final reasonController = TextEditingController();
  final amountController = TextEditingController();
  final notesController = TextEditingController();

  DateTime selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.initialMonth ?? DateTime.now();

    if (widget.budget != null) {
      reasonController.text = widget.budget!.reason;
      amountController.text =
          widget.budget!.amount.toStringAsFixed(0);
      notesController.text = widget.budget!.notes;
      selectedMonth =
          DateFormat("MMMM yyyy").parse(widget.budget!.month);
    }
  }

  Future<void> pickMonth() async {
    final now = DateTime.now();
    final picked = await showMonthYearPicker(
      context: context,
      initialDate: selectedMonth,
      firstDate: DateTime(now.year, now.month),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        selectedMonth = picked;
      });
    }
  }

  Future<void> saveBudget() async {
    final amount = double.tryParse(
      amountController.text.trim().replaceAll(',', ''),
    );

    if (reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a reason"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid amount"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final budget = BudgetModel(
      id: widget.budget?.id,
      reason: reasonController.text.trim(),
      amount: amount,
      month: DateFormat("MMMM yyyy").format(selectedMonth),
      notes: notesController.text.trim(),
    );

    if (widget.budget == null) {
      await budgetService.saveBudget(budget);
    } else {
      await budgetService.updateBudget(budget);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.budget == null
              ? "Budget Added Successfully"
              : "Budget Updated Successfully",
        ),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    reasonController.dispose();
    amountController.dispose();
    notesController.dispose();
    super.dispose();
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
        title: Text(
          widget.budget == null
              ? "Add Budget"
              : "Edit Budget",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const Text(
            "Reason",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: reasonController,
            decoration: InputDecoration(
              hintText: "Food, Rent, Trip...",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Planned Amount",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.currency_rupee),
              hintText: "Enter amount",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Month",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          InkWell(
            onTap: pickMonth,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [

                  const Icon(Icons.calendar_month),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      DateFormat("MMMM yyyy").format(selectedMonth),
                    ),
                  ),

                  const Icon(Icons.keyboard_arrow_down),

                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Notes",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: notesController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Optional",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 40),

          SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed: saveBudget,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff6C63FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                widget.budget == null
                    ? "Save Budget"
                    : "Update Budget",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}