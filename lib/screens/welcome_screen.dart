import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:typing_speed/screens/home_screen.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.hiThere,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 📦 Card with text
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🏆 Title
                  Text(
                    "What’s your WPM? Take our one-minute typing test to find out your typing speed!",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// 📜 Description
                  const Text(
                    "One minute is all it takes to check your words per minute (WPM) score. "
                    "This one-minute typing test is perfect for kids or adults who want to check their typing speed quickly.\n\n"
                    "On the next screen, the timer won’t start until you start typing! Continue typing through the content until the timer ends.\n\n"
                    "Take this 1-minute timed typing test as many times as you like, and be sure to show off your best results with our shareable certificate of completion.",
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🎯 Continue Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                      onPressed: () {
                        Get.to(() => HomeScreen());
                      },
                      child: const Text(
                        "Continue",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
