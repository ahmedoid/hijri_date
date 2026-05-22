library hijri;

import 'package:hijri/digits_converter.dart';

import 'hijri_array.dart';

/// Per-locale configuration: month and weekday names, plus optional digit
/// substitution and a default format string.
///
/// Register a custom locale with [HijriCalendar.addLocale] and activate it
/// either globally via [HijriCalendar.setLocal] or per-instance by passing
/// the `locale` parameter to a constructor.
class HijriLocale {
  /// 1-based map of long month names (1 = Muharram .. 12 = Dhu al-Hijja).
  final Map<int, String> longMonths;

  /// 1-based map of short month names.
  final Map<int, String> shortMonths;

  /// Weekday names. Uses Dart's `DateTime.weekday` convention with
  /// 1 = Monday .. 6 = Saturday, and 7 = Sunday.
  final Map<int, String> days;

  /// Short weekday names. Same key convention as [days].
  final Map<int, String> shortDays;

  /// Optional 10-character digit set used to render numeric tokens
  /// (`dd`, `mm`, `yyyy`). When null, Western 0-9 digits are used.
  /// Common presets: [DigitsConverter.arabicIndicNumerals] (Arabic),
  /// [DigitsConverter.extendedArabicIndicNumerals] (Urdu, Persian).
  final List<String>? digits;

  /// Default format string used by [HijriCalendar.toString]. Defaults to
  /// `dd/mm/yyyy`. Use `yyyy/mm/dd` (or any combination of supported tokens)
  /// for right-to-left locales that prefer year-first ordering.
  final String defaultFormat;

  const HijriLocale({
    required this.longMonths,
    required this.shortMonths,
    required this.days,
    required this.shortDays,
    this.digits,
    this.defaultFormat = 'dd/mm/yyyy',
  });
}

class HijriCalendar {
  // ===== Built-in locales =====

  static const HijriLocale _enLocale = HijriLocale(
    longMonths: monthNames,
    shortMonths: monthShortNames,
    days: wdNames,
    shortDays: shortWdNames,
  );

  static const HijriLocale _arLocale = HijriLocale(
    longMonths: arMonthNames,
    shortMonths: arMonthShortNames,
    days: arWkNames,
    shortDays: arShortWdNames,
    digits: DigitsConverter.arabicIndicNumerals,
    defaultFormat: 'yyyy/mm/dd',
  );

  static const HijriLocale _trLocale = HijriLocale(
    longMonths: trMonthNames,
    shortMonths: trMonthShortNames,
    days: trWkNames,
    shortDays: trShortWdNames,
  );

  static final Map<String, HijriLocale> _local = {
    'en': _enLocale,
    'ar': _arLocale,
    'tr': _trLocale,
  };

  /// The locale code used when a [HijriCalendar] is constructed without an
  /// explicit `locale` parameter. Mutated by [setLocal]. Defaults to `'en'`.
  static String defaultLocale = 'en';

  /// This instance's locale code. Each instance carries its own locale so
  /// changing the global default doesn't affect existing instances. Assigning
  /// an unregistered locale throws [ArgumentError].
  String get locale => _locale;
  set locale(String value) {
    _requireRegistered(value);
    _locale = value;
  }
  late String _locale;

  // ===== Instance state =====

  late int lengthOfMonth;
  int hDay = 1;
  late int hMonth;
  late int hYear;
  int? wkDay;
  late String longMonthName;
  late String shortMonthName;
  late String dayWeName;
  Map<int, int>? adjustments;

  // ===== Locale management =====

  /// Returns the list of currently registered locale codes (built-in plus
  /// any added via [HijriCalendar.addLocale]).
  static List<String> get supportedLocales => _local.keys.toList();

  /// Sets the global [defaultLocale] used by new instances that don't supply
  /// their own. Throws [ArgumentError] if [locale] is not registered.
  static void setLocal(String locale) {
    _requireRegistered(locale);
    defaultLocale = locale;
  }

  /// Registers a new locale (or replaces an existing one).
  static void addLocale(String code, HijriLocale localeData) {
    _local[code] = localeData;
  }

  static void _requireRegistered(String locale) {
    if (!_local.containsKey(locale)) {
      throw ArgumentError.value(
        locale,
        'locale',
        "Locale is not registered. Supported locales: "
            "${_local.keys.join(', ')}. "
            "Register a new one first with HijriCalendar.addLocale().",
      );
    }
  }

  HijriLocale get _activeLocale => _local[locale]!;

  // ===== Constructors =====

  HijriCalendar({String? locale}) {
    // Setter validates and assigns _locale.
    this.locale = locale ?? defaultLocale;
  }

  HijriCalendar.fromDate(DateTime date, {String? locale}) {
    this.locale = locale ?? defaultLocale;
    gregorianToHijri(date.year, date.month, date.day);
  }

  HijriCalendar.now({String? locale}) {
    this.locale = locale ?? defaultLocale;
    _now();
  }

  String _now() {
    DateTime today = DateTime.now();
    return gregorianToHijri(today.year, today.month, today.day);
  }

  // ===== Calendar math =====

