import 'package:controle_investimento/util/text_style.dart';
import 'package:flutter/material.dart';

class ButtonClickCustomized extends StatelessWidget {
  const ButtonClickCustomized({
    super.key,
    required this.label,
    this.onPressed,
    required this.icon,
  });

  final String label;

  final void Function()? onPressed;

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            spacing: 5,
            children: [
              Icon(icon, color: Color(0xFF5F6F8C), size: 16),
              Text(label, style: AppTextStyles.subtitle),
            ],
          ),
        ),
      ),
    );
  }
}
