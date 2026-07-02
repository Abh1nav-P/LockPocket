import 'package:flutter/material.dart';

class BudgetProgress extends StatelessWidget {
  const BudgetProgress({super.key});

  @override
  Widget build(BuildContext context) {
    const double progress = 0.64;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Budget Progress",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 18),

        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [

              Row(
                children: [

                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xffEDE9FE),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.savings_rounded,
                      color: Color(0xff6C63FF),
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 15),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Monthly Budget",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "₹50,000",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),

                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff6C63FF),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      "64%",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 25),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 12,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation(
                    Color(0xff6C63FF),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Spent",
                        style: TextStyle(color: Colors.grey),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "₹32,150",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                      Text(
                        "Remaining",
                        style: TextStyle(color: Colors.grey),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "₹17,850",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),

                ],
              )

            ],
          ),
        ),
      ],
    );
  }
}