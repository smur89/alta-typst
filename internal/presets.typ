// Public preset dicts re-exported from `lib.typ` as part of the
// documented API. Constants only — no logic, no state, no
// dependencies. Compile-time values that callers reference as
// `accent: palettes.navy` or `mapsProvider: maps-providers.osm`.

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

// Maps deep-link URL templates. `{q}` is substituted with the
// URL-encoded `basics.location` at render time.
#let maps-providers = (
  google: "https://www.google.com/maps?q={q}",
  apple: "https://maps.apple.com/?q={q}",
  bing: "https://www.bing.com/maps?q={q}",
  duckduckgo: "https://duckduckgo.com/?q={q}&iaxm=maps",
  osm: "https://www.openstreetmap.org/search?query={q}",
)

// Vetted preset bundles of preferences that hang together visually.
// Each theme is a partial `preferences` dict — accent + font + the
// layout knobs that interact with them. Callers spread a theme over
// their own overrides:
//
//   #alta(cv, preferences: themes.modern + (imageSize: 7em))
//
// Themes only touch the knobs that interact (accent, font, columnRatio,
// headerTextAlign); everything else falls back to `_default_preferences`,
// so a theme stays a small, focused identity rather than a full config.
//
// `imagePosition` is deliberately omitted — it's only meaningful when
// `basics.image` is set, and baking it into every theme would either
// force image-only assumptions or no-op for image-less CVs. Users add
// `imagePosition` themselves via the spread-and-override pattern.
//
// `classic` re-declares the current defaults rather than being an alias.
// Themes are bundles by name, not pointers to "whatever the default is
// right now" — `classic` is allowed to drift from defaults so the named
// look stays stable.
//
// Fonts on `modern` (Inter) and `minimal` (Source Sans 3) are aspirational
// — neither is installed on the CI host. Typst falls back rather than
// panicking, so a user without the font still gets a working render; the
// README flags this so the user can install or override.
#let themes = (
  classic: (
    font: "Lato",
    accent: palettes.teal,
    columnRatio: 0.64,
    headerTextAlign: "left",
  ),
  modern: (
    font: "Inter",
    accent: palettes.navy,
    columnRatio: 0.50,
    headerTextAlign: "center",
  ),
  minimal: (
    font: "Source Sans 3",
    accent: palettes.charcoal,
    columnRatio: 0.55,
    headerTextAlign: "left",
  ),
)