  int getDaysInMonth(int year, int month) {
    int i = _getNewMoonMJDNIndex(year, month);
    return _ummalquraDataIndex(i)! - _ummalquraDataIndex(i - 1)!;
  }

  int _gMod(int n, int m) {
    // generalized modulo function (n mod m) also valid for negative values of n
    return ((n % m) + m) % m;
  }

  int _getNewMoonMJDNIndex(int hy, int hm) {
    int cYears = hy - 1, totalMonths = (cYears * 12) + 1 + (hm - 1);
    return totalMonths - 16260;
  }

  int lengthOfYear({int? year = 0}) {
    int total = 0;
    if (year == 0) year = this.hYear;
    for (int m = 1; m <= 12; m++) {
      total += getDaysInMonth(year!, m);
    }
    return total;
  }

  DateTime hijriToGregorian(year, month, day) {
    int iy = year;
    int im = month;
    int id = day;
    int ii = iy - 1;
    int iln = (ii * 12) + 1 + (im - 1);
    int i = iln - 16260;
    int mcjdn = id + _ummalquraDataIndex(i - 1)! - 1;
    int cjdn = mcjdn + 2400000;
    return julianToGregorian(cjdn);
  }

  DateTime julianToGregorian(julianDate) {
    //source from: http://keith-wood.name/calendars.html
    int z = (julianDate + 0.5).floor();
    int a = ((z - 1867216.25) / 36524.25).floor();
    a = z + 1 + a - (a / 4).floor();
    int b = a + 1524;
    int c = ((b - 122.1) / 365.25).floor();
    int d = (365.25 * c).floor();
    int e = ((b - d) / 30.6001).floor();
    int day = b - d - (e * 30.6001).floor();
    //var wd = _gMod(julianDate + 1, 7) + 1;
    int month = e - (e > 13.5 ? 13 : 1);
    int year = c - (month > 2.5 ? 4716 : 4715);
    if (year <= 0) {
      year--;
    } // No year zero
    return DateTime(year, (month), day);
  }

