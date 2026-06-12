// Exercises preferences.dateFormat across the four supported variants:
// - default "long" formatter on ISO inputs (yyyy / yyyy-mm / yyyy-mm-dd)
// - non-ISO strings pass through verbatim (back-compat)
// - "short" formatter (dd/mm/yyyy and mm/yyyy)
// - "iso" passthrough
// - closure formatter (caller-supplied date => str)
// - labels.months override (German abbreviations) feeding "long"
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
#alta(base-cv, preferences: (dateFormat: "short"))

#pagebreak()

// 3. "iso" passthrough — every date renders exactly as supplied.
#alta(base-cv, preferences: (dateFormat: "iso"))

#pagebreak()

// 4. Closure formatter — caller emits a fully custom shape. Receives
//    a parsed (year, month?, day?) dict; must return a string.
#alta(base-cv, preferences: (
  dateFormat: parts => {
    if parts.month == none { return str(parts.year) }
    let mm = if parts.month < 10 { "0" + str(parts.month) } else { str(parts.month) }
    str(parts.year) + "/" + mm
  },
))

#pagebreak()

// 5. labels.months override (German abbreviations) feeding the default
//    "long" formatter — ISO inputs render with localised month names,
//    pre-formatted "Jan 2015" still passes through verbatim.
#alta(
  base-cv,
  labels: (
    months: ("Jan", "Feb", "Mär", "Apr", "Mai", "Jun",
             "Jul", "Aug", "Sep", "Okt", "Nov", "Dez"),
    present: "Heute",
  ),
)
