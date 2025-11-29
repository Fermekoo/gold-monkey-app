import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF0B0B15);
  static const Color cardSurface = Color(0xFF1C1C2E);
  static const Color primary = Color(0xFF4B68FF);
  static const Color accent = Color(0xFF2D2D44);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.grey;

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomLeft,
    colors: [
      Color.fromARGB(255, 79, 79, 170),
      Color.fromARGB(255, 24, 24, 39),
    ], 
  );

  static Color glassFill = Colors.white.withValues(alpha: 0.06);
  static Color glassBorder = Colors.white.withValues(alpha: 0.2);
  static Color inputFill = Colors.black.withValues(alpha: 0.3);
}