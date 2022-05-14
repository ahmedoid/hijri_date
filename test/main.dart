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
      HijriCalendar.addLocale('id', {
        'long': monthNames,
        'short': monthShortNames,
        'days': wdNames,
        'short_days': shortWdNames
      });
      HijriCalendar.setLocal('id');
      expect(_hijriDate.toFormat("DDDD MM yyyy dd"),
          equals("Sabtu Syaw 1439 30"));
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
       const Map<int, String> monthNames = {
       1: 'Muharram',
       2: 'Safar',
       3: 'Rabi\' Al-Awwal',
       4: 'Rabi\' Al-Thani',
       5: 'Jumada Al-Awwal',
       6: 'Jumada Al-Thani',
       7: 'Rajab',
       8: 'Sha\'aban',
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
}
