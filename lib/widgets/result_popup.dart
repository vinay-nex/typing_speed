import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:typing_speed/constants/app_colors.dart';
import 'package:typing_speed/constants/app_strings.dart';
import '../model/result_model.dart';

class ResultPopup extends StatefulWidget {
  final ResultModel result;

  const ResultPopup({super.key, required this.result});

  @override
  State<ResultPopup> createState() => _ResultPopupState();
}

class _ResultPopupState extends State<ResultPopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: AppColors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Card Body
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
                /// Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.result,
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.share, color: AppColors.textLight),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// WPM Center
                Text(
                  "${widget.result.netSpeed} ${AppStrings.wpm}",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),

                const SizedBox(height: 16),

                Divider(
                  height: 1,
                  color: AppColors.textGrey,
                  thickness: 0.5,
                ),

                /// Stats
                _buildRow(AppStrings.netSpeed, "${widget.result.netSpeed} ${AppStrings.wpm}"),
                _buildRow(AppStrings.grossSpeed, "${widget.result.grossSpeed} ${AppStrings.wpm}"),
                _buildRow(
                  AppStrings.keyStrokes,
                  "${widget.result.keystrokes}",
                  subText: "(${widget.result.keystrokes - widget.result.backspace} | ${widget.result.backspace})",
                  subTextColor: AppColors.error,
                ),
                _buildRow(AppStrings.accuracy, "${widget.result.accuracy.toStringAsFixed(2)} %"),
                _buildRow(AppStrings.correctWords, "${widget.result.correctWords}", valueColor: AppColors.success),
                _buildRow(AppStrings.wrongWords, "${widget.result.wrongWords}", valueColor: AppColors.error, isLast: true),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// Analyse Result Button
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppStrings.analyseResult,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// _buildRow widgets
  Widget _buildRow(
    String label,
    String value, {
    String? subText,
    Color valueColor = AppColors.textDark,
    Color subTextColor = AppColors.success,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: isLast ? AppColors.transparent : AppColors.textGrey, width: 0.5),
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
