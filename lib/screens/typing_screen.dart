import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:typing_speed/constants/app_colors.dart';
import 'package:typing_speed/constants/app_strings.dart';
import '../controllers/typing_controller.dart';
import 'result_screen.dart';

class TypingScreen extends StatelessWidget {
  const TypingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TypingController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.typingSpeedText,
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              final passage = controller.textToType.value;
              final typed = controller.userInput.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Timer
                  Obx(
                    () {
                      final seconds = controller.seconds.value;
                      return Text(
                        "${AppStrings.timeLeft} ${seconds}s",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: seconds < 10 ? AppColors.error : AppColors.textOnPrimary,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  /// Highlighted passage
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.accentLight,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: List.generate(passage.length, (i) {
                          Color charColor = Colors.black;

                          if (i < typed.length) {
                            if (typed[i] == passage[i]) {
                              charColor = Colors.blue;
                            } else {
                              charColor = Colors.red;
                            }
                          }

                          return TextSpan(
                            text: passage[i],
                            style: TextStyle(
                              color: charColor,
                              fontSize: 18,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Input Box
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: controller.textController,
                      focusNode: controller.focusNode,
                      enabled: controller.isRunning.value,
                      onChanged: (val) => controller.userInput.value = val,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        border: InputBorder.none,
                        hintText: AppStrings.startTypingHere,
                      ),
                      maxLines: 5,
                      autocorrect: false,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.none,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Start / Finish Button
                  Center(
                    child: controller.isRunning.value
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              controller.finishTest();
                              Get.to(() => const ResultScreen());
                            },
                            child: Text(
                              AppStrings.endTest,
                              style: TextStyle(fontSize: 16, color: AppColors.textOnPrimary),
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              controller.startTest();

                              controller.focusNode.requestFocus();
                            },
                            child: Text(
                              AppStrings.startTest,
                              style: TextStyle(fontSize: 16, color: AppColors.textOnPrimary),
                            ),
                          ),
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
