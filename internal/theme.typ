// The template's look in one place: colours, the type scale,
// separators, and each component's gaps, line weights and type
// treatment. Data only, so it could come from a file: treatments are
// named (`"emph"`, `"strong"`, `"upper"`) and `_treat` (`text.typ`)
// applies them. `styles.typ` applies the document-wide rules.
//
// Sizes scale with the body size. Unitless numbers are multiples of
// it: public helpers (`tag`, `term`, `divider`, `rating`, `icon`) read
// the body size from state and multiply, since they may sit outside
// `alta()`'s text. `em` lengths are relative to the enclosing text,
// for internal helpers where that's the intent. `pt` and `cm` lengths
// (the column gutter, rules and strokes, the pill radius, the divider
// clearance) deliberately don't scale.
//
// The accent and body size are preferences, kept in `state.typ`;
// nothing here is configurable yet. A function reading several values
// of one component destructures it; a single read uses the path.

#let _grey = rgb("#666666")

// Text sizes, relative to body text.
#let _size = (
  name: 2.5,
  section: 1.7,
  // `===` and `====` headings, and the icon leading a `====` group.
  subheading: 1.2,
  term: 0.9,
  // Secondary lines: a subtitle, a fluency label, authors, pills.
  small: 0.85,
  // The quietest: publication dates and identifiers (in
  // `colour.meta`), the footers and the contact bar.
  meta: 0.8,
)

#let _theme = (
  colour: (
    body: _grey,
    meta: _grey.lighten(35%),
    emphasis: rgb("#2E2E2E"),
    empty-dot: rgb("#c0c0c0"),
  ),
  size: _size,
  // Between facts on one line (`Manager, Pied Piper · 2024`): `facts`
  // between groups, `items` within one.
  separator: (facts: " · ", items: ", "),
  // Named treatments: a `summary` or other preamble, a `styled-link`
  // title, and the CV owner among a publication's authors.
  treatment: (preamble: "emph", link: "emph", owner: "strong"),
  par: (leading: 0.55em, spacing: 0.7em),
  list: (marker: 0.85, body-indent: 0.4, spacing: 0.55em),
  // `==` headings: the gap above, the pull up to the rule, the rule,
  // and the gap below it.
  section: (
    above: 0.6,
    rule-gap: -0.7,
    rule: 2pt,
    below: 0.2,
    weight: "bold",
    case: "upper",
  ),
  // `===` (a role or qualification) and `====` (a sub-grouping), both
  // at `size.subheading`. `weight` tells the two apart.
  subheading: (
    entry: (above: 1.0, below: 0.8, weight: "regular"),
    group: (above: 0.6, below: 0.6, weight: "bold"),
  ),
  column-gutter: 12pt,
  // `name-below` multiplies the body size (`name()` is public); the
  // rest are `em` of the entry's text.
  entry: (
    // The organisation line (`name()`) and a compact entry's issuer.
    org-weight: "bold",
    name-below: 0.6,
    subtitle-below: 0.5em,
    roles-below: 0.4em,
    // Between the parts of a compact term row, in its smaller text.
    compact-gap: 1em,
  ),
  term: (below: 0.8, inset: 0.3),
  // Both fills lighten the accent (`label-fill` for the darker
  // category pill); the text darkens it.
  tag: (
    fill: 85%,
    label-fill: 70%,
    text-darken: 15%,
    stroke: 0.5pt,
    radius: 2.5pt,
    inset: (x: 0.4, y: 0.15),
    outset-y: 0.15,
    gap: 0.25,
    weight: "regular",
    label-weight: "bold",
  ),
  divider: (
    stroke: (paint: rgb("#D1D1D1"), thickness: 0.6pt, dash: "dashed"),
    gap: 0.3,
    clearance: 0.5cm,
  ),
  // Between a skill group's label pill and its keyword pills.
  keyword-row: (gap: 0.7, hanging-indent: 1em, dash: "-"),
  header: (
    name-weight: "bold",
    headline-weight: "bold",
    contact-weight: "bold",
    name-below: 1.2,
    pronouns-gap: 0.5,
    headline: 1.2,
    headline-below: 0.8,
    contact-icon: 0.9,
    contact-gap: 1.2,
    ornament-gutter: 1em,
    photo-gap: 0.8,
    qr: 3.5,
  ),
  // The objective's pull-quote rule and the gaps around the intro.
  intro: (
    above: 0.8,
    rule: 1.5pt,
    inset: (left: 0.7, y: 0.15),
    gap: 0.3,
    below: 0.4,
  ),
  rating: (radius: 0.45, baseline: -0.25, gap: 0.4),
  // `glyph` is the glyph's share of its fixed-size box.
  icon: (glyph: 0.9, gap: 0.3),
)
