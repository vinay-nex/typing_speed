import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../constants/app_colors.dart';
import '../db/db_helper.dart';

class HistoryComparisonScreen extends StatefulWidget {
  const HistoryComparisonScreen({super.key});

  @override
  State<HistoryComparisonScreen> createState() => _HistoryComparisonScreenState();
}

class _HistoryComparisonScreenState extends State<HistoryComparisonScreen> {
  List<Map<String, dynamic>> results = [];

  @override
  void initState() {
    super.initState();
    loadResults();
  }

  Future<void> loadResults() async {
    final data = await DBHelper.getResults();
    setState(() {
      results = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Progress Comparison"),
      ),
      body: results.isEmpty
          ? const Center(child: Text("No history available"))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < results.length) {
                            return Text(
                              "T${value.toInt() + 1}", // T1, T2, T3 for test #
                              style: const TextStyle(fontSize: 12),
                            );
                          }
                          return const Text("");
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 10,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  lineBarsData: [
                    // 🔵 WPM trend
                    LineChartBarData(
                      spots: results.asMap().entries.map((entry) {
                        final index = entry.key;
                        final data = entry.value;
                        return FlSpot(index.toDouble(), data['wpm'].toDouble());
                      }).toList(),
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),

                    // 🟢 Accuracy trend
                    LineChartBarData(
                      spots: results.asMap().entries.map((entry) {
                        final index = entry.key;
                        final data = entry.value;
                        return FlSpot(index.toDouble(), data['accuracy']);
                      }).toList(),
                      isCurved: true,
                      color: AppColors.accent,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
