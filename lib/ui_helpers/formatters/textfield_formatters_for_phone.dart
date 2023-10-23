// ignore_for_file: prefer_is_empty

import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text =
        newValue.text.replaceAll(RegExp(r'[^\d]'), ''); // Sadece rakamları al
    final formattedText = StringBuffer();

    if (text.length >= 1) {
      formattedText.write(text.substring(0, 3));
    }
    if (text.length >= 4) {
      formattedText.write(' ${text.substring(3, 6)}');
    }
    if (text.length >= 7) {
      formattedText.write(' ${text.substring(6, 10)}');
    }
    return TextEditingValue(
      text: formattedText.toString(),
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
