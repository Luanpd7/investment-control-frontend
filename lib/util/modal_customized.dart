import 'package:flutter/material.dart';

Future<void> modalCustomized(BuildContext ctx, {required Widget content}) {
  return showDialog(
    context: ctx,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: content,
        ),
      );
    },
  );
}
