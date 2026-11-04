// The page header: `basics` and the header preferences mapped onto
// `_page-header`. Not one of the column sections in
// `data/sections.typ`: `alta()` renders it above the grid. `_read-cv`
// has checked the fields it reads.

#import "../internal/util/fields.typ": _field
#import "../internal/util/values.typ": _display-url, _group-by, _url-encode
#import "../internal/data/cv.typ": _location-parts, _profile-glyph
#import "../internal/data/validation.typ": _contact-channels, _text-aligns
#import "../internal/design/icon-set.typ": _icon-glyphs, _network-icons
#import "../internal/primitives.typ": _fact-line, _portrait
#import "../internal/components/header.typ": _page-header

// Fully populated per channel, so callers can `link-config.at(channel)`
// without missing-key guards.
#let _resolve-link-config(value) = {
  let all-channels(v) = _contact-channels.fold((:), (acc, c) => acc + ((c): v))
  if type(value) == bool { all-channels(value) } else {
    all-channels(true) + value
  }
}

// `profile-icons` is the merged, lowercase-keyed
// `preferences.profileIcons`, which `_read-cv` has checked maps the
// network.
#let _profile-entry(profile, profile-icons: _network-icons) = (
  channel: "profiles",
  glyph: _profile-glyph(profile, profile-icons),
  // The value is usually a bare username, so the icon is the only
  // thing naming the network. The user's own string, not the
  // lowercased key, keeps their capitalisation ("GitHub").
  alt: profile.network,
  // No `url`: unlinked. No `username`: its URL, scheme dropped.
  value: profile.at(
    "username",
    default: _display-url(profile.at("url", default: "")),
  ),
  url: profile.at("url", default: none),
)

// The contact bar's entries in display order, one
// `(channel, glyph, value, url)` dict per present field, `glyph` a
// FontAwesome name; `channel` keys
// into the resolved `linkContactInfo` config. Pure data, no `context`.
// An empty string counts as absent, so it never renders a bare icon
// behind a dead `mailto:` / `tel:` link.
#let _contact-entries(
  basics,
  maps-provider,
  location-alt: none,
  profile-icons: _network-icons,
) = {
  let email = _field(basics, "email")
  let phone = _field(basics, "phone")
  // The display and the maps link's query join the same parts, so
  // they can't drift; only the display takes the theme's separator.
  let location = _location-parts(basics)
  let url = _field(basics, "url")
  let fields = (
    if email != none {
      (
        channel: "email",
        glyph: _icon-glyphs.email,
        value: email,
        url: "mailto:" + email,
      )
    },
    if phone != none {
      // Strip RFC 3966 visual separators (spaces, parens, hyphens,
      // dots) from the dialable URI; the displayed value keeps them.
      (
        channel: "phone",
        glyph: _icon-glyphs.phone,
        value: phone,
        url: "tel:" + phone.replace(regex("[\s()\-.]"), ""),
      )
    },
    if location != () {
      (
        channel: "location",
        glyph: _icon-glyphs.location,
        alt: location-alt,
        value: _fact-line(location),
        url: if maps-provider != none {
          // A plain replace, not `_fill-template`: a provider's other
          // `{…}` text isn't a placeholder.
          maps-provider.replace("{q}", _url-encode(location.join(", ")))
        },
      )
    },
    if url != none {
      (
        channel: "url",
        glyph: _icon-glyphs.link,
        value: _display-url(url),
        url: url,
      )
    },
  ).filter(e => e != none)
  let profiles = basics.at("profiles", default: ())
  fields + profiles.map(p => _profile-entry(p, profile-icons: profile-icons))
}

// `basics.image`, or `none` when there's nothing to frame: a `path`
// can't be empty, and an empty `str` / `bytes` counts as absent.
#let _header-image(image-src) = if (
  type(image-src) == path or (image-src != none and image-src.len() > 0)
) { image-src }

// `auto` reads `basics.url`, which `_read-cv` has checked is set.
#let _resolve-qr-url(qr-code, basics) = if qr-code == auto {
  basics.url
} else { qr-code }

// The contact bar's `(channel, glyph, value, url)` entries (plus `alt`
// for profiles), each with a `url` only where `linkContactInfo` links
// its channel. With `printFullUrls`, an unlinked homepage or profile
// shows its `url`, scheme dropped, so a username on paper still says
// where to find it; other channels' `url`s (`mailto:`, `tel:`, a maps
// link) only point at the contact.
#let _linked-contacts(basics, prefs, location-alt: none) = {
  let link-config = _resolve-link-config(prefs.linkContactInfo)
  _contact-entries(
    basics,
    prefs.mapsProvider,
    location-alt: location-alt,
    profile-icons: prefs.profileIcons,
  ).map(e => {
    let linked = link-config.at(e.channel)
    let print = (
      not linked
        and prefs.printFullUrls
        and e.channel in ("url", "profiles")
        and e.url != none
    )
    let value = if print { _display-url(e.url) } else { e.value }
    e + (url: if linked { e.url }, value: value)
  })
}

// The contact bar's rows: contact details on one line, profiles on
// the next, so a busy bar scans in two groups. An empty row drops out.
#let _contact-rows(contacts) = _group-by(
  contacts,
  c => if c.channel == "profiles" { "profiles" } else { "details" },
).values()

#let _header(cv, (labels, prefs, ..)) = {
  let basics = cv.basics
  let image = _header-image(basics.at("image", default: none))
  _page-header(
    name: basics.name,
    headline: _field(basics, "label"),
    contacts: _contact-rows(
      _linked-contacts(basics, prefs, location-alt: labels.location),
    ),
    text-align: _text-aligns.at(prefs.headerTextAlign),
    uppercase: prefs.uppercaseName,
    // `alt` is the person's name: language-neutral, so no label key.
    photo: if image != none {
      _portrait(image, prefs.imageSize, basics.name, shape: prefs.imageShape)
    },
    photo-at: if prefs.imagePosition == "center" {
      prefs.imageStackOrder
    } else { prefs.imagePosition },
    qr-url: _resolve-qr-url(prefs.qrCode, basics),
  )
}
