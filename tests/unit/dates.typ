// Unit checks for internal/dates.typ: ISO parsing, the bracketed
// template engine and its missing-part elision, and date ranges.

#import "/internal/dates.typ": (
  _apply_date_template, _format_date, _format_date_range, _format_date_span,
  _iso_datetime, _parse_iso_date,
)
#import "/internal/defaults.typ": _default_labels
#import "_plain.typ": plain

#let labels = _default_labels
#let prefs(format) = (dateFormat: format)

// _parse_iso_date: strict shape, calendar-range months and days.
#assert.eq(_parse_iso_date("2024"), (year: 2024, month: none, day: none))
#assert.eq(_parse_iso_date("2024-06"), (year: 2024, month: 6, day: none))
#assert.eq(_parse_iso_date("2024-06-15"), (year: 2024, month: 6, day: 15))
#assert.eq(_parse_iso_date("2024-13"), none)
#assert.eq(_parse_iso_date("2024-06-32"), none)
#assert.eq(_parse_iso_date("2024-6"), none)
#assert.eq(_parse_iso_date("Jan 2022"), none)
#assert.eq(_parse_iso_date(2024), none)

// _iso_datetime: full dates only, timestamps keep their date prefix,
// impossible calendar dates drop out instead of panicking.
#assert.eq(_iso_datetime("2024-02-29"), datetime(year: 2024, month: 2, day: 29))
#assert.eq(
  _iso_datetime("2024-06-12T10:00:00Z"),
  datetime(year: 2024, month: 6, day: 12),
)
#assert.eq(
  _iso_datetime("2024-06-12 10:00:00"),
  datetime(year: 2024, month: 6, day: 12),
)
#assert.eq(_iso_datetime("2023-02-29"), none)
#assert.eq(_iso_datetime("1900-02-29"), none)
#assert.eq(_iso_datetime("2000-02-29"), datetime(year: 2000, month: 2, day: 29))
#assert.eq(_iso_datetime("2024-06"), none)
#assert.eq(_iso_datetime(none), none)

// _apply_date_template: tokens, modifiers, and separator elision when
// a part is missing.
#let parts(s) = _parse_iso_date(s)
#assert.eq(
  _apply_date_template("[day]/[month]/[year]", parts("2024-06-05"), labels),
  "05/06/2024",
)
#assert.eq(
  _apply_date_template(
    "[day padding:none] [month repr:long] [year]",
    parts("2024-06-05"),
    labels,
  ),
  "5 Jun 2024",
)
#assert.eq(
  _apply_date_template("[day]/[month]/[year]", parts("2024-06"), labels),
  "06/2024",
)
#assert.eq(
  _apply_date_template(
    "[day] · [month repr:short] [year]",
    parts("2024"),
    labels,
  ),
  "2024",
)
#assert.eq(
  _apply_date_template("[month repr:numerical]", parts("2024-06"), labels),
  "06",
)
// Short month names slice by grapheme, so a localised name starting
// with a multi-byte character doesn't split mid-character.
#assert.eq(
  _apply_date_template(
    "[month repr:short]",
    parts("2024-03"),
    labels + (months: labels.months.enumerate().map(((i, m)) => if i == 2 { "März" } else { m })),
  ),
  "Mär",
)

// _format_date: named formats, `iso` passthrough, closures, and
// verbatim passthrough of non-ISO strings.
#assert.eq(_format_date("2024-06", prefs("long"), labels), "Jun 2024")
#assert.eq(_format_date("2024-06-15", prefs("short"), labels), "15/06/2024")
#assert.eq(_format_date("2024-06", prefs("iso"), labels), "2024-06")
#assert.eq(
  _format_date("2024-06", prefs(p => str(p.year) + "Q2"), labels),
  "2024Q2",
)
#assert.eq(_format_date("Jan 2022", prefs("long"), labels), "Jan 2022")
#assert.eq(_format_date("", prefs("long"), labels), "")

// _format_date_span / _format_date_range: a missing side drops out
// with its dash; a missing end of a range reads `labels.present`.
#assert.eq(
  plain(_format_date_span("2020", "2022", prefs("long"), labels)),
  "2020 – 2022",
)
#assert.eq(plain(_format_date_span("2020", none, prefs("long"), labels)), "2020")
#assert.eq(_format_date_span(none, none, prefs("long"), labels), none)
#assert.eq(
  plain(_format_date_range((startDate: "2020"), prefs("long"), labels)),
  "2020 – " + labels.present,
)
#assert.eq(_format_date_range((:), prefs("long"), labels), none)
