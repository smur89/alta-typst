// `basics.url` is JSON Resume's canonical "personal homepage" field —
// rendered in the contact bar with the `link` icon, alongside the
// other entries, and participating in `preferences.linkContactInfo`
// per-channel control under the `"url"` key. Three documents cover
// the relevant shapes:
//
//   1. Bare `basics.url` — rendered as a deep link (default).
//   2. `linkContactInfo: (url: false)` — homepage shown as plain text;
//      other channels stay linked.
//   3. `basics.url` alongside a `basics.profiles` "Website" entry —
//      both render (the template doesn't dedupe; semantically distinct
//      "my homepage" vs "a Website profile entry").

#import "../lib.typ": alta

#let cv = (basics: (
  name: "Jane Doe",
  label: "Software Engineer",
  email: "jane@example.com",
  phone: "+353 1 555 0100",
  location: "Dublin, Ireland",
  url: "https://janedoe.dev",
  profiles: (
    (network: "GitHub", username: "janedoe", url: "https://github.com/janedoe"),
  ),
))

#alta(cv)

#pagebreak()

#alta(cv, preferences: (linkContactInfo: (url: false)))

#pagebreak()

#alta((basics: (
  name: "Jane Doe",
  label: "Homepage + Website profile",
  email: "jane@example.com",
  url: "https://janedoe.dev",
  profiles: (
    (network: "Website", username: "janedoe.dev", url: "https://janedoe.dev"),
  ),
)))
