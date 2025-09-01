import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:typing_speed/constants/app_strings.dart';
import 'package:typing_speed/model/result_model.dart';
import '../constants/app_colors.dart';
import '../db/db_helper.dart';
import '../widgets/stats_chart.dart';

class ResultScreen extends StatefulWidget {
  final int id;

  const ResultScreen({
    super.key,
    required this.id,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  ResultModel? result;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    final res = await DBHelper.getResultById(widget.id);
    if (res != null) {
      setState(() {
        result = res;
      });
    }
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
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.textLight,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      AppStrings.result,
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Main content overlapping AppBar
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.textLight,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blackShadow,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildRow(AppStrings.netSpeed, "${result!.netSpeed} ${AppStrings.wpm}"),
                      _buildRow(AppStrings.grossSpeed, "${result!.grossSpeed} ${AppStrings.wpm}"),
                      _buildRow(
                        AppStrings.keyStrokes,
                        "${result!.keystrokes}",
                        subText: "(${result!.keystrokes - result!.backspace} | ${result!.backspace})",
                        subTextColor: AppColors.error,
                      ),
                      _buildRow(AppStrings.accuracy, "${result!.accuracy.toStringAsFixed(2)} %"),
                      _buildRow(AppStrings.correctWords, "${result!.correctWords}", valueColor: AppColors.success),
                      _buildRow(AppStrings.wrongWords, "${result!.wrongWords}", valueColor: AppColors.error),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                StatCardWithCharts(
                  netSpeed: result!.netSpeed,
                  grossSpeed: result!.grossSpeed,
                  accuracy: result!.accuracy,
                  keystrokes: result!.keystrokes,
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.textLight,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blackShadow,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildRow(AppStrings.date, "${result!.date} "),
                      _buildRow(AppStrings.time, "${result!.time} "),
                      _buildRow(AppStrings.duration, result!.duration),
                      _buildRow(AppStrings.mode, result!.mode, valueColor: AppColors.success),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.textLight,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blackShadow,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.originalText,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(result!.originalText),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.textLight,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blackShadow,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.typingTest,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(result!.typedText),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value, {
    String? subText,
    Color valueColor = Colors.black,
    Color subTextColor = Colors.green,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFBDBDBD), width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
              if (subText != null)
                Text(
                  " $subText",
                  style: TextStyle(
                    fontSize: 14,
                    color: subTextColor,
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
