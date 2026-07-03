import 'package:flutter/material.dart';

import '../screens/add_salary_page.dart';
import '../screens/add_income_page.dart';
import '../screens/add_expense_page.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onSaved;
  final VoidCallback onBudget;

  const QuickActions({super.key, required this.onSaved, required this.onBudget});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 18),

        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.18,
          children: [

            ActionCard(
              title: "Add Salary",
              subtitle: "Monthly salary",
              color: const Color(0xffDCFCE7),
              iconColor: const Color(0xff16A34A),
              icon: Icons.account_balance_wallet_rounded,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddSalaryPage())).then((_) => onSaved()),
            ),

            ActionCard(
              title: "Add Income",
              subtitle: "Extra income",
              color: const Color(0xffDBEAFE),
              iconColor: const Color(0xff2563EB),
              icon: Icons.payments_rounded,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddIncomePage())).then((_) => onSaved()),
            ),

            ActionCard(
              title: "Add Expense",
              subtitle: "Track spending",
              color: const Color(0xffFEE2E2),
              iconColor: const Color(0xffDC2626),
              icon: Icons.receipt_long_rounded,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddExpensePage())).then((_) => onSaved()),
            ),

            ActionCard(
              title: "Set Budget",
              subtitle: "Monthly budget",
              color: const Color(0xffEDE9FE),
              iconColor: const Color(0xff6C63FF),
              icon: Icons.savings_rounded,
              onTap: onBudget,
            ),
          ],
        ),
      ],
    );
  }
}

class ActionCard extends StatelessWidget {

  final String title;
  final String subtitle;
  final Color color;
  final Color iconColor;
  final IconData icon;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.iconColor,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.08),
              blurRadius: 12,
              offset: const Offset(0,6),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            CircleAvatar(
              radius: 20,
              backgroundColor: color,
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),

            const Spacer(),

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height:5),

            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),

          ],
        ),
      ),
    );
  }
}