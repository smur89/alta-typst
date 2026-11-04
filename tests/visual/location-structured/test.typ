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
//
// No reference images: `_format-location` (tests/unit/fields.typ) pins
// the joined text, and the maps link, built from the same string as
// the displayed value, shows each case reaching the contact bar.

#import "/lib.typ": alta
#import "/tests/visual/_links.typ": assert-links

#alta((
  basics: (
    name: "String Form",
    label: "Legacy plain-string location",
    email: "string@example.com",
    location: "Dublin, Ireland",
  ),
))
#assert-links((
  "mailto:string@example.com",
  "https://www.google.com/maps?q=Dublin%2C%20Ireland",
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
#assert-links((
  "mailto:full@example.com",
  "https://www.google.com/maps?q=Dublin%2C%20Leinster%2C%20IE",
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
#assert-links((
  "mailto:partial@example.com",
  "https://www.google.com/maps?q=Z%C3%BCrich%2C%20CH",
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
#assert-links((
  "mailto:city@example.com",
  "https://www.google.com/maps?q=Tokyo",
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
#assert-links((
  "mailto:postal@example.com",
  "https://www.google.com/maps?q=Dublin%2C%20Leinster%2C%20IE",
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
#assert-links(("mailto:empty@example.com",))
