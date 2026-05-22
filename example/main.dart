import 'package:hijri/hijri_calendar.dart';

void main() {
  // Get today in the Hijri (Umm al-Qura) calendar.
  HijriCalendar _today = HijriCalendar.now();
  print(_today.hYear);
  print(_today.hMonth);
  print(_today.hDay);
  print(_today.getDayName());
  print(_today.lengthOfMonth);
  print(_today.toFormat('MMMM dd yyyy'));

  // Switch the active locale. Built-in locales: 'en', 'ar', 'tr'.
  print('Supported locales: ${HijriCalendar.supportedLocales}');
  HijriCalendar.setLocal('ar');
  print(_today.toFormat('DDDD, MMMM dd, yyyy'));

  // Passing an unregistered locale now throws a clear ArgumentError
  // instead of silently crashing with "Null check operator used on a null value".
  try {
    HijriCalendar.setLocal('fr');
  } on ArgumentError catch (e) {
    print('Caught: $e');
  }

  // Register a new locale (Indonesian) and activate it.
  HijriCalendar.addLocale('id', {
    'long': const {
      1: 'Muharram', 2: 'Safar', 3: 'Rabiul Awal', 4: 'Rabiul Akhir',
      5: 'Jumadil Awal', 6: 'Jumadil Akhir', 7: 'Rajab', 8: "Sya'ban",
      9: 'Ramadan', 10: 'Syawal', 11: "Dzulqa'dah", 12: 'Dzulhijjah',
    },
    'short': const {
      1: 'Muh', 2: 'Saf', 3: 'Rab1', 4: 'Rab2', 5: 'Jum1', 6: 'Jum2',
      7: 'Raj', 8: "Sya'", 9: 'Ram', 10: 'Syaw', 11: 'DzuQ', 12: 'DzuH',
    },
    'days': const {
      7: 'Ahad', 1: 'Senin', 2: 'Selasa', 3: 'Rabu',
      4: 'Kamis', 5: "Jum'at", 6: 'Sabtu',
    },
    'short_days': const {
      7: 'Aha', 1: 'Sen', 2: 'Sel', 3: 'Rab', 4: 'Kam', 5: 'Jum', 6: 'Sab',
    },
  });
  HijriCalendar.setLocal('id');
  print('In Indonesian: ${_today.getDayName()}, '
      '${_today.getLongMonthName()} ${_today.hDay}, ${_today.hYear}');

  // Reset to English for the rest of the example.
  HijriCalendar.setLocal('en');

  // Gregorian → Hijri.
  var hDate = HijriCalendar.fromDate(DateTime(2018, 11, 12));
  print(hDate.fullDate());
  print(hDate.getShortMonthName());
  print(hDate.getLongMonthName());
  print(hDate.lengthOfMonth);

  // isValid().
  var _checkDate = HijriCalendar()
    ..hYear = 1430
    ..hMonth = 9
    ..hDay = 8;
  print(_checkDate.isValid());
  print(_checkDate.fullDate());

  // Hijri → Gregorian.
  var gDate = HijriCalendar();
  print(gDate.hijriToGregorian(1440, 4, 19).toString());

  // Formatting tokens.
  var _format = HijriCalendar.now();
  print(_format.fullDate());
  print(_format.toFormat('mm dd yy'));
  print(_format.toFormat('-- DD, MM dd --'));

  // Comparisons.
  print(_today.isAfter(1440, 11, 12));
  print(_today.isBefore(1440, 11, 12));
  print(_today.isAtSameMomentAs(1440, 11, 12));

  // Adjustment for locally-observed moon sightings.
  var defCal = HijriCalendar.fromDate(DateTime(2020, 8, 20));
  print('default ${defCal.fullDate()}');
  var adjCal = HijriCalendar();
  adjCal.setAdjustments({17292: 59083});
  adjCal.gregorianToHijri(2020, 8, 20);
  print('adjusted ${adjCal.fullDate()}');
}
