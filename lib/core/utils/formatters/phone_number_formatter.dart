import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Strip everything except digits
    String text = newValue.text.replaceAll(RegExp(r'\D'), '');
    String newText = '';
    
    // Add space every 4 digits
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        newText += '-';
      }
      newText += text[i];
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
