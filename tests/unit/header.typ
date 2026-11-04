// Unit checks for the header's data stages in sections/header.typ,
// including the QR URL resolution.

#import "/internal/util/values.typ": _display-url, _url-encode
#import "/internal/data/options.typ": _merge-options
#import "/sections/header.typ": (
  _contact-entries, _contact-rows, _header-image, _linked-contacts,
  _profile-entry, _resolve-link-config, _resolve-qr-url,
)

// _url-encode: RFC 3986 unreserved set kept, everything else
// percent-encoded by UTF-8 byte.
#assert.eq(_url-encode("AZaz09-._~"), "AZaz09-._~")
#assert.eq(_url-encode("Cork, Ireland"), "Cork%2C%20Ireland")
#assert.eq(_url-encode("Zürich"), "Z%C3%BCrich")
#assert.eq(_url-encode("京都"), "%E4%BA%AC%E9%83%BD")

// _resolve-link-config: a bool fans out to every channel; a dict
// overrides on top of all-true.
#assert.eq(
  _resolve-link-config(false),
  (email: false, phone: false, location: false, url: false, profiles: false),
)
#assert.eq(
  _resolve-link-config((phone: false)),
  (email: true, phone: false, location: true, url: true, profiles: true),
)

// _contact-entries: display order, dialable `tel:` URI, maps link,
// empty fields skipped.
#let entries = _contact-entries(
  (
    email: "jane@example.com",
    phone: "+353 (21) 123-4567",
    location: (city: "Cork", countryCode: "IE"),
    url: "",
  ),
  "https://maps.example/?q={q}",
)
#assert.eq(entries.map(e => e.channel), ("email", "phone", "location"))
#assert.eq(entries.at(0).url, "mailto:jane@example.com")
#assert.eq(entries.at(1).url, "tel:+353211234567")
#assert.eq(entries.at(1).value, "+353 (21) 123-4567")
#assert.eq(entries.at(2).url, "https://maps.example/?q=Cork%2C%20IE")
#assert.eq(
  _contact-entries((location: "Cork"), none).first().url,
  none,
)
#assert.eq(
  _contact-entries((location: "Cork"), none, location-alt: "Location")
    .first()
    .alt,
  "Location",
)

// _profile-entry: aliases resolve, `alt` keeps the user's spelling,
// a profile without `url` shows the username unlinked, one without a
// `username` shows its URL without the scheme but links the full URL.
#let x = _profile-entry((network: "X", username: "jane"))
#assert.eq((x.glyph, x.alt, x.value, x.url), ("twitter", "X", "jane", none))
#let gh = _profile-entry((network: "GitHub", url: "https://github.com/jane"))
#assert.eq(
  (gh.glyph, gh.value, gh.url),
  ("github", "github.com/jane", "https://github.com/jane"),
)

// _profile-entry with `profileIcons`: the network as written wins
// over its alias's key, which still covers the alias when the network
// itself is unmapped.
#let glyph(network, icons) = {
  _profile-entry(
    (network: network, username: "jane"),
    profile-icons: icons,
  ).glyph
}
#assert.eq(glyph("Kaggle", (kaggle: "kaggle")), "kaggle")
#assert.eq(glyph("X", (x: "x-twitter", twitter: "twitter")), "x-twitter")
#assert.eq(glyph("X", (twitter: "square-twitter")), "square-twitter")

// _display-url: scheme and trailing slash dropped, the rest kept.
#assert.eq(_display-url("https://jane.dev/"), "jane.dev")
#assert.eq(_display-url("http://x.io/a/b?q=1"), "x.io/a/b?q=1")
#assert.eq(_display-url("jane.dev"), "jane.dev")

// _resolve-qr-url: none stays off, a string is used verbatim, auto
// reads basics.url.
#assert.eq(_resolve-qr-url(none, (:)), none)
#assert.eq(_resolve-qr-url("https://a.example", (:)), "https://a.example")
#assert.eq(
  _resolve-qr-url(auto, (url: "https://b.example")),
  "https://b.example",
)

// _linked-contacts: a `url` only where `linkContactInfo` links the
// channel. _header-image: an empty string path is absent.
#let basics = (name: "Jane", email: "j@x.io", url: "https://x.io")
#let prefs = _merge-options((:), (linkContactInfo: (email: false))).prefs
#assert.eq(
  _linked-contacts(basics, prefs).map(c => c.url),
  (none, "https://x.io"),
)

// printFullUrls: an unlinked profile shows its URL, scheme dropped, in
// place of its username; a linked one, the email (not a web channel)
// and a profile without a `url` keep their value.
#let profiles = (
  (network: "GitHub", username: "jane", url: "https://github.com/jane"),
  (network: "Link", username: "jane"),
)
#let values(link) = _linked-contacts(
  basics + (profiles: profiles),
  _merge-options((:), (linkContactInfo: link, printFullUrls: true)).prefs,
).map(c => c.value)
#assert.eq(values(false), ("j@x.io", "x.io", "github.com/jane", "jane"))
#assert.eq(values(true), ("j@x.io", "x.io", "jane", "jane"))
#assert.eq(_header-image(""), none)
#assert.eq(_header-image(none), none)

// _contact-rows: details first, then profiles; an empty group drops out.
#let c(channel) = (channel: channel)
#assert.eq(
  _contact-rows((c("email"), c("url"), c("profiles"))).map(r => r.map(
    x => x.channel,
  )),
  (("email", "url"), ("profiles",)),
)
#assert.eq(_contact-rows((c("profiles"),)).len(), 1)
#assert.eq(_contact-rows(()), ())
