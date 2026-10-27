// `labels.pageNumber` / `labels.documentTitle` — the auto page footer
// and PDF Title rendered from translated templates. German puts the
// name after the prefix ("Lebenslauf — Jane Doe"), so this also pins
// that placeholders, not fixed prefixes, drive word order.
//
// Two `alta()` calls share one document, so `counter(page).final()`
// is 2 and the auto footer renders on both pages ("Seite 1 von 2",
// "Seite 2 von 2") without needing a CV long enough to overflow.

#import "../lib.typ": alta

#let labels = (
  lang: "de",
  work: "Berufserfahrung",
  pageNumber: "Seite {current} von {total}",
  documentTitle: "Lebenslauf — {name}",
)

#let cv = (
  basics: (
    name: "Jane Doe",
    label: "Softwareentwicklerin",
    email: "jane@example.com",
    location: "Berlin, Deutschland",
  ),
  work: (
    (
      name: "Acme GmbH",
      position: "Senior Engineer",
      location: "Berlin",
      startDate: "Jan 2022",
      highlights: ([Plattform-Migration geleitet.],),
    ),
  ),
)

#alta(cv, labels: labels, preferences: (pageFooter: "auto"))
#alta(cv, labels: labels, preferences: (pageFooter: "auto"))
