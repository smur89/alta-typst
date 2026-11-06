// Unit checks for internal/util/dates.typ: ISO parsing, the bracketed
// template engine and its missing-part elision, and date ranges,
// with the entry period reader in internal/data/cv.typ.

#import "/internal/util/dates.typ": (
  _apply-date-template, _date-span, _format-date, _iso-datetime,
  _parse-iso-date,
)
#import "/internal/data/cv.typ": _date-sides, _entry-period
#import "/internal/data/defaults.typ": _default-labels
#import "/internal/design/theme.typ": _default-theme
#import "/internal/util/values.typ": _join-present
#import "/tests/unit/_plain.typ": plain

#let labels = _default-labels
#let months = labels.months
#let long(v) = _format-date(v, "long", months)

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

// _apply-date-template: tokens, modifiers, and separator elision when
// a part is missing.
#let parts(s) = _parse-iso-date(s)
#assert.eq(
  _apply-date-template("[day]/[month]/[year]", parts("2024-06-05"), months),
  "05/06/2024",
)
#assert.eq(
  _apply-date-template(
    "[day padding:none] [month repr:long] [year]",
    parts("2024-06-05"),
    months,
  ),
  "5 Jun 2024",
)
#assert.eq(
  _apply-date-template("[day]/[month]/[year]", parts("2024-06"), months),
  "06/2024",
)
#assert.eq(
  _apply-date-template(
    "[day] · [month repr:short] [year]",
    parts("2024"),
    months,
  ),
  "2024",
)
#assert.eq(
  _apply-date-template("[month repr:numerical]", parts("2024-06"), months),
  "06",
)
// Short month names slice by grapheme, so a localised name starting
// with a multi-byte character doesn't split mid-character.
#let german = labels.months.slice(0, 2) + ("März",) + labels.months.slice(3)
#assert.eq(
  _apply-date-template(
    "[month repr:short]",
    parts("2024-03"),
    german,
  ),
  "Mär",
)

// _format-date: named formats, `iso` passthrough, closures, and
// verbatim passthrough of non-ISO strings.
#assert.eq(_format-date("2024-06", "long", months), "Jun 2024")
#assert.eq(_format-date("2024-06-15", "short", months), "15/06/2024")
#assert.eq(_format-date("2024-06", "iso", months), "2024-06")
#assert.eq(
  _format-date("2024-06", p => str(p.year) + "Q2", months),
  "2024Q2",
)
#assert.eq(_format-date("Jan 2022", "long", months), "Jan 2022")
#assert.eq(_format-date("", "long", months), "")

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
