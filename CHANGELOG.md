# Changelog

## 3.0.1
- Fix: `HijriCalendar.setLocal(...)` no longer silently corrupts the static
  locale when given an unregistered code; it now throws an `ArgumentError`
  listing the registered locales (resolves the
  "Null check operator used on a null value" crash reported in #25).
- Fix: `HijriCalendar.addLocale(...)` now validates that the supplied map
  contains the required keys (`long`, `short`, `days`, `short_days`) so
  incomplete locales can't be activated.
- New: `HijriCalendar.supportedLocales` getter to introspect registered
  locale codes.
- Widen SDK upper bound to `<4.0.0`.
- Add `repository` and `issue_tracker` metadata to `pubspec.yaml`.

## 3.0.0
- nullsafety
- stricter types
- removed new keyword

## 2.0.3

- add new method to return month name and day of week name

## 2.0.2

- update README.md
 
## 2.0.0

- change ```ummAlquarCalendar``` to ```HijriCalendar```
- fix issues

## 1.0.1

- add days short name for Arabic
- Edit local method thanks @emawyas

## 1.0.0

- Change local

## 0.2.1

- Update sdk to Dart 2.0

## 0.0.1

- Initial version
