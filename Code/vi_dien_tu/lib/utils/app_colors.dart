import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xffef3c7b);
  static const Color primaryLight =
      Color(0xfffff0f5);
  static const Color background =
      Color(0xfff9f9e8);
  static const Color surface = Colors.white;
  static const Color success = Color(0xff4caf50);
  static const Color error = Color(0xfff44336);
  static const Color warning = Color(0xffff9800);
  static const Color info = Color(0xff2196f3);

  // Gradient colors
  static const LinearGradient primaryGradient =
      LinearGradient(
    colors: [
      Color(0xffef3c7b),
      Color(0xffff6b9d)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
