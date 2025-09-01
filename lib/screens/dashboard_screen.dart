import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:typing_speed/constants/app_colors.dart';
import 'package:typing_speed/constants/app_strings.dart';
import 'package:typing_speed/screens/history_screen.dart';
import 'package:typing_speed/screens/typing_screen.dart';
import '../db/db_helper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> results = [];

  @override
  void initState() {
    super.initState();
    loadResults();
  }

  /// Load results
  Future<void> loadResults() async {
    final data = await DBHelper.getResults();
    setState(() {
      results = data;
    });
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.hiThere,
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          AppStrings.letsBootsYourTypingSpeed,
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.more_vert,
                      color: AppColors.textLight,
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Main content overlapping AppBar
          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => TypingScreen(), arguments: {'mode': 'Standard'});
                  },
                  child: _buildActionTile(
                    icon: Icons.play_arrow,
                    color: AppColors.success,
                    title: AppStrings.typingTest,
                    subtitle: AppStrings.top100Words,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => TypingScreen(), arguments: {'mode': 'Advanced'});
                  },
                  child: _buildActionTile(
                    icon: Icons.play_arrow,
                    color: AppColors.error,
                    title: AppStrings.typingTestAdvance,
                    subtitle: AppStrings.top200Words,
                  ),
                ),
                _buildActionTile(
                  icon: Icons.edit_note,
                  color: AppColors.success,
                  title: "Practice for Exams",
                  subtitle: "Start Practice for your Typing Exams",
                ),
                _buildActionTile(
                  icon: Icons.school,
                  color: AppColors.primaryBlue,
                  title: "Learn Typing",
                  subtitle: "Learn Typing row-wise",
                ),
                _buildActionTile(
                  icon: Icons.settings,
                  color: Colors.orange,
                  title: "Custom Typing Test",
                  subtitle: "Practice your own words",
                ),

                const SizedBox(height: 20),

                /// Recent Tests Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.recentTest,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => HistoryScreen());
                      },
                      child: Text(
                        AppStrings.viewAll,
                        style: TextStyle(
                          color: AppColors.textGrey,
                        ),
                      ),
                    ),
                  ],
                ),
                results.isEmpty ? const SizedBox(height: 16) : const SizedBox(height: 8),

                /// Recent score
                results.isEmpty
                    ? Center(
                        child: Text(
                          AppStrings.recentTestWillShowHere,
                          style: TextStyle(
                            color: AppColors.textGrey,
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Left Side
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${AppStrings.wpm} ${results.last['net_speed']}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("${AppStrings.accuracy}: ${results.last['accuracy']}"),
                                  const SizedBox(height: 4),
                                  Text("${AppStrings.duration}: ${results.last['duration']}"),
                                ],
                              ),
                            ),

                            /// Right Side
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${results.last['date']}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${results.last['time']}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                const SizedBox(height: 40),

                /// Start Typing Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      AppStrings.startTypingTest,
                      style: TextStyle(fontSize: 18, color: AppColors.textLight),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Remove Ads button
                const Center(
                  child: Text(
                    "⛔ ${AppStrings.removeAds}",
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Custom Action Tile Widget
  Widget _buildActionTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.textLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackShadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: AppColors.textGrey, fontSize: 13),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward, color: color),
        ],
      ),
    );
  }
}
