import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomLoader extends StatelessWidget {
  final Color color;
  final double strokeWidth;

  const CustomLoader({
    super.key,
    this.color = AppColors.textLight,
    this.strokeWidth = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
