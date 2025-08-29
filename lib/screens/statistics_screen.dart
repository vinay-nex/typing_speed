import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:typing_speed/constants/app_colors.dart';

import '../constants/app_strings.dart';

class StatisticsScreen extends StatelessWidget {
  final int wpm;
  final double accuracy;
  final String date;

  const StatisticsScreen({
    super.key,
    required this.wpm,
    required this.accuracy,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.statisticsTitle,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.deepPurple.shade100,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "${AppStrings.testTakenOn} $date",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple.shade900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            ///  Bar Chart (Animated)
            _buildAnimatedCard(
              title: AppStrings.performanceOverview,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text(AppStrings.wpm);
                            case 1:
                              return const Text(AppStrings.accuracy);
                          }
                          return const Text("");
                        },
                      ),
                    ),
                  ),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: wpm.toDouble(),
                          color: Colors.deepPurple,
                          width: 30,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: accuracy,
                          color: Colors.green,
                          width: 30,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            ///  Line Chart (Animated)
            _buildAnimatedCard(
              title: AppStrings.accuracyTrend,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, accuracy),
                        FlSpot(1, (accuracy + 5).clamp(0, 100)),
                        FlSpot(2, accuracy),
                      ],
                      isCurved: true,
                      barWidth: 4,
                      color: Colors.orange,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            ///  WPM Circular Chart
            _buildAnimatedCard(
              title: AppStrings.typingSpeed,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: (wpm / 200).clamp(0.0, 1.0)),
                duration: const Duration(seconds: 2),
                builder: (context, value, _) {
                  return CircularPercentIndicator(
                    radius: 120.0,
                    lineWidth: 15.0,
                    percent: value,
                    center: Text(
                      "$wpm\nWPM",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.deepPurple,
                    backgroundColor: Colors.deepPurple.shade100,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            /// Accuracy Circular Chart
            _buildAnimatedCard(
              title: AppStrings.accuracy,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: (accuracy / 100).clamp(0.0, 1.0)),
                duration: const Duration(seconds: 2),
                builder: (context, value, _) {
                  return CircularPercentIndicator(
                    radius: 120.0,
                    lineWidth: 15.0,
                    percent: value,
                    center: Text(
                      "${accuracy.toStringAsFixed(1)}%\nAccuracy",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.green,
                    backgroundColor: Colors.green.shade100,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Common card builder with animations & theme
  Widget _buildAnimatedCard({required String title, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      shadowColor: Colors.deepPurple.withOpacity(0.3),
      color: AppColors.textOnPrimary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade700,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
                height: 300,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 800),
                  child: child,
                )),
          ],
        ),
      ),
    );
  }
}
