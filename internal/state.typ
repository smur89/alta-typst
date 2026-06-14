// Shared state and constants. Declared up here (above defaults and
// renderers) so both can reference `palettes.teal` without
// duplicating hex literals.
//
// `palettes` and `maps-providers` are re-exported as public surface
// from `lib.typ` — callers reference them as `palettes.navy` /
// `maps-providers.osm` after importing.

// Curated accent presets — each dark enough to remain legible against
// the grey body text and to survive a B&W photocopy as a distinct
// mid-tone. `teal` is the default.
#let palettes = (
  teal:     rgb("#00796B"),
  navy:     rgb("#1A3A6C"),
  crimson:  rgb("#9E2A2B"),
  forest:   rgb("#2E5E3A"),
  plum:     rgb("#5F2A6E"),
  charcoal: rgb("#3B3B3B"),
)

// State set by alta() at render time and read by helpers throughout
// the package.
#let _body_size_state = state("alta-body-size", 10pt)
#let _accent_state = state("alta-accent", palettes.teal)
#let _max_rating_state = state("alta-max-rating", 5)

// Accent is configurable via alta(); the rest are opinionated.
#let _body_colour = rgb("#666666")
#let _emphasis_colour = rgb("#2E2E2E")
#let _empty_dot_colour = rgb("#c0c0c0")
#let _divider_colour = rgb("#D1D1D1")

// Exported so callers can write `mapsProvider: maps-providers.google`
// rather than the literal URL. `{q}` is substituted with the URL-
// encoded location at render time.
#let maps-providers = (
  google: "https://www.google.com/maps?q={q}",
  apple: "https://maps.apple.com/?q={q}",
  bing: "https://www.bing.com/maps?q={q}",
  duckduckgo: "https://duckduckgo.com/?q={q}&iaxm=maps",
  osm: "https://www.openstreetmap.org/search?query={q}",
)
