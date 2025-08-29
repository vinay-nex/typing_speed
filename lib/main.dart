import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:typing_speed/constants/app_colors.dart';
import 'package:typing_speed/screens/welcome_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const TypingApp());
}

class TypingApp extends StatelessWidget {
  const TypingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: AppColors.primary,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryDark,
          iconTheme: IconThemeData(
            color: AppColors.textOnPrimary,
          ),
          centerTitle: true,
          elevation: 4,
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}
