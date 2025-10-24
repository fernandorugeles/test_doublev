import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 3),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);

    if (messenger != null) {
      messenger.clearSnackBars();

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: textColor),
          ),
          backgroundColor: backgroundColor,
          duration: duration,
          behavior: behavior,
        ),
      );
    }
  }
}
