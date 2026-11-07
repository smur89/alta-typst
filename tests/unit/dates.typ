// Unit checks for internal/util/dates.typ: ISO parsing and date
// ranges, with the entry period reader in internal/data/cv.typ. How a
// date reads, formats and templates, is `adapter.format-date`'s, in
// adapter.typ.

#import "/lib.typ": adapter
#import "/internal/util/dates.typ": _date-span, _iso-datetime, _parse-iso-date
#import "/internal/data/cv.typ": _date-sides, _entry-period
#import "/internal/data/defaults.typ": _default-labels
#import "/internal/design/theme.typ": _default-theme
#import "/internal/util/values.typ": _join-present
#import "/tests/unit/_plain.typ": plain

#let labels = _default-labels
#let long = adapter.format-date

// _parse-iso-date: strict shape, calendar-range months and days.
#assert.eq(_parse-iso-date("2024"), (year: 2024, month: none, day: none))
#assert.eq(_parse-iso-date("2024-06"), (year: 2024, month: 6, day: none))
#assert.eq(_parse-iso-date("2024-06-15"), (year: 2024, month: 6, day: 15))
#for s in ("2024-13", "2024-06-32", "2024-6", "Jan 2022", 2024) {
  assert.eq(_parse-iso-date(s), none, message: repr(s))
}

// _iso-datetime: full dates only, timestamps keep their date prefix,
// impossible calendar dates drop out instead of panicking.
#assert.eq(_iso-datetime("2024-02-29"), datetime(year: 2024, month: 2, day: 29))
#assert.eq(
  _iso-datetime("2024-06-12T10:00:00Z"),
  datetime(year: 2024, month: 6, day: 12),
)
#assert.eq(
  _iso-datetime("2024-06-12 10:00:00"),
  datetime(year: 2024, month: 6, day: 12),
)
#assert.eq(_iso-datetime("2023-02-29"), none)
#assert.eq(_iso-datetime("1900-02-29"), none)
#assert.eq(_iso-datetime("2000-02-29"), datetime(year: 2000, month: 2, day: 29))
#assert.eq(_iso-datetime("2024-06"), none)
#assert.eq(_iso-datetime(none), none)

// _date-span / _date-sides / _entry-period: a range's two sides, an absent one
// `none`; a missing end of an entry's period reads `labels.present`,
// and an undated entry has neither. Joined as `_range` would, a
// missing side drops out with its dash.
#let join-range(sides) = _join-present(
  sides,
  _default-theme.separator.range,
)
#assert.eq(plain(join-range(_date-span("2020", "2022", long))), "2020 – 2022")
#assert.eq(plain(join-range(_date-span("2020", none, long))), "2020")
#assert.eq(_date-span(none, none, long), (none, none))
#assert.eq(join-range(_date-span(none, none, long)), none)
#assert.eq(
  plain(join-range(_entry-period((start-date: "2020"), long, labels.present))),
  "2020 – " + labels.present,
)
#assert.eq(_date-sides(none, "", long, labels.present), (none, none))
