import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'home_page.dart';

void main() {
  runApp(const LockPocketApp());
}

class LockPocketApp extends StatelessWidget {
  const LockPocketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LockPocket',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "Poppins",
        scaffoldBackgroundColor: const Color(0xffF6F7FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff6C63FF),
        ),
      ),

      // Required for month_year_picker
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('en'),
      ],

      home: const HomePage(),
    );
  }
}