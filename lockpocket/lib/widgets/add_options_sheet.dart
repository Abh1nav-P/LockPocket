import 'package:flutter/material.dart';

import '../screens/add_salary_page.dart';

class AddOptionsSheet extends StatelessWidget {
  const AddOptionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Container(
            width: 45,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "What would you like to add?",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          OptionTile(
            title: "Salary",
            subtitle: "Monthly salary",
            icon: Icons.account_balance_wallet,
            color: Colors.green,
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddSalaryPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 15),

          OptionTile(
            title: "Income",
            subtitle: "Other income",
            icon: Icons.payments,
            color: Colors.blue,
            onTap: () {},
          ),

          const SizedBox(height: 15),

          OptionTile(
            title: "Expense",
            subtitle: "Track spending",
            icon: Icons.receipt_long,
            color: Colors.red,
            onTap: () {},
          ),

          const SizedBox(height: 17),

        ],
      ),
    );
  }
}

class OptionTile extends StatelessWidget {

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [

            CircleAvatar(
              radius: 25,
              backgroundColor: color.withOpacity(.15),
              child: Icon(
                icon,
                color: color,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios,size:16),

          ],
        ),
      ),
    );
  }
}