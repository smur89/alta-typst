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

#import "../lib.typ": alta

#alta((basics: (
  name: "String Form",
  label: "Legacy plain-string location",
  email: "string@example.com",
  location: "Dublin, Ireland",
)))

#pagebreak()

#alta((basics: (
  name: "Full Dict",
  label: "city, region, countryCode",
  email: "full@example.com",
  location: (city: "Dublin", region: "Leinster", countryCode: "IE"),
)))

#pagebreak()

#alta((basics: (
  name: "Partial Dict",
  label: "city + countryCode (no region)",
  email: "partial@example.com",
  location: (city: "Zürich", countryCode: "CH"),
)))

#pagebreak()

#alta((basics: (
  name: "City Only",
  label: "Single field collapse",
  email: "city@example.com",
  location: (city: "Tokyo"),
)))

#pagebreak()

#alta((basics: (
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
)))

#pagebreak()

#alta((basics: (
  name: "All Empty Dict",
  label: "no location row emitted",
  email: "empty@example.com",
  location: (city: "", region: "", countryCode: ""),
)))
