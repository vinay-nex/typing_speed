import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:typing_speed/constants/app_colors.dart';
import 'package:typing_speed/constants/app_strings.dart';
import '../routes/app_routes.dart';
import '../widgets/loader.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed(AppRoutes.dashboard);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.keyboard_alt, size: 80, color: AppColors.textLight),
            SizedBox(height: 16),
            Text(
              AppStrings.typingSpeedApp,
              style: TextStyle(
                fontSize: 22,
                color: AppColors.textLight,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            CustomLoader(),
          ],
        ),
      ),
    );
  }
}
