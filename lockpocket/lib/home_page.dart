import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/monthly_summary.dart';
import 'services/transaction_service.dart';

import 'widgets/header.dart';
import 'widgets/month_selector.dart';
import 'widgets/overview_card.dart';
import 'widgets/quick_actions.dart';
import 'widgets/budget_progress.dart';
import 'widgets/transaction_list.dart';
import 'widgets/bottom_navigation.dart';
import 'widgets/add_options_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TransactionService transactionService = TransactionService();

  MonthlySummary? summary;

  @override
  void initState() {
    super.initState();
    loadSummary();
  }

  Future<void> loadSummary() async {
    final currentMonth =
        DateFormat("MMMM yyyy").format(DateTime.now());

    final data =
        await transactionService.getMonthlySummary(currentMonth);

    setState(() {
      summary = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      bottomNavigationBar: const BottomNavigation(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff6C63FF),
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            builder: (_) => AddOptionsSheet(onSaved: loadSummary),
          );

          // Refresh dashboard after closing bottom sheet
          loadSummary();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            const Header(),

            const SizedBox(height: 20),

            const MonthSelector(),

            const SizedBox(height: 20),

            OverviewCard(
              summary: summary,
            ),

            const SizedBox(height: 25),

            const QuickActions(),

            const SizedBox(height: 25),

            BudgetProgress(
              summary: summary,
            ),

            const SizedBox(height: 25),

            const TransactionList(),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}