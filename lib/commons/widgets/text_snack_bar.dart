import 'package:flutter/material.dart';

// ========== Text SnackBar Utility ==========
class TextSnackBar {
  // ========== Static Methods ==========
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      )
    );
  }
}