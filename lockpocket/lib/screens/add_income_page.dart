import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

void _showRecentSheet(BuildContext context, List<TransactionModel> items, Color color) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Recent Entries', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('No entries yet', style: TextStyle(color: Colors.grey))),
            )
          else
            ...items.map((t) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: color.withOpacity(.12),
                    child: Icon(Icons.payments, color: color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.category, style: const TextStyle(fontWeight: FontWeight.w600)),
                        Text(DateFormat('dd MMM yyyy').format(DateTime.parse(t.date)),
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Text('₹${t.amount.toStringAsFixed(0)}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                ],
              ),
            )),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

class AddIncomePage extends StatefulWidget {
  final TransactionModel? transaction;

  const AddIncomePage({
    super.key,
    this.transaction,
  });

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final TransactionService transactionService = TransactionService();

  final amountController = TextEditingController();
  final notesController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  final List<String> incomeSources = [
    "Freelance",
    "Bonus",
    "Gift",
    "Interest",
    "Refund",
    "Business",
    "Other"
  ];

  String selectedSource = "Freelance";
  List<TransactionModel> recentItems = [];

  @override
  void initState() {
    super.initState();
    _loadRecent();

    if (widget.transaction != null) {
      amountController.text =
          widget.transaction!.amount.toString();

      notesController.text =
          widget.transaction!.notes;

      selectedSource =
          widget.transaction!.category;

      selectedDate =
          DateTime.parse(widget.transaction!.date);
    }
  }

  Future<void> _loadRecent() async {
    final all = await transactionService.getTransactions();
    setState(() {
      recentItems = all.where((t) => t.type == 'income').take(5).toList();
    });
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> saveIncome() async {
    final amount = double.tryParse(
      amountController.text.trim().replaceAll(',', ''),
    );

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter income amount"),
        ),
      );
      return;
    }

    final transaction = TransactionModel(
      id: widget.transaction?.id,
      type: "income",
      amount: amount,
      category: selectedSource,
      month: DateFormat("MMMM yyyy").format(selectedDate),
      date: DateFormat("yyyy-MM-dd").format(selectedDate),
      notes: notesController.text.trim(),
    );

    if (widget.transaction == null) {
      await transactionService.saveIncome(transaction);
    } else {
      await transactionService.updateTransaction(transaction);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.transaction == null
              ? "Income Added Successfully"
              : "Income Updated Successfully",
        ),
        backgroundColor: Colors.green,
      ),
    );

    if (widget.transaction != null) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        amountController.clear();
        notesController.clear();
        selectedSource = "Freelance";
        selectedDate = DateTime.now();
      });
      _loadRecent();
    }
  }

  @override
  void dispose() {
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
          widget.transaction == null ? "Add Income" : "Edit Income",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Amount",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => _showRecentSheet(context, recentItems, Colors.blue),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.history, size: 14, color: Colors.blue),
                      SizedBox(width: 4),
                      Text('Recent', style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: "Enter Amount",
              prefixIcon: const Icon(Icons.currency_rupee),
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
            "Income Source",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedSource,
                isExpanded: true,
                items: incomeSources.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSource = value!;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Date",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          InkWell(
            onTap: pickDate,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [

                  const Icon(Icons.calendar_today),

                  const SizedBox(width: 12),

                  Text(
                    DateFormat("dd MMMM yyyy").format(selectedDate),
                  ),

                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Notes (Optional)",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: notesController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Write something...",
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
              onPressed: saveIncome,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff6C63FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                widget.transaction == null
                    ? "Save Income"
                    : "Update Income",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}