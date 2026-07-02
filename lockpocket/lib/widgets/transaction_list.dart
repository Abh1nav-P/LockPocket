import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            const Text(
              "Recent Transactions",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            TextButton(
              onPressed: () {},
              child: const Text(
                "View All",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff6C63FF),
                ),
              ),
            )

          ],
        ),

        const SizedBox(height: 15),

        const TransactionCard(
          icon: Icons.account_balance_wallet_rounded,
          iconColor: Color(0xff16A34A),
          bgColor: Color(0xffDCFCE7),
          title: "Monthly Salary",
          category: "Salary",
          amount: "+ ₹45,000",
          amountColor: Color(0xff16A34A),
          date: "01 Jul 2026",
        ),

        SizedBox(height: 14),

        const TransactionCard(
          icon: Icons.shopping_cart_rounded,
          iconColor: Color(0xffDC2626),
          bgColor: Color(0xffFEE2E2),
          title: "Groceries",
          category: "Shopping",
          amount: "- ₹1,250",
          amountColor: Color(0xffDC2626),
          date: "03 Jul 2026",
        ),

        SizedBox(height: 14),

        const TransactionCard(
          icon: Icons.local_gas_station_rounded,
          iconColor: Color(0xffF59E0B),
          bgColor: Color(0xffFEF3C7),
          title: "Fuel",
          category: "Transportation",
          amount: "- ₹2,000",
          amountColor: Color(0xffF59E0B),
          date: "05 Jul 2026",
        ),

        SizedBox(height: 14),

        const TransactionCard(
          icon: Icons.work_rounded,
          iconColor: Color(0xff2563EB),
          bgColor: Color(0xffDBEAFE),
          title: "Freelance",
          category: "Other Income",
          amount: "+ ₹8,000",
          amountColor: Color(0xff2563EB),
          date: "06 Jul 2026",
        ),
      ],
    );
  }
}

class TransactionCard extends StatelessWidget {

  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String category;
  final String amount;
  final Color amountColor;
  final String date;

  const TransactionCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.category,
    required this.amount,
    required this.amountColor,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [

          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              color: iconColor,
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
                    fontSize: 17,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  category,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Text(
                amount,
                style: TextStyle(
                  color: amountColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                date,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),

            ],
          )

        ],
      ),
    );
  }
}