/// Digit sets for non-Western locales.
class DigitsConverter {
  /// Arabic-Indic digits (U+0660..U+0669), used by Arabic.
  static const List<String> arabicIndicNumerals = [
    '٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩',
  ];

  /// Extended Arabic-Indic digits (U+06F0..U+06F9), used by Urdu, Persian,
  /// Pashto, and others. Visually distinct from arabicIndicNumerals for 4, 5, 6.
  static const List<String> extendedArabicIndicNumerals = [
    '۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹',
  ];

  /// @deprecated Use [arabicIndicNumerals]. Retained for backward compatibility.
  static const List<String> easternArabicNumerals = arabicIndicNumerals;

  /// Convert a Western number to Arabic-Indic digits. For other digit sets,
  /// use [convert] with a custom mapping.
  static String convertWesternNumberToEastern(int? easternNumber) {
    return convert(easternNumber, arabicIndicNumerals);
  }

  /// Convert a Western-digit number to an arbitrary 10-character digit set.
  /// [digits] must have length 10 (indices 0..9).
  static String convert(int? number, List<String> digits) {
    assert(digits.length == 10, 'digits must contain exactly 10 entries');
    final s = number.toString();
    final buf = StringBuffer();
    for (final rune in s.runes) {
      final c = String.fromCharCode(rune);
      final code = c.codeUnitAt(0);
      // ASCII '0'..'9' → digit set; anything else (e.g. '-') passed through.
      if (code >= 0x30 && code <= 0x39) {
        buf.write(digits[code - 0x30]);
      } else {
        buf.write(c);
      }
    }
    return buf.toString();
  }
}
