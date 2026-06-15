// FontAwesome 6 Free glyph renderer. The TTFs under `fonts/` ship
// with the package — Brands for brand marks (GitHub, LinkedIn, …)
// and Free Solid for utility icons (envelope, calendar, location, …).
// `typst compile --font-path fonts` (or the default discovery when
// the package root is the project root) picks them up; no system
// font install is required.
//
// `icon(name)` resolves a logical name to a (font, codepoint) pair
// and renders it as a sized, baseline-shifted text glyph, so colour
// and size flow through the standard Typst text model rather than
// through SVG-attribute munging.

#import "state.typ": _body_size_state, _body_colour

#let _fa_brands_font = "Font Awesome 6 Brands"
#let _fa_solid_font = "Font Awesome 6 Free Solid"

// Utility icons (Free Solid). The keys match the names the rest of
// the template uses internally; renaming a key here is a breaking
// change for any caller of the public `icon(...)` function.
#let _utility_icon_glyphs = (
  book: (font: _fa_solid_font, glyph: "\u{f02d}"),
  calendar: (font: _fa_solid_font, glyph: "\u{f133}"),
  email: (font: _fa_solid_font, glyph: "\u{f0e0}"),
  file: (font: _fa_solid_font, glyph: "\u{f15b}"),
  // FA renamed `map-marker-alt` → `location-dot` in 6.x.
  location: (font: _fa_solid_font, glyph: "\u{f3c5}"),
  microphone: (font: _fa_solid_font, glyph: "\u{f130}"),
  newspaper: (font: _fa_solid_font, glyph: "\u{f1ea}"),
  phone: (font: _fa_solid_font, glyph: "\u{f095}"),
)

// Profile-network icons. Keys are lowercase to match
// `lower(profile.network)` in `internal/header.typ`. To add a network,
// pick the FA Brands glyph from
// https://fontawesome.com/v6/cheatsheet/free/brands and add a row;
// no font install is needed because the Brands TTF ships with the
// package. `link` and `website` use the Free Solid font (they aren't
// brand marks); everything else is a Brands glyph.
#let _network_icon_glyphs = (
  bluesky: (font: _fa_brands_font, glyph: "\u{e671}"),
  github: (font: _fa_brands_font, glyph: "\u{f09b}"),
  gitlab: (font: _fa_brands_font, glyph: "\u{f296}"),
  link: (font: _fa_solid_font, glyph: "\u{f0c1}"),
  linkedin: (font: _fa_brands_font, glyph: "\u{f08c}"),
  mastodon: (font: _fa_brands_font, glyph: "\u{f4f6}"),
  medium: (font: _fa_brands_font, glyph: "\u{f23a}"),
  stackoverflow: (font: _fa_brands_font, glyph: "\u{f16c}"),
  twitter: (font: _fa_brands_font, glyph: "\u{f099}"),
  // FA Free Solid `globe` — generic "this is a website" mark.
  website: (font: _fa_solid_font, glyph: "\u{f0ac}"),
)

#let _icon_glyphs = _utility_icon_glyphs + _network_icon_glyphs
#let _profile_networks = _network_icon_glyphs.keys()

// Maps renamed networks onto the icon we still ship under the old
// name. The lookup happens after `lower(profile.network)`.
#let _network_aliases = (
  x: "twitter",
)

// Renders the FA glyph sized to the surrounding text. Emits a small
// trailing `h(...)` so callers don't need to add inter-icon spacing
// themselves; suppress it by wrapping in `box(...)` if undesired.
//
// The glyph is wrapped in a fixed-size box so its advance width is
// uniform across icons (FA glyphs have varied native widths, which
// would otherwise jitter the columns of icon-led rows).
#let icon(name, size: auto, shift: auto, fill: auto) = context {
  let body-size = _body_size_state.get()
  let resolved-size = if size == auto { body-size } else { size }
  let resolved-shift = if shift == auto { 0.15 * body-size } else { shift }
  let resolved-fill = if fill == auto { _body_colour } else { fill }

  let entry = _icon_glyphs.at(name)
  box(
    baseline: resolved-shift,
    width: resolved-size,
    height: resolved-size,
    align(
      center + horizon,
      text(
        font: entry.font,
        size: 0.9 * resolved-size,
        fill: resolved-fill,
        entry.glyph,
      ),
    ),
  )
  h(0.3 * body-size)
}
