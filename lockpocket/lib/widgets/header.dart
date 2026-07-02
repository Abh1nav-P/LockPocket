import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile
        Container(
          height: 58,
          width: 58,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.08),
                blurRadius: 12,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: const Icon(
            Icons.person_rounded,
            color: Color(0xff6C63FF),
            size: 32,
          ),
        ),

        const SizedBox(width: 15),

        // Greeting
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good Evening 👋",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              SizedBox(height: 4),

              Text(
                "Abhin",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Notification
        Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.08),
                blurRadius: 12,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.notifications_none_rounded,
                size: 28,
              ),

              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  height: 9,
                  width: 9,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}