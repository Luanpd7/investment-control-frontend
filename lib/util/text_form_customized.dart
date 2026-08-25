import 'package:controle_investimento/util/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'formatter.dart';

class TextFormCustomized extends StatelessWidget {
  const TextFormCustomized({super.key,
    required this.controller,
    required this.label,
    this.inputFormatters,
  });

  final String label;

  final TextEditingController controller;

  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        label: Text(label, style: AppTextStyles.subtitle),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.4),
            width: 2,
          ),
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        RealInputFormatter(),
      ],
      controller: controller,
    );
  }
}
