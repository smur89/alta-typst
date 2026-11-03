// The template's look in one place: colours, the type scale, and each
// component's gaps and line weights. Data only; `styles.typ` applies
// the document-wide rules.
//
// Sizes scale with the body size. Unitless numbers are multiples of
// it: public helpers (`tag`, `term`, `divider`, `rating`, `icon`) read
// the body size from state and multiply, since they may sit outside
// `alta()`'s text. `em` lengths are relative to the enclosing text,
// for internal helpers where that's the intent. Absolute lengths
// (gutter, rule thicknesses) deliberately don't scale.
//
// The accent and body size are preferences, kept in `state.typ`;
// nothing here is configurable yet. A function reading several values
// of one component destructures it; a single read uses the path.

#let _grey = rgb("#666666")

// Text sizes, relative to body text.
#let _size = (
  name: 2.5,
  section: 1.7,
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
  par: (leading: 0.55em, spacing: 0.7em),
  list: (body-indent: 0.4, spacing: 0.55em),
  // `==` headings: the gap above, the pull up to the rule, the rule,
  // and the gap below it.
  section: (above: 0.6, rule-gap: -0.7, rule: 2pt, below: 0.2),
  // `===` (a role or qualification) and `====` (a sub-grouping, whose
  // icon matches its size). `weight` tells the two apart.
  subheading: (
    entry: (size: _size.subheading, above: 1.0, below: 0.8, weight: "regular"),
    group: (size: _size.subheading, above: 0.6, below: 0.6, weight: "bold"),
  ),
  column-gutter: 12pt,
  entry: (
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
    gap: 0.25,
  ),
  divider: (
    stroke: (paint: rgb("#D1D1D1"), thickness: 0.6pt, dash: "dashed"),
    gap: 0.3,
    clearance: 0.5cm,
  ),
  keyword-row: (gap: 0.7, hanging-indent: 1em),
  header: (
    name-below: 1.2,
    pronouns-gap: 0.5,
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
    inset: (x: 0.7, y: 0.15),
    gap: 0.3,
    below: 0.4,
  ),
  rating: (radius: 0.45, baseline: -0.25, gap: 0.4),
  // `glyph` is the glyph's share of its fixed-size box.
  icon: (glyph: 0.9, gap: 0.3),
)
