class DigitsConverter {
  static const List<String> easternArabicNumerals = [
    '٠',
    '١',
    '٢',
    '٣',
    '٤',
    '٥',
    '٦',
    '٧',
    '٨',
    '٩'
  ];

  static String convertWesternNumberToEastern(int? easternNumber) {
    String englishNumber = easternNumber.toString();
    StringBuffer stringBuffer = StringBuffer();
    englishNumber.runes.forEach((rune) {
      String character = String.fromCharCode(rune);
      stringBuffer.write(easternArabicNumerals[int.parse(character)]);
    });
    return stringBuffer.toString();
  }
}
