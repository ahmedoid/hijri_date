// Copyright (c) 2016, Christian Stewart. All rights reserved. Use of this
// source code is governed by a BSD-style license that can be found in the
// LICENSE file.

import 'package:test/test.dart';

import '../lib/hijri_calendar.dart';

void main() {
  HijriCalendar _hijriDate = HijriCalendar();
  _hijriDate.hYear = 1439;
  _hijriDate.hMonth = 10;
  _hijriDate.hDay = 30;

  // _hijriDate.currentLocale = 'ar';
  group('Hijri', () {
    test('produces the correct date', () {
      expect(HijriCalendar.fromDate(DateTime(2020, 5, 20)).toList(),
          equals([1441, 9, 27]));
    });
    test('format date', () {
      expect(HijriCalendar.fromDate(DateTime(2018, 5, 27)).toFormat("dd mm yy"),
          equals("12 9 39"));
    });
    test('is valid date', () {
      expect(_hijriDate.isValid(), equals(false));
    });

    test('days in year', () {
      // Correct length of year 1440 AH per Umm al-Qura:
      // 1 Muharram 1440 = 2018-09-11; 1 Muharram 1441 = 2019-08-31 (354 days).
      expect(_hijriDate.lengthOfYear(year: 1440), equals(354));
    });

    test('lengthOfYear matches Gregorian-day difference across full range', () {
      final c = HijriCalendar();
      for (var y = 1356; y <= 1499; y++) {
        final fixed = c.lengthOfYear(year: y);
        final greg = c
            .hijriToGregorian(y + 1, 1, 1)
            .difference(c.hijriToGregorian(y, 1, 1))
            .inDays;
        expect(fixed, equals(greg),
            reason: 'year $y: lengthOfYear=$fixed but Gregorian diff=$greg');
      }
    });

    test('lengthOfYear handles boundary year 1356', () {
      // Previously threw ArgumentError due to m=0 reading array[-1].
      expect(HijriCalendar().lengthOfYear(year: 1356), equals(353));
    });

    test('days in month', () {
      expect(_hijriDate.getDaysInMonth(1440, 11), equals(29));
    });
    test('format', () {
      expect(_hijriDate.toFormat("DDDD MM yyyy dd"),
          equals("Saturday Shaw 1439 30"));
      expect(_hijriDate.toFormat("DD MMMM yy d"), equals("Sat Shawwal 39 30"));
      expect(_hijriDate.toFormat("MMMM"), equals("Shawwal"));
      expect(_hijriDate.toFormat("MM"), equals("Shaw"));
      expect(_hijriDate.toFormat("dd"), equals("30"));
      expect(_hijriDate.toFormat("d"), equals("30"));
      expect(_hijriDate.toFormat("yyyy"), equals("1439"));
      expect(_hijriDate.toFormat("yy"), equals("39"));
    });

    test('add locale', () {
      const Map<int, String> monthNames = {
        1: 'Muharram',
        2: 'Safar',
        3: 'Rabiul Awal',
        4: 'Rabiul Akhir',
        5: 'Jumadil Awal',
        6: 'Jumadil Akhir',
        7: 'Rajab',
        8: 'Sya\'ban',
        9: 'Ramadan',
        10: 'Syawal',
        11: 'Dzulqa\'dah',
        12: 'Dzulhijjah'
      };
      const Map<int, String> monthShortNames = {
        1: 'Muh',
        2: 'Saf',
        3: 'Rab1',
        4: 'Rab2',
        5: 'Jum1',
        6: 'Jum2',
        7: 'Raj',
        8: 'Sya\'',
        9: 'Ram',
        10: 'Syaw',
        11: 'DzuQ',
        12: 'DzuH'
      };
      const Map<int, String> wdNames = {
        7: "Ahad",
        1: "Senin",
        2: "Selasa",
        3: "Rabu",
        4: "Kamis",
        5: "Jum'at",
        6: "Sabtu"
      };
      const Map<int, String> shortWdNames = {
        7: "Aha",
        1: "Sen",
        2: "Sel",
        3: "Rab",
        4: "Kam",
        5: "Jum",
        6: "Sab"
      };
      HijriCalendar.addLocale('id', HijriLocale(
        longMonths: monthNames,
        shortMonths: monthShortNames,
        days: wdNames,
        shortDays: shortWdNames,
      ));
      // Per-instance locale (4.0.0): assign on the instance directly, no
      // global setLocal mutation required.
      _hijriDate.locale = 'id';
      expect(_hijriDate.toFormat("DDDD MM yyyy dd"),
          equals("Sabtu Syaw 1439 30"));
      _hijriDate.locale = 'en'; // restore for later tests
    });
  });

  group('compare dates', () {
    test('this date occurs before enterd date', () {
      expect(_hijriDate.isBefore(1439, 10, 12), equals(false));
    });
    test('this date occurs after enterd date', () {
      expect(_hijriDate.isAfter(1439, 10, 12), equals(true));
    });
    test('this date occurs after enterd date', () {
      expect(_hijriDate.isAtSameMomentAs(1439, 10, 30), equals(true));
    });
  });

  group('Gregorian', () {
    test('convert Hijri to Gregorian', () {
      expect(_hijriDate.hijriToGregorian(1439, 10, 12),
          equals(DateTime(2018, 06, 26, 00, 00, 00, 000)));
    });
  });

  group('adjustment', () {
    HijriCalendar _adjCal = HijriCalendar();
    test('without adjustment produces the correct date', () {
      _adjCal.gregorianToHijri(2020, 8, 20);
      expect(_adjCal.toList(), equals([1442, 1, 1]));
    });
    test('with adjustment produced the correct date', () {
      //year 1441, month 12 ((1441 - 1) * 12 + 12) has 30 days instead of 29
      _adjCal.setAdjustments({17292: 59083});
      _adjCal.gregorianToHijri(2020, 8, 20);
      expect(_adjCal.toList(), equals([1441, 12, 30]));
    });
  });


     group('return Map of months values', () {
    HijriCalendar _calender = HijriCalendar();
    test('get all months', () {
      HijriCalendar.setLocal('en');
       const Map<int, String> monthNames = {
       1: 'Muharram',
       2: 'Safar',
       3: 'Rabi\' Al-Awwal',
       4: 'Rabi\' Al-Akhir',
       5: 'Jumada Al-Awwal',
       6: 'Jumada Al-Akhirah',
       7: 'Rajab',
       8: 'Sha\'ban',
       9: 'Ramadan',
       10: 'Shawwal',
       11: 'Dhu Al-Qi\'dah',
       12: 'Dhu Al-Hijjah'
      };
      Map monthes=_calender.getMonths();     
      expect(monthes, equals(monthNames)) ;
    });

       test('get specific month calender', () {
         HijriCalendar _calender = HijriCalendar();
         Map monthes=_calender.getMonthDays(HijriCalendar.now().hMonth,HijriCalendar.now().hYear);
      expect(monthes, equals(monthes));
    });

  });

  // Regression: format() previously did sequential replaceFirst calls, so
  // day names containing lowercase Latin m/d/y were corrupted. e.g.
  // Indonesian "Jum'at" was rendered as "Ju12'at" when month was 12.
  group('format() tokenizer (4.0.0)', () {
    HijriCalendar.setLocal('en');
    test('does not corrupt day names with lowercase m', () {
      HijriCalendar.addLocale(
          'id_test',
          const HijriLocale(
            longMonths: {
              1: 'Mh', 2: 'Sf', 3: 'R1', 4: 'R2', 5: 'J1', 6: 'J2',
              7: 'Rj', 8: 'Sb', 9: 'Rm', 10: 'Sw', 11: 'Dq', 12: 'Dh',
            },
            shortMonths: {
              1: 'M', 2: 'S', 3: 'R1', 4: 'R2', 5: 'J1', 6: 'J2',
              7: 'Rj', 8: 'Sb', 9: 'Rm', 10: 'Sw', 11: 'Dq', 12: 'Dh',
            },
            days: {
              7: 'Ahad', 1: 'Senin', 2: 'Selasa', 3: 'Rabu',
              4: 'Kamis', 5: "Jum'at", 6: 'Sabtu',
            },
            shortDays: {
              7: 'Aha', 1: 'Sen', 2: 'Sel', 3: 'Rab',
              4: 'Kam', 5: 'Jum', 6: 'Sab',
            },
          ));
      HijriCalendar.setLocal('id_test');
      final h = HijriCalendar.fromDate(DateTime(2026, 5, 22)); // Friday
      // Should produce: Jum'at, Dh 5, 1447 (NOT Ju12'at, Dh 5, 1447)
      expect(h.toFormat('DDDD, MMMM dd, yyyy'),
          equals("Jum'at, Dh 5, 1447"));
      HijriCalendar.setLocal('en');
    });

    test('does not substitute m/yy when format has no m/yy token', () {
      HijriCalendar.setLocal('en');
      final h = HijriCalendar.fromDate(DateTime(2026, 5, 22));
      // No m, d, y tokens — should return literal day name unchanged.
      expect(h.toFormat('DDDD'), equals('Friday'));
    });
  });

  group('addMonths / addDays (4.0.0)', () {
    final base = HijriCalendar()..gregorianToHijri(2026, 5, 22); // 5/12/1447
    test('addMonths positive', () {
      expect(base.addMonths(1).toList(), equals([1448, 1, 5]));
      expect(base.addMonths(13).toList(), equals([1449, 1, 5]));
    });
    test('addMonths zero is identity', () {
      expect(base.addMonths(0).toList(), equals([1447, 12, 5]));
    });
    test('addMonths negative crosses year boundary', () {
      expect(base.addMonths(-1).toList(), equals([1447, 11, 5]));
      expect(base.addMonths(-12).toList(), equals([1446, 12, 5]));
      expect(base.addMonths(-13).toList(), equals([1446, 11, 5]));
    });
    test('addDays positive and negative', () {
      expect(base.addDays(1).toList(), equals([1447, 12, 6]));
      expect(base.addDays(-1).toList(), equals([1447, 12, 4]));
    });
    test('addDays crosses month', () {
      // Dhu al-Hijja 1447 has 29 days; from day 5, +24 days lands on day 29,
      // +25 days lands on 1 Muharram 1448.
      expect(base.addDays(25).toList(), equals([1448, 1, 1]));
    });
  });

  // Regression for issue #26: 1446 Jumada-II should be 30 days and 1485
  // Shawwal should be 30 days, matching authoritative Umm al-Qura data and
  // moment-hijri upstream.
  group('data array corrections (issue #26)', () {
    final c = HijriCalendar();
    test('1446 Jumada-I = 29 days', () {
      expect(c.getDaysInMonth(1446, 5), equals(29));
    });
    test('1446 Jumada-II = 30 days', () {
      expect(c.getDaysInMonth(1446, 6), equals(30));
    });
    test('2024-12-02 -> 1 Jumada-II 1446', () {
      final h = HijriCalendar.fromDate(DateTime(2024, 12, 2));
      expect(h.toList(), equals([1446, 6, 1]));
    });
    test('2024-12-31 -> 30 Jumada-II 1446', () {
      final h = HijriCalendar.fromDate(DateTime(2024, 12, 31));
      expect(h.toList(), equals([1446, 6, 30]));
    });
    test('1485 Ramadan = 29, Shawwal = 30', () {
      expect(c.getDaysInMonth(1485, 9), equals(29));
      expect(c.getDaysInMonth(1485, 10), equals(30));
    });
  });

  // Regression for issue #25: setLocal with an unregistered locale used to
  // silently corrupt the static `language` and crash later in _local[language]!
  // with a confusing "Null check operator used on a null value" error.
  group('setLocal validation (issue #25)', () {
    test('throws ArgumentError for unregistered locale', () {
      expect(() => HijriCalendar.setLocal('fr'), throwsArgumentError);
    });

    test('does not mutate defaultLocale when validation fails', () {
      HijriCalendar.setLocal('en');
      try {
        HijriCalendar.setLocal('xx');
      } catch (_) {}
      expect(HijriCalendar.defaultLocale, equals('en'));
      expect(HijriCalendar.now().dayWeName, isNotEmpty);
    });

    test('supportedLocales reflects built-ins', () {
      expect(HijriCalendar.supportedLocales, containsAll(['en', 'ar', 'tr']));
    });
  });
}
