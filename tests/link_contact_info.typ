// `preferences.linkContactInfo` accepts a boolean (apply uniformly) or
// a partial dict keyed by channel ("email", "phone", "location",
// "profiles"). Three documents exercise the relevant shapes:
//
//   1. Bool `false` — no channel linked; icons + plain text only.
//   2. Dict overriding two channels — phone + location render plain,
//      email + profiles stay linked.
//   3. Bool `true` (default behaviour, asserted explicitly) — every
//      channel linked.

#import "../lib.typ": alta

#let cv = (basics: (
  name: "Jane Doe",
  label: "Software Engineer",
  email: "jane@example.com",
  phone: "+353 1 555 0100",
  location: "Dublin, Ireland",
  profiles: (
    (network: "GitHub", username: "janedoe", url: "https://github.com/janedoe"),
  ),
))

#alta(cv, preferences: (linkContactInfo: false))

#pagebreak()

#alta(cv, preferences: (
  // Only phone + location go plain; email and the GitHub profile
  // stay linked. Omitted channels default to true.
  linkContactInfo: (phone: false, location: false),
))

#pagebreak()

#alta(cv, preferences: (linkContactInfo: true))
