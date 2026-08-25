import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final _currencyFormatter = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: 'R\$',
  decimalDigits: 2,
);

String formatCurrency(double value) {
  return _currencyFormatter.format(value);
}

String formatCurrencyWithoutSymbol(double value) {
  return _currencyFormatter.format(value).replaceAll('R\$', '').trim();
}

final percentFormatter = NumberFormat("0.##'%'");

String formatMonthYear(DateTime date) {
  final formatted = DateFormat('MMM/yyyy', 'pt_BR').format(date);

  return formatted[0].toUpperCase() + formatted.substring(1);
}

class RealInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final numbers = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    final value = double.parse(numbers) / 100;

    final formatted = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$ ',
      decimalDigits: 2,
    ).format(value);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
