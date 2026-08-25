import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushBarUtil {
  static void show({
    required BuildContext context,
    required String message,
    required Color color,
  }) {
    Flushbar(
      message: message,
      icon: const Icon(Icons.check_circle, color: Colors.white, size: 20),
      backgroundColor: color,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.BOTTOM,
      maxWidth: 320,
      margin: const EdgeInsets.only(right: 16, bottom: 16),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }
}
