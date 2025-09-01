import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:typing_speed/constants/app_colors.dart';
import 'package:typing_speed/constants/app_strings.dart';
import '../controllers/typing_controller.dart';
import '../db/db_helper.dart';
import '../widgets/result_popup.dart';

class TypingScreen extends StatelessWidget {
  TypingScreen({super.key});

  final controller = Get.put(TypingController());
  final textController = TextEditingController();
  void showLatestResultPopup() async {
    final result = await DBHelper.getLatestResult();
    if (result != null) {
      Get.dialog(ResultPopup(
        result: result,
      ));
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Curved AppBar
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Back button
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.cancel_rounded, color: AppColors.textLight, size: 26),
                    ),

                    /// Title
                    Text(
                      AppStrings.typingTestStandard,
                      style: const TextStyle(
                        color: AppColors.textLight,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    /// Reset button
                    GestureDetector(
                      onTap: () {
                        controller.resetTest();
                        textController.clear();
                      },
                      child: const Icon(Icons.refresh_outlined, color: AppColors.textLight, size: 26),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Main content
          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                /// Passage Container
                Obx(() {
                  List<String> typedWords = controller.typedText.value.trim().split(" ");
                  if (typedWords.length == 1 && typedWords.first.isEmpty) typedWords = [];

                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.textLight,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: AppColors.blackShadow, blurRadius: 6, offset: Offset(0, 3)),
                      ],
                    ),
                    child: Wrap(
                      children: List.generate(controller.words.length, (index) {
                        String word = controller.words[index];
                        Color color = AppColors.textDark;
                        Color bgColor = AppColors.transparent;

                        if (index < typedWords.length - 1) {
                          /// Completed words
                          color = (typedWords[index] == word) ? AppColors.success : AppColors.error;
                        } else if (index == typedWords.length - 1 && controller.typedText.value.isNotEmpty) {
                          /// Current word
                          bgColor = Colors.yellow.withOpacity(0.3);
                        }

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4)),
                          child: Text(word, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
                        );
                      }),
                    ),
                  );
                }),

                const SizedBox(height: 20),

                /// TextField + Timer
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => TextField(
                            controller: textController,
                            onChanged: controller.remainingTime.value > 0 ? controller.onTextChanged : null,
                            enabled: controller.remainingTime.value > 0,
                            decoration: InputDecoration(
                              hintText: controller.remainingTime.value > 0 ? "Start typing here..." : "Time is up!",
                              filled: true,
                              fillColor: AppColors.textLight,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          )),
                    ),
                    const SizedBox(width: 10),
                    Obx(
                      () => Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: controller.remainingTime.value <= 10 ? Colors.red : AppColors.primaryBlue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${controller.remainingTime.value ~/ 60}:${(controller.remainingTime.value % 60).toString().padLeft(2, '0')}",
                          style: const TextStyle(fontSize: 16, color: AppColors.textLight, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Text("Note: Timer will not start until you start typing."),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
