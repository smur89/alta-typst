// The template's look. `_tokens` are the scales (type, colours,
// separators, treatments, spacing, strokes); `_build-theme` maps them
// onto the roles components read. A role exists only where components
// differ by design; otherwise they read tokens. A theme (`presets.typ`)
// overrides tokens: `_theme-for` merges it and `preferences.colours`
// over `_tokens` and builds, once per render, into the state
// components read (`_theme-state`).
//
// Type sizes and `space` multiply the body size; public helpers
// (`tag`, `term`, `divider`, `rating`, `icon`) read it from state, as
// they may sit outside `alta()`. `em` roles follow their own text;
// `pt` and `cm` lengths don't scale.

#import "../util/values.typ": _deep-merge

// The roles a single-accent theme colours with its accent; the
// deprecated top-level `accent` sets them too.
#let _accent-roles(accent) = (
  accent: accent,
  heading: accent,
  headingRule: accent,
  subheading: accent,
  name: accent,
)

#let _tokens = (
  // Material Design 3's type roles: `display` the name, `headline` a
  // section title, `title` a heading, `body` the rest (quieter lines
  // differ by colour, not size).
  type: (
    display: (size: 2.5, weight: "bold"),
    headline: (size: 1.4, weight: "bold"),
    title: (size: 1.2, weight: "semibold"),
    // Always 1: `bodySize` sets it.
    body: (size: 1, weight: "regular"),
  ),
  // To embolden within a role.
  font-weight: (regular: "regular", bold: "bold"),
  // The colour roles (`preferences.colours`): a teal accent over grey
  // text, the default theme. `emphasis` and `body` follow Bootstrap's
  // roles.
  colours: (
    _accent-roles(rgb("#00796B"))
      + (
        emphasis: rgb("#2E2E2E"),
        body: rgb("#666666"),
        tagline: rgb("#2E2E2E"),
      )
  ),
  // `Manager, Pied Piper · 2024`: `items` within a group (a location's
  // parts too), `facts` between groups; `label` after an interest
  // group's name (`Music: Trad, Jazz`) and the footer's "Last
  // updated"; `range` between a period's dates.
  separator: (facts: " · ", items: ", ", label: ": ", range: [ – ]),
  // A publication's citation, `ACM 12(3), 45–67`: the brackets around
  // the issue, before the pages, between the publisher and the rest,
  // and the dash that replaces hyphens in a page range.
  citation: (issue: ("(", ")"), pages: ", ", source: " ", page-range: "–"),
  // For a summary, a `styled-link` title, the CV owner among
  // publication authors, and an interest group's name.
  treatment: (
    // A plain setting, not `emph`: the summary is a `_part`.
    preamble: "italic",
    link: "emph",
    owner: "strong",
    label: "strong",
  ),
  // CSS's size keywords.
  space: (
    xx-small: 0.15,
    x-small: 0.3,
    small: 0.5,
    medium: 0.8,
    large: 1.2,
  ),
  // In pt.
  stroke-width: (thin: 0.5, thick: 1),
  leading: 0.55,
)

#let _build-theme(tokens) = {
  let (type: ty, font-weight: fw, space: sp, stroke-width: sw) = tokens
  (
    type: ty,
    font-weight: fw,
    stroke-width: sw.pairs().map(((k, v)) => (k, v * 1pt)).to-dict(),
    separator: tokens.separator,
    citation: tokens.citation,
    treatment: tokens.treatment,
    // `secondary` (the quietest lines) and `border` (dividers, empty
    // rating dots) derive from `body`.
    colours: (
      tokens.colours
        + (
          secondary: tokens.colours.body.lighten(35%),
          border: tokens.colours.body.lighten(65%),
        )
    ),
    par: (leading: tokens.leading * 1em, spacing: sp.medium * 1em),
    list: (body-indent: sp.x-small, spacing: tokens.leading * 1em),
    // `==` headings. `rule-gap` pulls the rule up (geometry).
    // `tracking` opens up the capitals.
    section: (
      above: sp.small,
      rule-gap: -0.7,
      below: sp.xx-small,
      case: "upper",
      tracking: 0.04em,
    ),
    // Entry and group headings.
    subheading: (
      entry: (above: sp.medium, below: sp.medium, weight: ty.title.weight),
      group: (above: sp.small, below: sp.small, weight: fw.bold),
    ),
    column-gutter: 12pt,
    // `name-below` (`name()` is public), `row-gap` and `facts-below`
    // scale with body size; the rest are `em`.
    entry: (
      name-below: sp.small,
      subtitle-below: sp.small * 1em,
      // Between the title row and the facts row (organisation ·
      // roles), and under the facts row, before the summary.
      row-gap: sp.small,
      facts-below: sp.medium,
      // Between the left side and the date or location at the right
      // edge; each takes a line of its own past `side-max` of the
      // column.
      side-gap: sp.medium * 1em,
      side-max: 50%,
    ),
    term: (below: sp.medium, inset: sp.x-small),
    // Fills lighten the accent, the text darkens it.
    tag: (
      fill: 85%,
      label-fill: 70%,
      text-darken: 15%,
      radius: 2.5pt,
      inset: (x: sp.x-small, y: sp.xx-small),
      outset-y: sp.xx-small,
      gap: sp.x-small,
      weight: ty.body.weight,
      label-weight: fw.bold,
    ),
    divider: (gap: sp.x-small, dash: "dashed", clearance: 0.5cm),
    // A skill group's label pill and its keywords; wrapped keywords
    // hang under the first unless the label is past `indent-max` of
    // the column.
    keyword-row: (gap: sp.medium, dash: "–", indent-max: 50%),
    header: (
      name-below: sp.large,
      headline-below: sp.medium,
      // The contact bar's text and icons, below body so they don't
      // compete with the name.
      contact-size: 0.9,
      contact-gap: sp.large,
      ornament-gutter: sp.medium * 1em,
      photo-gap: sp.medium,
      // The corner radius per `preferences.imageShape`.
      portrait-radius: (circle: 50%, rounded: 15%, square: 0%),
      // The QR code's side.
      qr: 3.5,
    ),
    // Around the intro and the objective's pull-quote.
    intro: (
      above: sp.medium,
      inset: (left: sp.medium, y: sp.xx-small),
      gap: sp.x-small,
      below: sp.x-small,
    ),
    // `radius` and `row-height` (every rating row's, dots or text) are
    // geometry.
    rating: (radius: 0.45, gap: sp.x-small, row-height: 1.14),
    // `glyph`: the glyph's share of its box.
    icon: (glyph: 0.9, gap: sp.x-small),
  )
}

// The colour roles every theme sets, and `preferences.colours` may.
#let _colour-role-names = _tokens.colours.keys()

// The theme with no overrides: the state's default, for public helpers
// used outside `alta()`.
#let _default-theme = _build-theme(_tokens)

// The theme to render with: the chosen theme's tokens, then
// `preferences.colours`, over `_tokens`.
#let _theme-for(theme, colours) = _build-theme(
  (theme, (colours: colours)).fold(_tokens, _deep-merge),
)
