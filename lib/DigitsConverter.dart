class DigitsConverter {
  static final List<String> easternArabicNumerals = [
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

  static String convertWesternNumberToEastern(int easternNumber) {
    String englishNumber = easternNumber.toString();
    StringBuffer stringBuffer = new StringBuffer();
    englishNumber.runes.forEach((rune) {
      var character = new String.fromCharCode(rune);
      stringBuffer.write(easternArabicNumerals[int.parse(character)]);
    });
    return stringBuffer.toString();
  }
}