  String gregorianToHijri(int pYear, int pMonth, int pDay) {
    //This code the modified version of R.H. van Gent Code, it can be found at http://www.staff.science.uu.nl/~gent0113/islam/ummalqura.htm
    int day = (pDay);
    int month = (pMonth);
    int year = (pYear);

    int m = month;
    int y = year;

    if (m < 3) {
      y -= 1;
      m += 12;
    }

    int a = (y / 100).floor();
    int jgc = a - (a / 4.0).floor() - 2;

    int cjdn = (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        day -
        jgc -
        1524;

    a = ((cjdn - 1867216.25) / 36524.25).floor();
    jgc = a - (a / 4.0).floor() + 1;
    int b = cjdn + jgc + 1524;
    int c = ((b - 122.1) / 365.25).floor();
    int d = (365.25 * c).floor();
    month = ((b - d) / 30.6001).floor();
    day = (b - d) - (30.6001 * month).floor();

    if (month > 13) {
      c += 1;
      month -= 12;
    }

    month -= 1;
    year = c - 4716;

    int mcjdn = cjdn - 2400000;

    int i;
    for (i = 0; i < ummAlquraDateArray.length; i++) {
      if (_ummalquraDataIndex(i)! > mcjdn) break;
    }

    int iln = i + 16260;
    int ii = ((iln - 1) / 12).floor();
    int iy = ii + 1;
    int im = iln - 12 * ii;
    int id = mcjdn - _ummalquraDataIndex(i - 1)! + 1;
    int ml = _ummalquraDataIndex(i)! - _ummalquraDataIndex(i - 1)!;
    lengthOfMonth = ml;
    int wd = _gMod(cjdn + 1, 7);

    wkDay = wd == 0 ? 7 : wd;
    return hDate(iy, im, id);
  }

  String hDate(int year, int month, int day) {
    final loc = _activeLocale;
    this.hYear = year;
    this.hMonth = month;
    this.longMonthName = loc.longMonths[month]!;
    this.dayWeName = loc.days[wkDay]!;
    this.shortMonthName = loc.shortMonths[month]!;
    this.hDay = day;
    return format(this.hYear, this.hMonth, this.hDay, "dd/mm/yyyy");
  }

  // ===== Formatting =====

  String toFormat(String format) {
    return this.format(this.hYear, this.hMonth, this.hDay, format);
  }

  // Token regex for format(). Longest-first ordering ensures e.g. "DDDD"
  // takes precedence over "DD", and "yyyy" over "yy".
  static final RegExp _formatTokenRegex =
      RegExp(r'DDDD|DD|MMMM|MM|yyyy|yy|mm|m|dd|d');

  String _digits(int n) {
    final d = _activeLocale.digits;
    if (d == null) return n.toString();
    return DigitsConverter.convert(n, d);
  }

  String format(year, month, day, format) {
    final loc = _activeLocale;
    final dayString = _digits(day);
    final monthString = _digits(month);
    final yearString = _digits(year);

    // Single-pass tokenizer: each token in the format string is matched once,
    // by region (no cross-token interference), and substituted with the
    // corresponding value. Replaces the previous sequential replaceFirst
    // implementation, which corrupted day names containing lowercase Latin
    // m/d/y characters (e.g. Indonesian "Jum'at" became "Ju12'at").
    return (format as String)
        .replaceAllMapped(_formatTokenRegex, (Match match) {
      switch (match.group(0)) {
        case 'DDDD':
          return loc.days[wkDay ?? weekDay()] ?? '';
        case 'DD':
          return loc.shortDays[wkDay ?? weekDay()] ?? '';
        case 'MMMM':
          return loc.longMonths[month] ?? '';
        case 'MM':
          return loc.shortMonths[month] ?? '';
        case 'yyyy':
          return yearString;
        case 'yy':
          // Last 2 chars of the (possibly digit-converted) year string.
          return yearString.length >= 2
              ? yearString.substring(yearString.length - 2)
              : yearString;
        case 'mm':
        case 'm':
          return monthString;
        case 'dd':
        case 'd':
          return dayString;
        default:
          return match.group(0)!;
      }
    });
  }

  // ===== Comparisons =====

  bool isBefore(int year, int month, int day) {
    return hijriToGregorian(hYear, hMonth, hDay).millisecondsSinceEpoch <
        hijriToGregorian(year, month, day).millisecondsSinceEpoch;
  }

  bool isAfter(int year, int month, int day) {
    return hijriToGregorian(hYear, hMonth, hDay).millisecondsSinceEpoch >
        hijriToGregorian(year, month, day).millisecondsSinceEpoch;
  }

  bool isAtSameMomentAs(int year, int month, int day) {
    return hijriToGregorian(hYear, hMonth, hDay).millisecondsSinceEpoch ==
        hijriToGregorian(year, month, day).millisecondsSinceEpoch;
  }

  // ===== Arithmetic =====

  /// Returns a new [HijriCalendar] [months] months after this one.
  /// Pass a negative value to subtract. Days are clamped to the new month's
  /// length (e.g. 30 Muharram + 1 month -> 29 Safar when Safar has 29 days).
  HijriCalendar addMonths(int months) {
    final am = (hYear - 1) * 12 + (hMonth - 1) + months;
    // Floor-divide am by 12 (Dart's ~/ truncates toward zero, which gives
    // wrong results for negative dividends).
    final newYearIndex = am >= 0 ? am ~/ 12 : -((-am + 11) ~/ 12);
    final yr = newYearIndex + 1;
    final mn = am - newYearIndex * 12 + 1;
    final maxDay = getDaysInMonth(yr, mn);
    final newDay = hDay > maxDay ? maxDay : hDay;
    return HijriCalendar.fromDate(hijriToGregorian(yr, mn, newDay),
        locale: locale);
  }

  /// Returns a new [HijriCalendar] [days] days after this one.
  /// Pass a negative value to subtract.
  HijriCalendar addDays(int days) {
    final greg =
        hijriToGregorian(hYear, hMonth, hDay).add(Duration(days: days));
    return HijriCalendar.fromDate(greg, locale: locale);
  }

  // ===== Adjustments =====

  void setAdjustments(Map<int, int> adj) {
    adjustments = adj;
  }

  int? _ummalquraDataIndex(int index) {
    if (index < 0 || index >= ummAlquraDateArray.length) {
      throw ArgumentError(
          "Valid date should be between 1356 AH (14 March 1937 CE) to 1500 AH (16 November 2077 CE)");
    }

    if (adjustments != null && adjustments!.containsKey(index + 16260)) {
      return adjustments![index + 16260];
    }

    return ummAlquraDateArray[index];
  }

  int weekDay() {
    DateTime wkDay = hijriToGregorian(hYear, hMonth, hDay);
    return wkDay.weekday;
  }

  @override
  String toString() {
    return format(hYear, hMonth, hDay, _activeLocale.defaultFormat);
  }

  List<int?> toList() => [hYear, hMonth, hDay];

  String fullDate() {
    return format(hYear, hMonth, hDay, "DDDD, MMMM dd, yyyy");
  }

  bool isValid() {
    if (validateHijri(this.hYear, this.hMonth, this.hDay)) {
      if (this.hDay <= getDaysInMonth(this.hYear, this.hMonth)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool validateHijri(int year, int month, int day) {
    if (month < 1 || month > 12) return false;

    if (day < 1 || day > 30) return false;
    return true;
  }

  String getLongMonthName() => _activeLocale.longMonths[hMonth]!;

  String getShortMonthName() => _activeLocale.shortMonths[hMonth]!;

  String getDayName() => _activeLocale.days[wkDay]!;

  /// All month names in the active locale (long form), keyed by 1-based month.
  Map<int, String> getMonths() => _activeLocale.longMonths;

  /// Map of day-number -> day name for a given Hijri [month]/[year].
  Map<int, String> getMonthDays(int month, int year) {
    final calender = <int, String>{};
    int d = hijriToGregorian(year, month, 1).weekday;
    final daysInMonth = getDaysInMonth(year, month);
    for (int i = 1; i <= daysInMonth; i++) {
      calender.putIfAbsent(i, () => _activeLocale.days[d]!);
      d = d < 7 ? d + 1 : 1;
    }
    return calender;
  }
}
