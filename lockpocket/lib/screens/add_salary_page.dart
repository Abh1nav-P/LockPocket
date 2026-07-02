import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../database/database_helper.dart';
import '../models/transaction_model.dart';

class AddSalaryPage extends StatefulWidget {
  const AddSalaryPage({super.key});

  @override
  State<AddSalaryPage> createState() => _AddSalaryPageState();
}

class _AddSalaryPageState extends State<AddSalaryPage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  DateTime selectedMonth = DateTime.now();

  Future<void> pickMonth() async {
    final DateTime? picked = await showMonthYearPicker(
      context: context,
      initialDate: selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        selectedMonth = picked;
      });
    }
  }

  Future<void> saveSalary() async {
    if (amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter salary amount"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final transaction = TransactionModel(
      type: "salary",
      amount: double.parse(amountController.text),
      category: "Salary",
      month: DateFormat("MMMM yyyy").format(selectedMonth),
      date: DateFormat("yyyy-MM-dd").format(DateTime.now()),
      notes: notesController.text.trim(),
    );

    await DatabaseHelper.instance.insertTransaction(transaction);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Salary Saved Successfully"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
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
        title: const Text(
          "Add Salary",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const Text(
            "Salary Amount",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: "Enter salary amount",
              prefixIcon: const Icon(
                Icons.currency_rupee,
                color: Color(0xff6C63FF),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Salary Month",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 10),

          InkWell(
            onTap: pickMonth,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [

                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xff6C63FF).withOpacity(.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.calendar_month,
                      color: Color(0xff6C63FF),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Text(
                      DateFormat("MMMM yyyy").format(selectedMonth),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Notes (Optional)",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 10),

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
            height: 58,
            child: ElevatedButton(
              onPressed: saveSalary,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff6C63FF),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                "Save Salary",
                style: TextStyle(
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