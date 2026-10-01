import 'package:flutter/services.dart';

/// National digits of a Russian number, at most 10.
/// A leading 7 or 8 is the country prefix and is dropped.
String nationalPhoneDigits(String raw) {
  var digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.startsWith('7') || digits.startsWith('8')) {
    digits = digits.substring(1);
  }
  if (digits.length > 10) digits = digits.substring(0, 10);
  return digits;
}

/// Empty input is valid. A filled phone must be 10 digits after +7.
bool isValidRuPhone(String raw) {
  if (raw.trim().isEmpty) return true;
  return nationalPhoneDigits(raw).length == 10;
}

/// `+7XXXXXXXXXX`, or null when the field is empty or incomplete.
String? normalizedRuPhone(String raw) {
  final digits = nationalPhoneDigits(raw);
  if (digits.length != 10) return null;
  return '+7$digits';
}

/// `+7 (900) 000-00-00`. Incomplete input keeps the same shape.
/// An empty or unusable value is returned unchanged.
String formatRuPhone(String raw) {
  final digits = nationalPhoneDigits(raw);
  if (digits.isEmpty) return raw.trim().isEmpty ? '' : raw.trim();
  final buffer = StringBuffer('+7 (')..write(digits.substring(0, _end(digits, 3)));
  if (digits.length <= 3) return buffer.toString();
  buffer
    ..write(') ')
    ..write(digits.substring(3, _end(digits, 6)));
  if (digits.length <= 6) return buffer.toString();
  buffer
    ..write('-')
    ..write(digits.substring(6, _end(digits, 8)));
  if (digits.length <= 8) return buffer.toString();
  buffer
    ..write('-')
    ..write(digits.substring(8, _end(digits, 10)));
  return buffer.toString();
}

int _end(String digits, int max) => digits.length < max ? digits.length : max;

class RuPhoneInputFormatter extends TextInputFormatter {
  const RuPhoneInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = formatRuPhone(newValue.text);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
