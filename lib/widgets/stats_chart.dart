import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:typing_speed/constants/app_colors.dart';
import 'package:typing_speed/constants/app_strings.dart';

class StatCardWithCharts extends StatelessWidget {
  final int netSpeed;
  final int grossSpeed;
  final double accuracy;
  final int keystrokes;

  const StatCardWithCharts({
    super.key,
    required this.netSpeed,
    required this.grossSpeed,
    required this.accuracy,
    required this.keystrokes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.textLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackShadow,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.typingStatistics,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildChartItem(
                title: AppStrings.netSpeed,
                value: "$netSpeed ${AppStrings.wpm}",
                percent: _getPercent(netSpeed),
                color: Colors.blue,
              ),
              _buildChartItem(
                title: AppStrings.grossSpeed,
                value: "$grossSpeed ${AppStrings.wpm}",
                percent: _getPercent(grossSpeed),
                color: Colors.orange,
              ),
              _buildChartItem(
                title: AppStrings.accuracy,
                value: "${accuracy.toStringAsFixed(1)}%",
                percent: accuracy / 100,
                color: Colors.green,
              ),
              _buildChartItem(
                title: AppStrings.keyStrokes,
                value: "$keystrokes",
                percent: _getPercent(keystrokes),
                color: Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartItem({
    required String title,
    required String value,
    required double percent,
    required Color color,
  }) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 40.0,
          lineWidth: 8.0,
          percent: percent.clamp(0.0, 1.0),
          center: Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          progressColor: color,
          backgroundColor: color.withOpacity(0.2),
          circularStrokeCap: CircularStrokeCap.round,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  /// Convert raw number to percent (maxed at 100)
  double _getPercent(int value) {
    /// Assuming max 100 for simplicity; tweak logic if needed
    return (value / 100).clamp(0.0, 1.0);
  }
}
