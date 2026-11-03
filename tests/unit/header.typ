// Unit checks for the header's data stages in sections/header.typ,
// including the QR URL resolution.

#import "/internal/util/fields.typ": _url_encode
#import "/sections/header.typ": (
  _contact_entries, _header_image, _linked_contacts, _profile_entry,
  _resolve_link_config, _resolve_qr_url,
)
#import "/internal/options.typ": _merge_options

// _url_encode: RFC 3986 unreserved set kept, everything else
// percent-encoded by UTF-8 byte.
#assert.eq(_url_encode("AZaz09-._~"), "AZaz09-._~")
#assert.eq(_url_encode("Cork, Ireland"), "Cork%2C%20Ireland")
#assert.eq(_url_encode("Zürich"), "Z%C3%BCrich")
#assert.eq(_url_encode("京都"), "%E4%BA%AC%E9%83%BD")

// _resolve_link_config: a bool fans out to every channel; a dict
// overrides on top of all-true.
#assert.eq(
  _resolve_link_config(false),
  (email: false, phone: false, location: false, url: false, profiles: false),
)
#assert.eq(
  _resolve_link_config((phone: false)),
  (email: true, phone: false, location: true, url: true, profiles: true),
)

// _contact_entries: display order, dialable `tel:` URI, maps link,
// empty fields skipped.
#let entries = _contact_entries(
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
  _contact_entries((location: "Cork"), none).first().url,
  none,
)

// _profile_entry: aliases resolve, `alt` keeps the user's spelling,
// a profile without `url` shows the username unlinked.
#let x = _profile_entry((network: "X", username: "jane"))
#assert.eq((x.icon, x.alt, x.value, x.url), ("twitter", "X", "jane", none))
#let gh = _profile_entry((network: "GitHub", url: "https://github.com/jane"))
#assert.eq((gh.icon, gh.value), ("github", "https://github.com/jane"))

// _resolve_qr_url: none stays off, a string is used verbatim, auto
// reads basics.url.
#assert.eq(_resolve_qr_url(none, (:)), none)
#assert.eq(_resolve_qr_url("https://a.example", (:)), "https://a.example")
#assert.eq(
  _resolve_qr_url(auto, (url: "https://b.example")),
  "https://b.example",
)

// _linked_contacts: a `url` only where `linkContactInfo` links the
// channel. _header_image: an empty string path is absent.
#let basics = (name: "Jane", email: "j@x.io", url: "https://x.io")
#let prefs = _merge_options((:), (linkContactInfo: (email: false))).preferences
#assert.eq(
  _linked_contacts(basics, prefs).map(c => c.url),
  (none, "https://x.io"),
)
#assert.eq(_header_image(""), none)
#assert.eq(_header_image(none), none)
