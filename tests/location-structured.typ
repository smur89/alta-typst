// `basics.location` accepts either a plain string (legacy form) or a
// JSON Resume dict `{address, postalCode, city, countryCode, region}`.
// Dict-form fields are joined into a single line as
// `city, region, countryCode`, skipping any field that's missing or
// empty. `address` and `postalCode` are accepted (so a verbatim
// `resume.json` dict round-trips) but not rendered in the contact
// bar. The same joined string also drives the maps deep link, so
// display and link stay in sync.
//
// One document per case:
//   1. String form — unchanged behaviour.
//   2. Full dict — all three CV-relevant fields populated.
//   3. Partial dict — `city` + `countryCode` (no `region`).
//   4. City-only dict — single-field collapse.
//   5. Full JSON Resume dict including `address` + `postalCode` —
//      the postal fields are accepted but not displayed.
//   6. All-empty dict — no location row rendered (no orphan icon).
//   7. `work[].location` and `volunteer[].location` take the same
//      string-or-dict form (1.5.0+), collapsed the same way on the term
//      row. Entries: work in string form, a full dict, a city-only
//      dict, a dict with postal fields (accepted, not displayed), an
//      all-empty dict and an empty string (date only, no location
//      icon), then a volunteer dict (the shared renderer covers it too).

#import "../lib.typ": alta

#alta((
  basics: (
    name: "String Form",
    label: "Legacy plain-string location",
    email: "string@example.com",
    location: "Dublin, Ireland",
  ),
))

#pagebreak()

#alta((
  basics: (
    name: "Full Dict",
    label: "city, region, countryCode",
    email: "full@example.com",
    location: (city: "Dublin", region: "Leinster", countryCode: "IE"),
  ),
))

#pagebreak()

#alta((
  basics: (
    name: "Partial Dict",
    label: "city + countryCode (no region)",
    email: "partial@example.com",
    location: (city: "Zürich", countryCode: "CH"),
  ),
))

#pagebreak()

#alta((
  basics: (
    name: "City Only",
    label: "Single field collapse",
    email: "city@example.com",
    location: (city: "Tokyo"),
  ),
))

#pagebreak()

#alta((
  basics: (
    name: "Postal Fields Ignored",
    label: "address + postalCode accepted but unrendered",
    email: "postal@example.com",
    location: (
      address: "1 Example Street",
      postalCode: "D02 XY00",
      city: "Dublin",
      region: "Leinster",
      countryCode: "IE",
    ),
  ),
))

#pagebreak()

#alta((
  basics: (
    name: "All Empty Dict",
    label: "no location row emitted",
    email: "empty@example.com",
    location: (city: "", region: "", countryCode: ""),
  ),
))

#pagebreak()

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  work: (
    (
      name: "String Form",
      position: "Engineer",
      startDate: "2024",
      location: "Dublin, Ireland",
    ),
    (
      name: "Full Dict",
      position: "Engineer",
      startDate: "2023",
      location: (city: "Dublin", region: "Leinster", countryCode: "IE"),
    ),
    (
      name: "City Only",
      position: "Engineer",
      startDate: "2022",
      location: (city: "Tokyo"),
    ),
    (
      name: "Postal Fields Ignored",
      position: "Engineer",
      startDate: "2021",
      location: (
        address: "1 Example Street",
        postalCode: "D02 XY00",
        city: "Dublin",
        countryCode: "IE",
      ),
    ),
    (
      name: "All Empty Dict",
      position: "Engineer",
      startDate: "2020",
      location: (city: "", region: "", countryCode: ""),
    ),
    (
      name: "Empty String",
      position: "Engineer",
      startDate: "2019",
      location: "",
    ),
  ),
  volunteer: (
    (
      organization: "Coding Club",
      position: "Mentor",
      startDate: "2018",
      location: (city: "Berlin", countryCode: "DE"),
    ),
  ),
))
