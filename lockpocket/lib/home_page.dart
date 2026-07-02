import 'package:flutter/material.dart';

import 'widgets/header.dart';
import 'widgets/month_selector.dart';
import 'widgets/overview_card.dart';
import 'widgets/quick_actions.dart';
import 'widgets/budget_progress.dart';
import 'widgets/transaction_list.dart';
import 'widgets/bottom_navigation.dart';
import 'widgets/add_options_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      bottomNavigationBar: const BottomNavigation(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff6C63FF),
        onPressed: () {
            showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
                ),
            ),
            builder: (context) {
                return const AddOptionsSheet();
            },
            );
        },
        child: const Icon(
            Icons.add,
            color: Colors.white,
        ),
        ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const [

            Header(),

            SizedBox(height:20),

            MonthSelector(),

            SizedBox(height:20),

            OverviewCard(),

            SizedBox(height:25),

            QuickActions(),

            SizedBox(height:25),

            BudgetProgress(),

            SizedBox(height:25),

            TransactionList(),

            SizedBox(height:100),

          ],
        ),
      ),
    );
  }
}