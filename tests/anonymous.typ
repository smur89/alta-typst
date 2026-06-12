// `preferences.anonymous: true` enables blind-review mode: the
// rendered header drops the name, photo, and contact bar, leaving
// only the label as the leading line. PDF metadata `title` and
// `author` are swapped for generic placeholders so the file itself
// can't unmask the candidate via its document properties.
//
// Three documents exercise the relevant shapes:
//
//   1. Anonymous on, fully-populated basics — name / photo /
//      contact bar should all be suppressed; label remains.
//   2. Anonymous on, no `label` — header collapses to nothing
//      (summary + sections still render).
//   3. Anonymous off (default, asserted explicitly) — every
//      identifying field renders normally.

#import "../lib.typ": alta

#let cv = (
  basics: (
    name: "Jane Doe",
    label: "Senior Software Engineer",
    summary: [Backend engineer with eight years' experience.],
    email: "jane@example.com",
    phone: "+353 1 555 0100",
    location: "Dublin, Ireland",
    url: "https://janedoe.dev",
    profiles: (
      (network: "GitHub", username: "janedoe", url: "https://github.com/janedoe"),
    ),
  ),
  work: (
    (
      name: "Acme Corp",
      position: "Senior Software Engineer",
      startDate: "Jan 2022",
      highlights: ([Led the platform migration.],),
    ),
  ),
)

#alta(cv, preferences: (anonymous: true))

#pagebreak()

#alta(
  (basics: (
    name: "Jane Doe",
    email: "jane@example.com",
    phone: "+353 1 555 0100",
  )),
  preferences: (anonymous: true),
)

#pagebreak()

#alta(cv, preferences: (anonymous: false))
