// The page header: `basics` and the header preferences mapped onto
// `_page-header`. Not one of the column sections in
// `data/sections.typ`: `alta()` renders it above the grid. `_read-cv`
// has checked the fields it reads.

#import "../internal/util/fields.typ": _field
#import "../internal/util/location.typ": _format-location
#import "../internal/util/values.typ": _url-encode
#import "../internal/data/cv.typ": _profile-network
#import "../internal/data/validation.typ": _contact-channels
#import "../internal/primitives.typ": _portrait
#import "../internal/components/header.typ": _page-header

// Fully populated per channel, so callers can `link-config.at(channel)`
// without missing-key guards.
#let _resolve-link-config(value) = {
  let all-channels(v) = _contact-channels.fold((:), (acc, c) => acc + ((c): v))
  if type(value) == bool { all-channels(value) } else {
    all-channels(true) + value
  }
}

#let _profile-entry(profile) = (
  channel: "profiles",
  icon: _profile-network(profile),
  // The value is usually a bare username, so the icon is the only
  // thing naming the network. The user's own string, not the
  // lowercased key, keeps their capitalisation ("GitHub").
  alt: profile.network,
  // A profile without `url` renders unlinked rather than failing.
  value: profile.at("username", default: profile.at("url", default: "")),
  url: profile.at("url", default: none),
)

// The contact bar's entries in display order, one
// `(channel, icon, value, url)` dict per present field; `channel` keys
// into the resolved `linkContactInfo` config. Pure data, no `context`.
// An empty string counts as absent, so it never renders a bare icon
// behind a dead `mailto:` / `tel:` link.
#let _contact-entries(basics, maps-provider) = {
  let email = _field(basics, "email")
  let phone = _field(basics, "phone")
  // One collapsed value feeds both display and maps link, so they
  // cannot drift.
  let location = _format-location(basics.at("location", default: none))
  let url = _field(basics, "url")
  let fields = (
    if email != none {
      (channel: "email", icon: "email", value: email, url: "mailto:" + email)
    },
    if phone != none {
      // Strip RFC 3966 visual separators (spaces, parens, hyphens,
      // dots) from the dialable URI; the displayed value keeps them.
      (
        channel: "phone",
        icon: "phone",
        value: phone,
        url: "tel:" + phone.replace(regex("[\s()\-.]"), ""),
      )
    },
    if location != none {
      (
        channel: "location",
        icon: "location",
        value: location,
        url: if maps-provider != none {
          maps-provider.replace("{q}", _url-encode(location))
        },
      )
    },
    if url != none { (channel: "url", icon: "link", value: url, url: url) },
  ).filter(e => e != none)
  fields + basics.at("profiles", default: ()).map(_profile-entry)
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

// The contact bar's `(channel, icon, value, url)` entries (plus `alt`
// for profiles), each with a `url` only where `linkContactInfo` links
// its channel.
#let _linked-contacts(basics, prefs) = {
  let link-config = _resolve-link-config(prefs.linkContactInfo)
  _contact-entries(basics, prefs.mapsProvider).map(e => (
    e + (url: if link-config.at(e.channel) { e.url })
  ))
}

#let _header(cv, prefs) = {
  let basics = cv.basics
  let image = _header-image(basics.at("image", default: none))
  _page-header(
    name: basics.name,
    pronouns: if prefs.showPronouns { _field(basics, "pronouns") },
    headline: _field(basics, "label"),
    contacts: _linked-contacts(basics, prefs),
    text-align: (left: left, right: right, center: center).at(
      prefs.headerTextAlign,
    ),
    uppercase: prefs.uppercaseName,
    // `alt` is the person's name: language-neutral, so no label key.
    photo: if image != none { _portrait(image, prefs.imageSize, basics.name) },
    photo-at: if prefs.imagePosition == "center" {
      prefs.imageStackOrder
    } else { prefs.imagePosition },
    qr-url: _resolve-qr-url(prefs.qrCode, basics),
  )
}
