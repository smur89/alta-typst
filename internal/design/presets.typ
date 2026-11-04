// The colour themes and the deprecated accent palettes, re-exported
// from `lib.typ`.

// Each dark enough to stay legible beside the grey body text and to
// survive a B&W photocopy as a distinct mid-tone.
/// The accent of each single-accent theme. Deprecated: use `themes`.
/// -> dictionary
#let palettes = (
  teal: rgb("#00796B"),
  navy: rgb("#1A3A6C"),
  crimson: rgb("#9E2A2B"),
  forest: rgb("#2E5E3A"),
  plum: rgb("#5F2A6E"),
  charcoal: rgb("#3B3B3B"),
)

// The colour roles every theme sets, and `preferences.colours` may.
#let _colour-role-names = (
  "accent",
  "emphasis",
  "body",
  "heading",
  "headingRule",
  "subheading",
  "name",
  "tagline",
)

// The roles a single-accent theme colours with its accent; the
// deprecated top-level `accent` sets them too.
#let _accent-roles(accent) = (
  accent: accent,
  heading: accent,
  headingRule: accent,
  subheading: accent,
  name: accent,
)

// A theme from one accent over the grey text.
#let _accent-theme(accent) = (
  colours: _accent-roles(accent)
    + (
      emphasis: rgb("#2E2E2E"),
      body: rgb("#666666"),
      tagline: rgb("#2E2E2E"),
    ),
)

/// The built-in themes for `preferences.theme`: one per accent palette,
/// and `altacv`, with dark red headings over a gold rule.
/// -> dictionary
#let themes = (
  palettes.pairs().map(((k, v)) => (k, _accent-theme(v))).to-dict()
    + (
      altacv: (
        colours: _accent-theme(rgb("#8F0D0D")).colours
          + (
            heading: rgb("#450808"),
            headingRule: rgb("#E7D192"),
            name: black,
            tagline: rgb("#8F0D0D"),
          ),
      ),
    )
)
