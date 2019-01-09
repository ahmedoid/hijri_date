// Copyright (c) 2016, Christian Stewart. All rights reserved. Use of this
// source code is governed by a BSD-style license that can be found in the
// LICENSE file.

import 'package:hijri/umm_alqura_calendar.dart';
import 'package:test/test.dart';

void main() {
  ummAlquraCalendar _hijriDate = new ummAlquraCalendar();
  _hijriDate.hYear = 1439;
  _hijriDate.hMonth = 10;
  _hijriDate.hDay = 30;
 // _hijriDate.currentLocale = 'ar';
  group('Hijri', () {
    test('produces the correct date', () {
      expect(new ummAlquraCalendar.fromDate(new DateTime(2018, 5, 27)).toList(),
          equals([1439, 9, 12]));
    });
    test('format date', () {
      expect(
          new ummAlquraCalendar.fromDate(new DateTime(2018, 5, 27))
              .toFormat("dd mm yy"),
          equals("12 09 39"));
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
          equals( new DateTime(2018, 06, 26, 00, 00, 00, 000)));
    });
  });
}
