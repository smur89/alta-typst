// The template's look. `_tokens` are the font and the scales, with
// their defaults; `_build-theme` maps them onto the roles components
// read. A role exists only where components differ by design;
// otherwise they read tokens. A theme (`presets.typ`) overrides any of
// the tokens: `_theme-for` merges it, then the preferences that
// override tokens (`_token-prefs`), over `_tokens` and builds, once per
// render, into the state components read (`_theme-state`).
//
// Type sizes and `space` multiply the body size; public helpers
// (`tag`, `term`, `divider`, `rating`, `icon`) read it from state, as
// they may sit outside `alta()`. `em` roles follow their own text;
// `pt` and `cm` lengths don't scale.

#import "../util/values.typ": _deep-merge

// The roles the deprecated top-level `accent` colours with one
// colour, as the built-in themes did before each took its own shades.
#let _accent-roles(accent) = (
  accent: accent,
  heading: accent,
  headingRule: accent,
  subheading: accent,
  name: accent,
)

// A built-in theme's colours: tones of one hue (`presets.typ`), the
// group titles in its `accent` and the tagline in its `emphasis`.
#let _hue-colours(colours) = (
  colours + (subheading: colours.accent, tagline: colours.emphasis)
)

// WCAG's contrast ratio of `c` on the white page.
#let _contrast(c) = {
  let (r, g, b) = rgb(c)
    .components(alpha: false)
    .map(v => {
      let x = v / 100%
      if x <= 0.04045 { x / 12.92 } else { calc.pow((x + 0.055) / 1.055, 2.4) }
    })
  1.05 / (0.2126 * r + 0.7152 * g + 0.0722 * b + 0.05)
}

#let _tokens = (
  // The family, or a fallback array of them. Must be installed on the
  // build host (CI installs it: apt in setup-typst, apk in the pinned
  // image).
  font: "Lato",
  // Material Design 3's type roles: `display` the name, `headline` a
  // section title, `title` a heading, `body` the rest (quieter lines
  // differ by colour, not size).
  type: (
    display: (size: 2.5, weight: "bold"),
    headline: (size: 1.4, weight: "bold"),
    title: (size: 1.2, weight: "semibold"),
    // No size: `bodySize` is the body's. The weight is the body text's
    // (`_document`) and the pills'.
    body: (weight: "regular"),
  ),
  // To embolden within a role.
  font-weight: (regular: "regular", bold: "bold"),
  // The colour roles (`preferences.colours`), the teal theme's (the
  // default): see `presets.typ` for how a theme's roles relate.
  // `emphasis` and `body` follow Bootstrap's roles.
  colours: _hue-colours((
    name: rgb("#0A4F48"),
    heading: rgb("#00796B"),
    headingRule: rgb("#8EC5BD"),
    accent: rgb("#00796B"),
    emphasis: rgb("#1D2B29"),
    body: rgb("#53605D"),
  )),
  // `Manager, Pied Piper · 2024`: `items` within a group (a location's
  // parts too), `facts` between groups; `label` after an interest
  // group's name (`Music: Trad, Jazz`) and the footer's "Last
  // updated"; `range` between a period's dates; `keywords` between an
  // entry's keywords (a project's stack, education's courses).
  separator: (
    facts: " · ",
    items: ", ",
    label: ": ",
    range: " – ",
    keywords: " · ",
  ),
  // A publication's citation, `ACM 12(3), 45–67`: the brackets around
  // the issue, before the pages, between the publisher and the rest,
  // and the dash that replaces hyphens in a page range (unspaced, where
  // `separator.range` between dates is spaced).
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
    font: tokens.font,
    type: ty,
    font-weight: fw,
    stroke-width: sw.pairs().map(((k, v)) => (k, v * 1pt)).to-dict(),
    separator: tokens.separator,
    citation: tokens.citation,
    treatment: tokens.treatment,
    // `secondary` (the quietest lines) and `border` (dividers, empty
    // rating dots) derive from `body`: `secondary` its palest tint, up
    // to 35%, that keeps WCAG AA's 4.5:1 on white (`body` itself if
    // none does).
    colours: (
      tokens.colours
        + (
          secondary: range(35, -1, step: -1)
            .map(p => tokens.colours.body.lighten(p * 1%))
            .filter(c => _contrast(c) >= 4.5)
            .at(0, default: tokens.colours.body),
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
    // Fills and the outline lighten the accent, the text darkens it:
    // a soft outline, so a row of pills reads as one band of tint.
    tag: (
      fill: 85%,
      label-fill: 70%,
      stroke-lighten: 45%,
      text-darken: 25%,
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

// The theme with no overrides: the state's default, for public helpers
// used outside `alta()`.
#let _default-theme = _build-theme(_tokens)

// The preferences that override a theme's tokens, as tokens: `colours`,
// and `font` unless `auto` (the theme's).
#let _token-prefs(prefs) = (
  (colours: prefs.colours)
    + if prefs.font != auto { (font: prefs.font) } else { (:) }
)

// The names `_treat` (`styles.typ`) applies, for a theme's
// `treatment` tokens.
#let _treatment-names = ("emph", "italic", "strong", "upper", "none")

// The theme to render with: the chosen theme's tokens, then
// `overrides` (`_token-prefs`), over `_tokens`. Either may set only
// some tokens.
#let _theme-for(theme, overrides) = _build-theme(
  (theme, overrides).fold(_tokens, _deep-merge),
)
