import 'package:flutter/material.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff6C63FF),
            Color(0xff8A7DFF),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff6C63FF).withOpacity(.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [

          Row(
            children: [

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Monthly Overview",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "₹27,850",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "Remaining Balance",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 45,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.12),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [

                _item(
                  Icons.account_balance_wallet,
                  "Salary",
                  "₹45,000",
                ),

                const Divider(color: Colors.white24),

                _item(
                  Icons.payments_rounded,
                  "Other Income",
                  "₹15,000",
                ),

                const Divider(color: Colors.white24),

                _item(
                  Icons.receipt_long_rounded,
                  "Expenses",
                  "₹32,150",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(
    IconData icon,
    String title,
    String amount,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [

          Icon(
            icon,
            color: Colors.white,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),

          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}