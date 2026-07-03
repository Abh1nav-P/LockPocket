import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/monthly_summary.dart';
import 'services/transaction_service.dart';

import 'widgets/header.dart';
import 'widgets/overview_card.dart';
import 'widgets/quick_actions.dart';
import 'widgets/budget_alert_banner.dart';
import 'widgets/transaction_list.dart';
import 'widgets/bottom_navigation.dart';
import 'widgets/add_options_sheet.dart';
import 'screens/history_page.dart';
import 'screens/budget_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TransactionService transactionService = TransactionService();

  MonthlySummary? summary;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    loadSummary();
  }

  Future<void> loadSummary() async {
    final currentMonth = DateFormat("MMMM yyyy").format(DateTime.now());
    final data = await transactionService.getMonthlySummary(currentMonth);
    setState(() {
      summary = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      bottomNavigationBar: BottomNavigation(
        currentIndex: currentIndex,
        onTabChanged: (index) => setState(() => currentIndex = index),
      ),

      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
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
                loadSummary();
              },
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,

      body: IndexedStack(
          index: currentIndex,
          children: [
            SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Header(),
                  const SizedBox(height: 12),
                  BudgetAlertBanner(summary: summary),
                  const SizedBox(height: 12),
                  OverviewCard(summary: summary),
                  const SizedBox(height: 25),
                  QuickActions(
                    onSaved: loadSummary,
                    onBudget: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => BudgetPage(onChanged: loadSummary)),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const TransactionList(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            HistoryPage(onChanged: loadSummary, isActive: currentIndex == 1),
            const Scaffold(body: Center(child: Text("Reports"))),
            const Scaffold(body: Center(child: Text("Settings"))),
          ],
        ),
    );
  }
}