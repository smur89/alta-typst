// String / content predicates and transformations. Pure helpers with
// no rendering side-effects (except `styled-link` and `_titled_link`,
// which emit content but depend only on shared state).

#import "state.typ": _accent_state

// Rejects `none`, the empty string, and the empty content block —
// the three ways a section field can be effectively absent.
#let _present(v) = v != none and v != "" and v != []

// JSON Resume's structured `location` dict collapsed to a single
// header line. `address`/`postalCode` round-trip but aren't rendered
// — a CV header isn't a mailing label. Unknown keys panic to surface
// typos. The result drives both the displayed text and the maps
// deep link, so reader and link target stay in sync.
#let _location_fields = ("address", "postalCode", "city", "countryCode", "region")
#let _location_display_order = ("city", "region", "countryCode")
#let _format_location(value) = {
  if value == none { return none }
  if type(value) == str { return value }
  if type(value) != dictionary {
    panic(
      "basics.location must be a string or a dict matching JSON Resume's"
        + " {address, postalCode, city, countryCode, region}, got: " + repr(value),
    )
  }
  let unknown = value.keys().filter(k => k not in _location_fields)
  if unknown.len() > 0 {
    let quote(k) = "\"" + k + "\""
    panic(
      "Unknown basics.location key(s): " + unknown.map(quote).join(", ")
        + ". Supported: " + _location_fields.map(quote).join(", "),
    )
  }
  let parts = _location_display_order
    .map(k => value.at(k, default: none))
    .filter(v => v != none and v != "")
  if parts.len() == 0 { return none }
  parts.join(", ")
}

// Per RFC 3986. Iterates UTF-8 bytes (not codepoints), so non-Latin
// locations like "Zürich" or "京都" round-trip through the maps URL.
#let _url_encode(s) = {
  let unreserved = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
  let hex = "0123456789ABCDEF"
  let out = ""
  for b in array(bytes(s)) {
    if b < 128 and str.from-unicode(b) in unreserved {
      out += str.from-unicode(b)
    } else {
      out += "%" + hex.at(int(b / 16)) + hex.at(int(calc.rem(b, 16)))
    }
  }
  out
}

// Accent-coloured italic link — used for publication and project titles.
#let styled-link(dest, content) = context {
  let accent = _accent_state.get()
  emph(text(fill: accent, link(dest, content)))
}

// Italic + accent styling for entry titles, with the link wrap added
// only when a URL is supplied. Every renderer that uses this gets a
// uniform visual; URL presence is purely a clickability concern.
#let _titled_link(title, url) = context {
  let accent = _accent_state.get()
  let styled = emph(text(fill: accent, title))
  if url != none { link(url, styled) } else { styled }
}
