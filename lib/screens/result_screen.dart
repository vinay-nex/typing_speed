import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:typing_speed/constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../controllers/typing_controller.dart';
import 'history_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TypingController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.result,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradient1, AppColors.gradient2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Obx(() {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// WPM Result
                  Text(
                    "${AppStrings.wpm}: ${controller.wpm.value}",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),

                  /// Accuracy Result
                  Text(
                    "${AppStrings.accuracy}: ${controller.accuracy.value.toStringAsFixed(2)}%",
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// Try Again Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade300,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () => Get.back(),
                    child: const Text("🔄 ${AppStrings.tryAgain}", style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 15),

                  /// View History Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () => Get.to(() => const HistoryScreen()),
                    child: const Text("📜 ${AppStrings.viewHistory}", style: TextStyle(fontSize: 18)),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
