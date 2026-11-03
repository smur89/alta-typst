// The page header: `basics` and the header preferences mapped onto
// `_page_header`, then the root `objective` (JSON Resume 1.4.0) and
// `basics.summary` onto `_intro_block`. Not one of the column sections
// in `data/sections.typ`: `alta()` renders it above the grid. CV fields are
// checked here, where they're consumed.

#import "../internal/design/icon-set.typ": _network_aliases, _profile_networks
#import "../internal/util/checks.typ": _check_type
#import "../internal/util/fields.typ": _field
#import "../internal/util/location.typ": _format_location
#import "../internal/util/values.typ": _present, _url_encode
#import "../internal/data/validation.typ": _contact_channels
#import "../internal/primitives.typ": _portrait
#import "../internal/components/header.typ": _intro_block, _page_header

// Fully populated per channel, so callers can `link-config.at(channel)`
// without missing-key guards.
#let _resolve_link_config(value) = {
  let all-channels(v) = _contact_channels.fold((:), (acc, c) => acc + ((c): v))
  if type(value) == bool { all-channels(value) } else {
    all-channels(true) + value
  }
}

#let _profile_entry(profile) = {
  let raw = lower(profile.network)
  let network = _network_aliases.at(raw, default: raw)
  if network not in _profile_networks {
    panic(
      "Unknown profile network: "
        + repr(profile.network)
        + ". Supported: "
        + _profile_networks.join(", ")
        + ". To add another, register its FontAwesome glyph in _network_icons (internal/design/icon-set.typ).",
    )
  }
  (
    channel: "profiles",
    icon: network,
    // The value is usually a bare username, so the icon is the only
    // thing naming the network. The user's own string, not the
    // lowercased key, keeps their capitalisation ("GitHub").
    alt: profile.network,
    // A profile without `url` renders unlinked rather than failing.
    value: profile.at("username", default: profile.at("url", default: "")),
    url: profile.at("url", default: none),
  )
}

// The contact bar's entries in display order, one
// `(channel, icon, value, url)` dict per present field; `channel` keys
// into the resolved `linkContactInfo` config. Pure data, no `context`.
// An empty string counts as absent, so it never renders a bare icon
// behind a dead `mailto:` / `tel:` link.
#let _contact_entries(basics, maps-provider) = {
  let email = _field(basics, "email")
  let phone = _field(basics, "phone")
  // One collapsed value feeds both display and maps link, so they
  // cannot drift.
  let location = _format_location(
    basics.at("location", default: none),
    "basics.location",
  )
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
          maps-provider.replace("{q}", _url_encode(location))
        },
      )
    },
    if url != none { (channel: "url", icon: "link", value: url, url: url) },
  ).filter(e => e != none)
  fields + basics.at("profiles", default: ()).map(_profile_entry)
}

// `basics.image`, or `none` when there's nothing to frame: a `path`
// can't be empty, and an empty `str` / `bytes` counts as absent. Other
// types panic here rather than as a cryptic `image()` failure.
#let _header_image(image-src) = if image-src == none { none } else if (
  type(image-src) == path
) { image-src } else if type(image-src) in (str, bytes) {
  if image-src.len() > 0 { image-src }
} else {
  panic(
    "basics.image must be a path, a string path, or bytes, got: "
      + repr(image-src),
  )
}

// Separate from `_check_qr_code` because `auto` needs `basics`.
#let _resolve_qr_url(qr-code, basics) = {
  if qr-code == none { return none }
  if qr-code != auto { return qr-code }
  let url = basics.at("url", default: none)
  if url == none {
    panic(
      "preferences.qrCode is `auto` but basics.url is missing. "
        + "Set basics.url to the destination URL, or pass the URL "
        + "directly via preferences.qrCode.",
    )
  }
  if type(url) != str {
    panic("basics.url must be a string, got: " + repr(url))
  }
  if url == "" {
    panic(
      "basics.url is empty; set it to the destination URL or remove preferences.qrCode.",
    )
  }
  url
}

// The contact bar's `(channel, icon, value, url)` entries (plus `alt`
// for profiles), each with a `url` only where `linkContactInfo` links
// its channel.
#let _linked_contacts(basics, prefs) = {
  let link-config = _resolve_link_config(prefs.linkContactInfo)
  _contact_entries(basics, prefs.mapsProvider).map(e => (
    e + (url: if link-config.at(e.channel) { e.url })
  ))
}

#let _header(cv, prefs) = {
  let basics = cv.basics
  let image = _header_image(basics.at("image", default: none))
  _page_header(
    name: basics.name,
    pronouns: if prefs.showPronouns { _field(basics, "pronouns") },
    headline: _field(basics, "label"),
    contacts: _linked_contacts(basics, prefs),
    text-align: (left: left, right: right, center: center).at(
      prefs.headerTextAlign,
    ),
    uppercase: prefs.uppercaseName,
    // `alt` is the person's name: language-neutral, so no label key.
    photo: if image != none { _portrait(image, prefs.imageSize, basics.name) },
    photo-at: if prefs.imagePosition == "center" {
      prefs.imageStackOrder
    } else { prefs.imagePosition },
    qr-url: _resolve_qr_url(prefs.qrCode, basics),
  )
}

#let _intro(cv) = {
  let objective = cv.at("objective", default: none)
  _check_type(
    "objective",
    objective,
    (str, content, type(none)),
    "a string or content",
  )
  _intro_block(
    objective: if _present(objective) { objective },
    summary: _field(cv.basics, "summary"),
  )
}
