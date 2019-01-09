import 'package:hijri/umm_alqura_calendar.dart';

void main() {
  //Suppose current gregorian data/time is: Mon May 29 00:27:33  2018
  ummAlquraCalendar _today = new ummAlquraCalendar.now();
  _today.currentLocale = 'ar';
  print(_today.hYear); // 1439
  print(_today.hMonth); // 9
  print(_today.hDay); // 14
  print(_today.hDay); // 14
  print(_today.dayWeName);
  // Get month length in days
  print(_today.lengthOfMonth); // 30 days
  print(_today.toFormat("MMMM dd yyyy")); //Ramadan 14 1439
  print(" 10 months from now ${new ummAlquraCalendar.addMonth(1440, 12)
      .fullDate()}"); //Ramadan 14 1439

  //From Gregorian to Ummalqura
  var h_date = new ummAlquraCalendar.fromDate(new DateTime(2018, 11, 12));

  print(h_date.fullDate()); //04/03/1440H
  print(h_date.shortMonthName); //Rab1
  print(h_date.longMonthName); //Rabi' al-awwal
  print(h_date.lengthOfMonth); // 29 days

  // check date is valid
  var _check_date = new ummAlquraCalendar()
    ..hYear = 1430
    ..hMonth = 09
    ..hDay = 8
    ..currentLocale = 'ar';
  print(_check_date.isValid()); // false -> This month is only 29 days
  print(_check_date.fullDate()); // false -> This month is only 29 days

  //From Ummalqura to Gregorian
  var g_date = new ummAlquraCalendar();
  print(g_date.hijriToGregorian(1440, 4, 19).toString()); //1994-12-29 00:00:00.000

  //Format
  var _format = new ummAlquraCalendar.now()..currentLocale = 'ar';

  print(_format.fullDate()); //Thulatha, Ramadan 14, 1439 h
  print(_format.toFormat("mm dd yy")); //09 14 39
  print(_format.toFormat("-- DD, MM dd --")); //09 14 39

  //Compare
  //Suppose current hijri data is: Thulatha, Ramadan 14, 1439 h
  print(_today.isAfter(1440, 11, 12)); // false
  print(_today.isBefore(1440, 11, 12)); // true
  print(_today.isAtSameMomentAs(1440, 11, 12)); // false
}
