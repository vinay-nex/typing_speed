import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

import '../db/db_helper.dart';
import '../screens/result_screen.dart';
import '../widgets/result_popup.dart';

enum TypingMode { standard, advanced }

class TypingController extends GetxController {
  final standardPassage =
      "In Flutter, a Divider is a widget used to create a thin line, typically horizontal, to visually separate content within a user interface. It is commonly used in lists, drawers, and other layouts to improve readability and organization.";
  final advancedPassage =
      "In Flutter, a Divider is a widget used to create a thin line, typically horizontal, to visually separate content within a user interface. It is commonly used in lists, drawers, and other layouts to improve readability and organization.";

  var currentMode = TypingMode.standard.obs;
  late List<String> words;

  var typedText = "".obs;
  var correctWords = 0.obs;
  var totalTypedWords = 0.obs;
  var wrongWords = 0.obs;
  var backspaceCount = 0.obs;

  var isTimerRunning = false.obs;
  var totalTime = 60;
  var remainingTime = 60.obs;

  Timer? _timer;
  @override
  void onInit() {
    super.onInit();

    final modeArg = Get.arguments?['mode'];
    if (modeArg == 'Advanced') {
      currentMode.value = TypingMode.advanced;
    } else {
      currentMode.value = TypingMode.standard;
    }

    loadPassage();
  }

  void loadPassage() {
    String passage = currentPassage;
    words = passage.split(" ");
  }

  String get currentPassage => currentMode.value == TypingMode.standard ? standardPassage : advancedPassage;
  void onTextChanged(String value) {
    if (value.length < typedText.value.length) backspaceCount.value++;
    typedText.value = value;

    if (!isTimerRunning.value) startTimer();

    List<String> typedWordsList = value.trim().split(" ");
    totalTypedWords.value = typedWordsList.length;

    correctWords.value = 0;
    wrongWords.value = 0;

    for (int i = 0; i < typedWordsList.length; i++) {
      if (i < words.length) {
        if (typedWordsList[i] == words[i]) {
          correctWords.value++;
        } else {
          wrongWords.value++;
        }
      }
    }
  }

  void startTimer() {
    if (isTimerRunning.value) return;
    isTimerRunning.value = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        timer.cancel();
        saveResult();
      }
    });
  }

  Future<void> saveResult() async {
    int wpm = correctWords.value;
    double accuracy = totalTypedWords.value == 0 ? 0 : (correctWords.value / totalTypedWords.value) * 100;

    await DBHelper.insertResult(
      netSpeed: wpm,
      grossSpeed: totalTypedWords.value,
      keystrokes: typedText.value.length,
      backspace: backspaceCount.value,
      correctWords: correctWords.value,
      wrongWords: wrongWords.value,
      accuracy: accuracy,
      typedText: typedText.value,
      originalText: currentPassage,
      duration: "${totalTime - remainingTime.value} sec",
      mode: "Standard",
    );
    showLatestResultPopup();

    // Get.off(
    //   () => ResultScreen(
    //     correct: correctWords.value,
    //     wrong: wrongWords.value,
    //     accuracy: accuracy,
    //     speed: wpm.toDouble(),
    //     dateTime: DateTime.now().toString(),
    //   ),
    // );
  }

  void showLatestResultPopup() async {
    final result = await DBHelper.getLatestResult();
    if (result != null) {
      // Get.dialog(ResultPopup(result: result));
    } else {
      Get.snackbar("No Data", "No results found in the database.");
    }
  }

  void resetTest() {
    _timer?.cancel();
    typedText.value = "";
    correctWords.value = 0;
    wrongWords.value = 0;
    totalTypedWords.value = 0;
    backspaceCount.value = 0;
    remainingTime.value = totalTime;
    isTimerRunning.value = false;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
