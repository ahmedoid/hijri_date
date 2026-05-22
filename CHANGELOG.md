# Changelog

## 4.0.0-beta.1

This is a **breaking** pre-release. Pin with `hijri: ^4.0.0-beta.1` to opt in
while we stabilise the API.

### Breaking changes
- **Locale is now per-instance.** Each `HijriCalendar` carries its own
  `locale` field, set via the new `locale:` named parameter on `now()`,
  `fromDate()`, and the default constructor. Mutating the global default
  (via `setLocal`) no longer affects existing instances. The static field
  `HijriCalendar.language` is renamed to `HijriCalendar.defaultLocale`.
- **`HijriCalendar.setLocal(...)` is now `static void`**, not a factory. It
  sets the global default; the returned instance was almost always discarded
  anyway. Throws `ArgumentError` for unregistered locales.
- **`HijriCalendar.addLocale(code, ...)`** now takes a typed `HijriLocale`
  instance instead of a `Map<String, Map<int, String>>`. All four name maps
  are required by the constructor; the new `digits` and `defaultFormat`
  fields are optional.
- **English month names updated:** `Rabi' Al-Thani` → `Rabi' Al-Akhir`,
  `Jumada Al-Thani` → `Jumada Al-Akhirah`, `Sha'aban` → `Sha'ban` (#7).
- **`HijriCalendar.addMonth(year, month)` removed** (the named constructor
  had broken semantics — `(1440, 12)` returned `12/1439`). Replaced by
  instance methods `addMonths(int)` and `addDays(int)`, both returning a
  fresh `HijriCalendar`.
- **`lengthOfYear` off-by-one corrected** — the loop iterated `m=0..11`
  which summed month 12 of the prior year plus months 1..11 of the target
  year. Now correctly sums months 1..12. Year 1356 no longer throws.
  Verified across the full 1356–1500 AH range against Gregorian-day-
  difference ground truth.
- **`format()` tokenizer rewritten** as a single-pass regex-based scanner.
  Day names containing lowercase Latin `m`/`d`/`y` are no longer corrupted
  by later token substitutions (e.g. Indonesian `Jum'at` was rendered as
  `Ju12'at`). The `else`-branch spurious substitution for `m` and `yy`
  is also gone.
- **`'ar'`-hardcoded behaviours removed.** Eastern Arabic digit conversion
  and the `yyyy/mm/dd` `toString()` order are now per-locale config on the
  `HijriLocale` (`digits` and `defaultFormat` fields). Adding Urdu, Persian,
  Pashto, etc. with correct digit rendering no longer requires touching the
  core source.

### Data corrections (#26 and related)
- **Jumada-I 1446** corrected from 30 → 29 days; **Jumada-II 1446** from
  29 → 30 days. Aligns with authoritative Umm al-Qura tables — verified
  against `al-habib.info` and `moment-hijri` upstream master.
- **Ramadan 1485** corrected from 30 → 29 days; **Shawwal 1485** from
  29 → 30 days. Syncs with `moment-hijri` upstream.

### New
- `HijriCalendar.supportedLocales` — list of registered locale codes.
- `HijriLocale` — typed locale config with optional `digits` (custom 10-
  character digit set) and `defaultFormat`.
- `DigitsConverter.arabicIndicNumerals` (Arabic) and
  `DigitsConverter.extendedArabicIndicNumerals` (Urdu, Persian, Pashto).
  `easternArabicNumerals` retained as deprecated alias.
- `DigitsConverter.convert(int, List<String>)` — convert to arbitrary
  digit set.
- `HijriCalendar.addMonths(int)` and `addDays(int)` — proper arithmetic,
  returning fresh instances; days clamped to month length.

### Migration: 3.x → 4.0.0

| 3.x | 4.0.0 |
|---|---|
| `HijriCalendar.setLocal('ar')` then `HijriCalendar.now()` | `HijriCalendar.now(locale: 'ar')` (or keep `setLocal` to change the default for *future* instances) |
| `HijriCalendar.language` | `HijriCalendar.defaultLocale` |
| `HijriCalendar.addLocale('id', {'long': ..., 'short': ..., 'days': ..., 'short_days': ...})` | `HijriCalendar.addLocale('id', HijriLocale(longMonths: ..., shortMonths: ..., days: ..., shortDays: ...))` |
| `HijriCalendar.addMonth(year, month)` | `HijriCalendar.fromDate(hijriToGregorian(year, month, 1))` or use `HijriCalendar.now().addMonths(n)` |
| Day names: `Rabi' Al-Thani`, `Jumada Al-Thani`, `Sha'aban` | `Rabi' Al-Akhir`, `Jumada Al-Akhirah`, `Sha'ban` |

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
