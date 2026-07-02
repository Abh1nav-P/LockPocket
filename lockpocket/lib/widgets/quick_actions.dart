import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

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
          children: const [

            ActionCard(
              title: "Add Salary",
              subtitle: "Monthly salary",
              color: Color(0xffDCFCE7),
              iconColor: Color(0xff16A34A),
              icon: Icons.account_balance_wallet_rounded,
            ),

            ActionCard(
              title: "Add Income",
              subtitle: "Extra income",
              color: Color(0xffDBEAFE),
              iconColor: Color(0xff2563EB),
              icon: Icons.payments_rounded,
            ),

            ActionCard(
              title: "Add Expense",
              subtitle: "Track spending",
              color: Color(0xffFEE2E2),
              iconColor: Color(0xffDC2626),
              icon: Icons.receipt_long_rounded,
            ),

            ActionCard(
              title: "Set Budget",
              subtitle: "Monthly budget",
              color: Color(0xffEDE9FE),
              iconColor: Color(0xff6C63FF),
              icon: Icons.savings_rounded,
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

  const ActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: () {},
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