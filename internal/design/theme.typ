// The template's look. `_tokens` are the scales (type, colour,
// spacing, strokes); `_build-theme` maps them onto the roles components
// read and derives `secondary` and `border` from `body`. A role exists
// only where components differ by design; otherwise they read tokens.
//
// Not configurable yet. When it is, `alta()` deep-merges token
// overrides (the tokens nest), rebuilds, then merges role overrides.
// Token values are numbers and strings (hex colours, widths in pt), so
// a theme could load from TOML.
//
// Type sizes and `space` multiply the body size; public helpers
// (`tag`, `term`, `divider`, `rating`, `icon`) read it from state, as
// they may sit outside `alta()`. `em` roles follow their own text;
// `pt` and `cm` lengths don't scale.

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
  // Bootstrap's colour roles; `secondary` and `border` derive from
  // `body` unless set.
  colour: (body: "#666666", emphasis: "#2E2E2E"),
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
  let colour = tokens.colour.pairs().map(((k, v)) => (k, rgb(v))).to-dict()
  (
    type: ty,
    font-weight: fw,
    colour: (
      secondary: colour.body.lighten(35%),
      // Dividers, empty rating dots.
      border: colour.body.lighten(65%),
    )
      + colour,
    stroke-width: sw.pairs().map(((k, v)) => (k, v * 1pt)).to-dict(),
    // `Manager, Pied Piper · 2024`: `items` within a group, `facts`
    // between groups; `label` after an interest group's name
    // (`Music: Trad, Jazz`).
    separator: (facts: " · ", items: ", ", label: ": "),
    // For a summary, a `styled-link` title, the CV owner among
    // publication authors, and an interest group's name.
    treatment: (
      preamble: "emph",
      link: "emph",
      owner: "strong",
      label: "strong",
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
    // `===` entries and `====` groups.
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
    // `radius` and `baseline` are geometry.
    // `row-pad`: above and below a language row's dots.
    rating: (radius: 0.45, gap: sp.x-small, row-pad: 0.12),
    // `glyph`: the glyph's share of its box.
    icon: (glyph: 0.9, gap: sp.x-small),
    // `_inline`'s rule: glyphs stand on the baseline, drawn shapes
    // centre on the x-height.
    inline: (mark: "x-height", icon: "baseline"),
  )
}

#let _theme = _build-theme(_tokens)
