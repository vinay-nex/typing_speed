import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:typing_speed/constants/app_colors.dart';
import 'package:typing_speed/constants/app_strings.dart';
import '../controllers/typing_controller.dart';
import '../utils.dart';
import 'typing_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TypingController());

    /// passage list
    final passages = {
      "Easy": ["Flutter is fun to learn.", "I love coding in Dart.", "Typing speed improves with practice."],
      "Medium": ["Flutter makes it easy to build beautiful apps quickly.", "State management is an important concept in Flutter.", "GetX provides a simple yet powerful way to manage app state."],
      "Hard": [
        "Asynchronous programming in Dart can be handled using Futures, Streams, and async-await syntax.",
        "Flutter’s widget tree makes UI development flexible but can be challenging for beginners to optimize.",
        "Typing accuracy is more important than speed, as it ensures error-free communication in real scenarios."
      ]
    };

    /// category colors
    final categoryColors = {
      "Easy": Colors.green.shade100,
      "Medium": Colors.orange.shade100,
      "Hard": Colors.red.shade100,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.selectLevel,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradient1, AppColors.gradient2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Categories List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: AppUtils().passages.entries.map((entry) {
                    final category = entry.key;
                    final texts = entry.value;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ExpansionTile(
                        collapsedIconColor: AppColors.primary,
                        iconColor: AppColors.primary,
                        title: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        children: texts.map((txt) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: categoryColors[category],
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                txt,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black54),
                              onTap: () {
                                controller.setText(txt);
                                Get.to(() => const TypingScreen());
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
