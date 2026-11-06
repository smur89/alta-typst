// Exercises preferences.date-format across every supported variant:
// - default "long" formatter on ISO inputs (yyyy / yyyy-mm / yyyy-mm-dd)
// - non-ISO strings pass through verbatim (back-compat)
// - "short" formatter (dd/mm/yyyy and mm/yyyy)
// - "iso" passthrough
// - closure formatter (caller-supplied date => str)
// - bracketed template (Typst `datetime.display()`-style tokens)
// - labels.months override (German abbreviations) feeding "long"
// - every shape of the range: both dates, no end ("Present"), no
//   start (no leading dash), neither (no term row)
//
// Each invocation is a separate alta() call so a panic in one variant
// doesn't mask the others. Multi-page output (one CV per preference)
// is expected.

#import "../lib.typ": alta

#let base-cv = (
  basics: (name: "Date Format Demo", email: "demo@example.com"),
  work: (
    (
      name: "ISO Year-Month Ltd",
      position: "Engineer",
      startDate: "2020-01",
      endDate: "2021-12",
      highlights: ([Both ISO yyyy-mm dates.],),
    ),
    (
      name: "ISO Year-Month-Day Inc",
      position: "Engineer",
      startDate: "2022-03-15",
      // endDate omitted → "Present"
      highlights: ([Full ISO date, current role.],),
    ),
    (
      name: "Year Only Corp",
      position: "Engineer",
      startDate: "2017",
      endDate: "2019",
      highlights: ([Year-only ISO dates.],),
    ),
    (
      name: "Pre-formatted Co",
      position: "Engineer",
      startDate: "Jan 2015",
      endDate: "Dec 2016",
      highlights: ([Pre-formatted strings pass through verbatim.],),
    ),
  ),
  education: (
    (
      institution: "Example University",
      studyType: "B.Sc. Computer Science",
      startDate: "2014",
      endDate: "2017",
    ),
  ),
  awards: (
    (title: "Best Paper", awarder: "ACM", date: "2023-06"),
  ),
  publications: (
    (name: "ISO Dates Considered Useful", releaseDate: "2024-06-15"),
  ),
)

// 1. Default "long" formatter — ISO inputs get nice names, non-ISO
//    inputs stay verbatim. No preferences override needed.
#alta(base-cv)

#pagebreak()

// 2. "short" formatter — numeric mm/yyyy and dd/mm/yyyy.
#alta(base-cv, preferences: (date-format: "short"))

#pagebreak()

// 3. "iso" passthrough — every date renders exactly as supplied.
#alta(base-cv, preferences: (date-format: "iso"))

#pagebreak()

// 4. Closure formatter — caller emits a fully custom shape. Receives
//    a parsed (year, month?, day?) dict; must return a string.
#alta(base-cv, preferences: (
  date-format: parts => {
    if parts.month == none { return str(parts.year) }
    let mm = if parts.month < 10 { "0" + str(parts.month) } else {
      str(parts.month)
    }
    str(parts.year) + "/" + mm
  },
))

#pagebreak()

// 5. Bracketed template — Typst's `datetime.display()` syntax with the
//    same modifier vocabulary. Missing components (year-only inputs
//    miss month/day) substitute empty strings and the surrounding
//    separators are stripped so partials degrade gracefully.
#alta(base-cv, preferences: (
  date-format: "[day padding:none] [month repr:short] [year]",
))

#pagebreak()

// 5b. Bracketed template with `[month repr:long]` and `[day padding:zero]`
//     — exercises the localised-full-name path and the zero-padded day
//     variant, plus a non-ASCII middot separator that the new
//     unicode-aware separator-strip handles cleanly on partials.
#alta(base-cv, preferences: (
  date-format: "[day padding:zero] · [month repr:long] · [year]",
))

#pagebreak()

// 6. labels.months override (German abbreviations) feeding the default
//    "long" formatter — ISO inputs render with localised month names,
//    pre-formatted "Jan 2015" still passes through verbatim.
#alta(
  base-cv,
  labels: (
    months: (
      "Jan",
      "Feb",
      "Mär",
      "Apr",
      "Mai",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Okt",
      "Nov",
      "Dez",
    ),
    present: "Heute",
  ),
)

#pagebreak()

// 7. Every shape of the date range, on pre-formatted strings: both dates
//    (a range with an en dash), no endDate ("Present"), no startDate (no
//    leading dash), and neither (no term row).
#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  work: (
    (
      name: "Both Dates Ltd",
      position: "Engineer",
      startDate: "Jan 2020",
      endDate: "Dec 2021",
      highlights: ([Did things.],),
    ),
    (
      name: "Still Here Inc",
      position: "Engineer",
      startDate: "Jan 2022",
      // endDate omitted → "Present"
      highlights: ([Doing things.],),
    ),
    (
      name: "End Only Corp",
      position: "Engineer",
      endDate: "Mar 2019",
      highlights: ([Past role.],),
    ),
    (
      name: "Undated Co",
      position: "Engineer",
      highlights: ([No dates at all.],),
    ),
  ),
))
