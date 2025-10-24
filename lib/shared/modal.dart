import 'package:flutter/material.dart';

class Modal {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool dismissible = true,
    double? width,
    double? height,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: width ?? 500, // Ajustá según tu diseño
            maxHeight: height ?? double.infinity,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
