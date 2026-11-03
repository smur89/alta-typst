// The icon vocabulary: logical icon names and the FontAwesome glyphs
// they draw, the profile networks the contact bar recognises, and the
// built-in publication icons. Data, so validation can check names
// without importing the renderer (`icons.typ`).

// Free Solid glyphs (https://fontawesome.com/search). Keys are part of
// the public `icon(...)` API: renaming one is a breaking change.
#let _utility-icons = (
  book: "book",
  calendar: "calendar",
  email: "envelope",
  file: "file",
  location: "location-dot",
  microphone: "microphone",
  newspaper: "newspaper",
  phone: "phone",
)

// Keys are lowercase to match `lower(profile.network)` in
// `header.typ`. Brand marks, except `link` and `website` (see
// `_solid-names`).
#let _network-icons = (
  bluesky: "bluesky",
  github: "github",
  gitlab: "gitlab",
  link: "link",
  linkedin: "linkedin",
  mastodon: "mastodon",
  medium: "medium",
  stackoverflow: "stack-overflow",
  twitter: "twitter",
  website: "globe",
)

// `link` and `website` are profile networks but not brand marks.
#let _solid-names = _utility-icons.keys() + ("link", "website")

#let _icon-glyphs = _utility-icons + _network-icons

#let _profile-networks = _network-icons.keys()

// `publications[].type` codes → the icon leading their subheading:
// the `preferences.publicationIcons` default.
#let _publication-icons = (
  article: "newspaper",
  book: "book",
  thesis: "book",
  talk: "microphone",
)

// Renamed networks → the key their icon still ships under. Keys are
// lowercase, as the lookup follows `lower(profile.network)`.
#let _network-aliases = (
  x: "twitter",
)
