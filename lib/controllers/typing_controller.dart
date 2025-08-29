import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../db/db_helper.dart';

class TypingController extends GetxController {
  var textToType = "".obs;
  var userInput = "".obs;
  var seconds = 60.obs;
  var isRunning = false.obs;
  var wpm = 0.obs;
  var accuracy = 0.0.obs;

  /// For input focus & controller
  final textController = TextEditingController();
  final focusNode = FocusNode();

  /// set passage text
  void setText(String passage) {
    textToType.value = passage;
  }

  /// start typing test
  void startTest() {
    userInput.value = "";
    textController.clear();
    wpm.value = 0;
    accuracy.value = 0;
    isRunning.value = true;
    seconds.value = 60;

    /// autofocus keyboard
    Future.delayed(const Duration(milliseconds: 300), () {
      focusNode.requestFocus();
    });

    /// countdown timer
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (seconds.value > 0 && isRunning.value) {
        seconds.value--;
        return true;
      } else {
        finishTest();
        return false;
      }
    });
  }

  /// finish typing test
  void finishTest() async {
    if (!isRunning.value) return;
    isRunning.value = false;

    int correctChars = 0;
    for (int i = 0; i < userInput.value.length && i < textToType.value.length; i++) {
      if (userInput.value[i] == textToType.value[i]) correctChars++;
    }

    double minutes = 0.5;
    wpm.value = (userInput.value.length / 5 / minutes).round();
    accuracy.value = (correctChars / (userInput.value.isEmpty ? 1 : userInput.value.length)) * 100;

    await DBHelper.insertResult(wpm.value, accuracy.value);
  }

  @override
  void onClose() {
    textController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
