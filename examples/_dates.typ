// Shared date helpers for the example CVs. Anchored to a single
// `today` constant — bump annually here and every relative date in
// every example rebases together.
//
// `ago(months:, years:, precision:)` returns an ISO date string;
// `precision` controls the printed shape so callers can mix
// year-only inputs with month- and day-precision inputs in the same
// CV. The lib's own date parser distinguishes the three shapes, so
// e.g. `precision: "year"` exercises the year-only render path.

#let today = datetime(year: 2026, month: 6, day: 14)

#let ago(months: 0, years: 0, precision: "month") = {
  let d = today - duration(days: 365 * years + 30 * months)
  let fmt = (
    year: "[year]",
    month: "[year]-[month]",
    day: "[year]-[month]-[day]",
  ).at(precision)
  d.display(fmt)
}
