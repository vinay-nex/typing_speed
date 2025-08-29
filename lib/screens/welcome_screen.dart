import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:typing_speed/screens/home_screen.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../db/db_helper.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<Map<String, dynamic>> results = [];
  String? userName;

  @override
  void initState() {
    super.initState();
    // _loadUser();
    loadResults();
  }

  Future<void> loadResults() async {
    final data = await DBHelper.getResults();
    setState(() {
      results = data;
    });
  }

  Future<void> _loadUser() async {
    String? name = await DBHelper.getUser();
    if (name == null) {
      _askUserName(); // show popup if no user
    } else {
      setState(() {
        userName = name;
      });
    }
  }

  void _askUserName() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false, // user cannot dismiss
      builder: (context) => AlertDialog(
        title: const Text("Enter your name"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Your name"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String name = controller.text.trim();
              if (name.isNotEmpty) {
                await DBHelper.insertUser(name); // save name in DB
                setState(() {
                  userName = name;
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          AppStrings.hiThere,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 📦 Card with text
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🏆 Title
                  Text(
                    "What’s your WPM? Take our one-minute typing test to find out your typing speed!",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// 📜 Description
                  const Text(
                    "One minute is all it takes to check your words per minute (WPM) score. "
                    "This one-minute typing test is perfect for kids or adults who want to check their typing speed quickly.\n\n"
                    "On the next screen, the timer won’t start until you start typing! Continue typing through the content until the timer ends.\n\n"
                    "Take this 1-minute timed typing test as many times as you like, and be sure to show off your best results with our shareable certificate of completion.",
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🎯 Continue Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                      onPressed: () {
                        Get.to(() => HomeScreen());
                      },
                      child: const Text(
                        "Continue",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),

            /// Previous score
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Tests',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),

            /// Recent score
            results.isEmpty
                ? Center(
                    child: Text(
                      'Your last score will show here.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  )
                : Card(
                    color: Colors.deepPurple.shade200.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: ListTile(
                      title: Text(
                        "${AppStrings.wpm}: ${results.last['wpm']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        "${AppStrings.accuracy}: ${results.last['accuracy'].toStringAsFixed(2)}%\nDate: ${results.last['date']}",
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
