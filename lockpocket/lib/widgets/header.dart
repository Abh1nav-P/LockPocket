import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final month = DateFormat('MMMM yyyy').format(DateTime.now());

    return Row(
      children: [
        Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.08),
                blurRadius: 12,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: const Icon(Icons.person_rounded, color: Color(0xff6C63FF), size: 28),
        ),
        const SizedBox(width: 12),
        const Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xff6C63FF)),
        const SizedBox(width: 6),
        Text(
          month,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xff6C63FF),
          ),
        ),
        const Spacer(),

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
              const Icon(Icons.notifications_none_rounded, size: 28),
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}