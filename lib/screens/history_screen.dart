import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:typing_speed/screens/statistics_screen.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../db/db_helper.dart';
import 'history_comparision.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
        title: Text(
          AppStrings.textHistory,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const HistoryComparisonScreen());
              },
              icon: Icon(Icons.history))
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradient1, AppColors.gradient2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: results.isEmpty
                    ? Center(
                        child: Text(
                          AppStrings.emptyHistory,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final res = results[index];
                          return InkWell(
                            onTap: () {
                              Get.to(() => StatisticsScreen(
                                    wpm: res['wpm'],
                                    accuracy: res['accuracy'],
                                    date: res['date'],
                                  ));
                            },
                            child: Card(
                              color: Colors.deepPurple.shade200.withOpacity(0.8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: ListTile(
                                title: Text(
                                  "${AppStrings.wpm}: ${res['wpm']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Text(
                                  "${AppStrings.accuracy}: ${res['accuracy'].toStringAsFixed(2)}%\nDate: ${res['date']}",
                                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () async {
          /// Show confirmation popup with theme
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.deepPurple.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.deleteHistory,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ],
                ),
                content: Text(
                  AppStrings.confirmDeleteHistory,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textOnPrimary,
                  ),
                ),
                actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                actions: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.textOnPrimary,
                        width: 1,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      AppStrings.no,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      AppStrings.yes,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textOnPrimary),
                    ),
                  ),
                ],
              );
            },
          );

          if (confirm == true) {
            await DBHelper.clearResults();
            loadResults();
          }
        },
        child: const Icon(Icons.delete, color: Colors.white),
      ),
    );
  }
}
