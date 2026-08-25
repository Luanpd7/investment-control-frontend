import 'package:controle_investimento/util/text_style.dart';
import 'package:flutter/material.dart';

class ButtonCustomized extends StatelessWidget {
  const ButtonCustomized({
    super.key,
    required this.label,
    this.onPressed,
    required this.icon,
    this.secondary,
  });

  final String label;

  final void Function()? onPressed;

  final IconData icon;

  final bool? secondary;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: secondary == true
            ? WidgetStatePropertyAll(Colors.grey)
            : WidgetStatePropertyAll(Colors.black),
      ),
      child: Row(
        spacing: 5,
        children: [
          Icon(icon, color: Colors.white),
          Text(label, style: AppTextStyles.label.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}
