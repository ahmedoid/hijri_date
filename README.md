# Hijri

Hijri Calendar Converter



#### Usage



```dart
//Suppose current gregorian data/time is: Mon May 29 00:27:33  2018
  var _today = HijriCalendar.now();
  print(_today.hYear); // 1439
  print(_today.hMonth); // 9
  print(_today.hDay); // 14
  print(_today.getDayName()); // 14
  // Get month length in days
  print(_today.lengthOfMonth); // 30 days
  print(_today.toFormat("MMMM dd yyyy")); //Ramadan 14 1439
```
 ##### Change Local
```dart
  HijriCalendar.setLocal(locale);
```
 ##### Add New Locale
```dart
  HijriCalendar.addLocale(locale, {
    'long': ...,
    'short': ...,
    'days': ...,
    'short_days': ...
  });
  HijriCalendar.setLocal(locale);
```
  ##### From Gregorian to Ummalqura
  ```dart
  var h_date = HijriCalendar.fromDate(DateTime(2018, 11, 12));
  print(h_date.toString()); //04/03/1440H
  print(h_date.getShortMonthName()); //Rab1
  print(h_date.getLongMonthName()); //Rabi' al-awwal
  print(h_date.lengthOfMonth); // 29 days
```
##### Check if date is valid
```dart
  //
  var _check_date = HijriCalendar();
  _check_date.hYear = 1439;
  _check_date.hMonth = 11;
  _check_date.hDay = 30;
  print(_check_date.isValid()); // false -> This month is only 29 days
```
##### From Ummalqura to Gregorian
```dart
  //From Ummalqura to Gregorian
  var g_date = HijriCalendar();
  print(g_date.hijriToGregorian(1415, 7, 27)); //1994-12-29 00:00:00.000
```
  ##### Format
```dart
  var _format = HijriCalendar.now();
  print(_format.fullDate()); //Thulatha, Ramadan 14, 1439 h
  print(_format.toFormat("mm dd yy")); //09 14 39
```
  ##### Compare

```dart
  //Suppose current hijri data is: Thulatha, Ramadan 14, 1439 h
  print(_today.isAfter(1440, 11, 12)); // false
  print(_today.isBefore(1440, 11, 12)); // true
  print(_today.isAtSameMomentAs(1440, 11, 12)); // false

  ```

