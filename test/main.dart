// Copyright (c) 2016, Christian Stewart. All rights reserved. Use of this
// source code is governed by a BSD-style license that can be found in the
// LICENSE file.

import 'package:hijri/hijri_calendar.dart';
import 'package:test/test.dart';

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
      expect(_hijriDate.lengthOfYear(year: 1440), equals(355));
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
}
