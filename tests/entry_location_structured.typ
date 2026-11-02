// `work[].location` and `volunteer[].location` accept JSON Resume's
// string-or-object form (1.5.0+): a plain string, or the shared
// `{address, postalCode, city, countryCode, region}` dict. The dict
// collapses to `city, region, countryCode` on the term row, exactly as
// `basics.location` does in the header; `address` / `postalCode` are
// accepted but not rendered. An empty string or an all-empty dict
// renders no location (no orphan icon).
//
// Entries, in order:
//   1. Work, string form — unchanged behaviour.
//   2. Work, full dict.
//   3. Work, city-only dict.
//   4. Work, dict with postal fields — accepted, not displayed.
//   5. Work, all-empty dict — date only, no location icon.
//   6. Work, empty string — date only, no location icon.
//   7. Volunteer, dict — the shared renderer covers it too.

#import "../lib.typ": alta

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
