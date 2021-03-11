import 'package:hijri/hijri_calendar.dart';

void main() {
  String locale = 'ar';

  //Suppose current gregorian data/time is: Mon May 29 00:27:33  2018
  HijriCalendar _today = HijriCalendar.now();
  HijriCalendar.setLocal(locale);
  print(_today.hYear); // 1441
  print(_today.hMonth); // 11
  print(_today.hDay); // 28
  print(_today.getDayName());
  // Get month length in days
  print(_today.lengthOfMonth); // 30 days
  print(_today.toFormat("MMMM dd yyyy")); //Ramadan 14 1439
  print(
      " 10 months from now ${HijriCalendar.addMonth(1440, 12).fullDate()}"); //Ramadan 14 1439

  //From Gregorian to Ummalqura
  var hDate = HijriCalendar.fromDate(DateTime(2018, 11, 12));

  print(hDate.fullDate()); //04/03/1440H
  print(hDate.getShortMonthName()); //Rab1
  print(hDate.getLongMonthName()); //Rabi' al-awwal
  print(hDate.lengthOfMonth); // 29 days

  // check date is valid
  var _checkDate = HijriCalendar()
    ..hYear = 1430
    ..hMonth = 09
    ..hDay = 8;
  print(_checkDate.isValid()); // false -> This month is only 29 days
  print(_checkDate.fullDate()); // false -> This month is only 29 days

  //From Ummalqura to Gregorian
  var gDate = HijriCalendar();
  print(
      gDate.hijriToGregorian(1440, 4, 19).toString()); //1994-12-29 00:00:00.000

  //Format
  var _format = HijriCalendar.now();

  print(_format.fullDate()); //Thulatha, Ramadan 14, 1439 h
  print(_format.toFormat("mm dd yy")); //09 14 39
  print(_format.toFormat("-- DD, MM dd --")); //09 14 39

  //Compare
  //Suppose current hijri data is: Thulatha, Ramadan 14, 1439 h
  print(_today.isAfter(1440, 11, 12)); // false
  print(_today.isBefore(1440, 11, 12)); // true
  print(_today.isAtSameMomentAs(1440, 11, 12)); // false

  //Adjustment
  var defCal = HijriCalendar.fromDate(DateTime(2020, 8, 20));
  print("default ${defCal.fullDate()}");
  var adjCal = HijriCalendar();
  var adj = Map<int, int>();
  adj[17292] = 59083; // 30 days instead of 29
  adjCal.setAdjustments(adj);
  adjCal.gregorianToHijri(2020, 8, 20);
  print("adjusted ${adjCal.fullDate()}");
}
