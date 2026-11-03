// The template's look in one place, in two tiers.
//
// `_tokens` are the scales everything is drawn from, named after
// industry conventions so they read as words: type roles, colour
// roles, spacing, stroke widths, line height. `_build-theme(tokens)`
// maps them onto the roles components read (`section.above`,
// `tag.inset`, …) and derives `secondary` and `border` from `body`. A
// component role only exists where components differ by design (an
// entry's heading is regular, a group's bold); otherwise a component
// reads the token directly.
//
// Nothing here is configurable yet. The shape is for when it is:
// `alta()` would merge a caller's token overrides over `_tokens`,
// rebuild, then merge role overrides over the result, so changing a
// token moves every role drawn from it. The tokens nest
// (`type.title.size`), so that merge must be a deep one: a plain `+`
// would drop the sibling keys. Token values are plain numbers and
// strings (colours as hex, stroke widths in pt), so a theme can come
// from a TOML file as the labels do; `_build-theme` converts them.
//
// Sizes scale with the body size. Type sizes and `space` are
// multiples of it: public helpers (`tag`, `term`, `divider`, `rating`,
// `icon`) read the body size from state and multiply, since they may
// sit outside `alta()`'s text. A role in `em` is relative to its own
// text, where that's the intent. `pt` and `cm` lengths (the column
// gutter, stroke widths, the pill radius, the divider clearance)
// deliberately don't scale. Treatments are named (`"emph"`) and
// `_treat` (`styles.typ`) applies them.

#let _tokens = (
  // Material Design 3's type roles: each a size (a multiple of the
  // body size) and weight. `display` is the name, `headline` a section
  // title, `title` an entry or group heading, `body` everything else,
  // quieter lines told apart by colour (`secondary`), not size.
  type: (
    display: (size: 2.5, weight: "bold"),
    headline: (size: 1.7, weight: "bold"),
    title: (size: 1.2, weight: "regular"),
    // Fixed at 1: the `bodySize` preference sets the body size.
    body: (size: 1, weight: "regular"),
  ),
  // For emboldening within a role (a group heading, a label pill).
  font-weight: (regular: "regular", bold: "bold"),
  // Bootstrap's colour roles. `secondary` and `border` derive from
  // `body` unless set.
  colour: (body: "#666666", emphasis: "#2E2E2E"),
  // Multiples of the body size, named by CSS's size keywords.
  space: (
    xx-small: 0.15,
    x-small: 0.3,
    small: 0.5,
    medium: 0.8,
    large: 1.2,
  ),
  // In pt; they don't scale with the body size.
  stroke-width: (thin: 0.5, thick: 2),
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
      // Faint lines and shapes: dividers, empty rating dots.
      border: colour.body.lighten(65%),
    )
      + colour,
    stroke-width: sw.pairs().map(((k, v)) => (k, v * 1pt)).to-dict(),
    // Between facts on one line (`Manager, Pied Piper · 2024`): `facts`
    // between groups, `items` within one.
    separator: (facts: " · ", items: ", "),
    // Named treatments: a `summary` or other preamble, a `styled-link`
    // title, and the CV owner among a publication's authors.
    treatment: (preamble: "emph", link: "emph", owner: "strong"),
    par: (leading: tokens.leading * 1em, spacing: sp.medium * 1em),
    list: (body-indent: sp.x-small, spacing: tokens.leading * 1em),
    // `==` headings: the gap above, the pull up to the rule (geometry,
    // not spacing), the rule, and the gap below it.
    section: (
      above: sp.small,
      rule-gap: -0.7,
      below: sp.xx-small,
      case: "upper",
    ),
    // `===` (a role or qualification) and `====` (a sub-grouping), both
    // in the `title` role; the group's is bold.
    subheading: (
      entry: (above: sp.medium, below: sp.medium, weight: ty.title.weight),
      group: (above: sp.small, below: sp.small, weight: fw.bold),
    ),
    column-gutter: 12pt,
    // `name-below` multiplies the body size (`name()` is public); the
    // rest are `em` of the entry's text.
    entry: (
      name-below: sp.small,
      subtitle-below: sp.small * 1em,
      roles-below: sp.x-small * 1em,
      // Between the parts of a compact term row.
      compact-gap: sp.medium * 1em,
    ),
    term: (below: sp.medium, inset: sp.x-small),
    // Both fills lighten the accent (`label-fill` for the darker
    // category pill); the text darkens it.
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
    // Between a skill group's label pill and its keyword pills.
    keyword-row: (gap: sp.medium, hanging-indent: sp.medium * 1em, dash: "-"),
    header: (
      name-below: sp.large,
      pronouns-gap: sp.small,
      headline-below: sp.medium,
      // The contact bar's text and icons, a multiple of the body size:
      // a step below body, so the links don't compete with the name.
      contact-size: 0.9,
      contact-gap: sp.large,
      ornament-gutter: sp.medium * 1em,
      photo-gap: sp.medium,
      // The QR code's side, a multiple of the body size.
      qr: 3.5,
    ),
    // The objective's pull-quote rule and the gaps around the intro.
    intro: (
      above: sp.medium,
      inset: (left: sp.medium, y: sp.xx-small),
      gap: sp.x-small,
      below: sp.x-small,
    ),
    // `radius` and `baseline` place the dots (geometry, not spacing).
    rating: (radius: 0.45, baseline: -0.25, gap: sp.x-small),
    // `glyph` is the glyph's share of its fixed-size box.
    icon: (glyph: 0.9, gap: sp.x-small),
  )
}

#let _theme = _build-theme(_tokens)
