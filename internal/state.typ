// Private state cells + colour constants. `alta()` sets the state at
// render time; helpers throughout the package read it inside every
// `context { }` block. Public presets (the `palettes` dict for the
// `_accent_state` default, plus `maps-providers`) live separately in
// `presets.typ`.

#import "presets.typ": palettes

// State cells consulted by helpers throughout the package — set once
// by `alta()` and read inside every `context { }` block downstream.
#let _body_size_state = state("alta-body-size", 10pt)
#let _accent_state = state("alta-accent", palettes.teal)
#let _max_rating_state = state("alta-max-rating", 5)
// Multiplier applied to every spacing em-token (block above/below,
// `v()`, par.spacing/leading, list.spacing). Driven by
// `preferences.density`; defaults to 1.0 so "comfortable" reproduces
// the historical layout byte-for-byte.
#let _spacing_scale_state = state("alta-spacing-scale", 1.0)

// `preferences.density` → multiplier on every spacing em-token.
// 0.85 / 1.0 / 1.15 keeps the three presets visibly distinct without
// either crushing lines together or pushing the one-page CV onto two.
// Text sizes, icon dimensions, and rating-dot geometry are
// deliberately left alone — density is purely vertical whitespace,
// so font-size scaling stays the job of `bodySize`.
#let _density_scales = (
  compact: 0.85,
  comfortable: 1.0,
  spacious: 1.15,
)

// Accent is configurable via `alta(preferences: (accent: ...))`; the
// rest are opinionated visual constants.
#let _body_colour = rgb("#666666")
#let _emphasis_colour = rgb("#2E2E2E")
#let _empty_dot_colour = rgb("#c0c0c0")
#let _divider_colour = rgb("#D1D1D1")
