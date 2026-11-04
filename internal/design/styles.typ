// The paragraph, list and heading rules for everything `alta()`
// renders, from `theme.typ`, and `_treat`, which applies the theme's
// named treatments. `set text` is `_document`'s (`document.typ`).

#import "theme.typ": _theme

// Applies a named treatment from the theme (`_theme.treatment`,
// `section.case`); `"none"` leaves the body as it is.
#let _treatments = (emph: emph, strong: strong, upper: upper, "none": b => b)
#let _treat(name, body) = _treatments.at(name)(body)

// Places an inline graphic on the surrounding text by one rule:
// glyphs stand on the baseline (`to: "baseline"`: `body` as it is, as
// a FontAwesome glyph is drawn to, #211), drawn shapes centre on the
// x-height, measured in context so they line up whatever the font,
// size or neighbours.
#let _inline(body, to: "x-height") = if to == "baseline" { body } else {
  context {
    let height = measure(body).height
    let reference = measure(text(
      top-edge: to,
      bottom-edge: "baseline",
      "x",
    )).height
    box(baseline: (height - reference) / 2, body)
  }
}

// The block a `===` / `====` heading sits in: its `subheading` role's
// spacing, kept with what follows. An entry's first lines
// (`_entry-head`) sit in the same block, so the two can't drift.
#let _subheading-block((above, below, ..), body-size, body) = block(
  above: above * body-size,
  below: below * body-size,
  sticky: true,
  body,
)

// For `show: _content-styles.with(body-size, accent, justify)`.
// Levels: 2 section title, 3 role / qualification, 4 sub-grouping
// (e.g. publication type). `justify` justifies prose only, lists and
// the paragraphs labelled `<alta-prose>`, so rows of facts, names or
// pills never stretch; Typst then hyphenates it too
// (`text.hyphenate` is `auto`).
#let _content-styles(body-size, accent, justify, body) = {
  let (par: p, list: l, section, subheading, ..) = _theme
  let (type: ty, colour, stroke-width: sw, ..) = _theme
  set par(leading: p.leading, spacing: p.spacing)
  show list: set par(justify: justify)
  show <alta-prose>: set par(justify: justify)
  set list(
    marker: [•],
    indent: 0pt,
    body-indent: l.body-indent * body-size,
    spacing: l.spacing,
  )
  let (above, rule-gap, below, case, tracking) = section
  show heading.where(level: 2): it => block(sticky: true)[
    #v(above * body-size)
    #text(
      ty.headline.size * body-size,
      fill: accent,
      weight: ty.headline.weight,
      tracking: tracking,
      _treat(case, it.body),
    )
    #v(rule-gap * body-size)
    #line(length: 100%, stroke: sw.thick + accent)
    #v(below * body-size)
  ]
  let sub-heading(role, fill) = it => _subheading-block(
    role,
    body-size,
    text(ty.title.size * body-size, fill: fill, weight: role.weight, it.body),
  )
  show heading.where(level: 3): sub-heading(subheading.entry, colour.emphasis)
  // In the accent, so a group reads apart from the entries under it.
  show heading.where(level: 4): sub-heading(subheading.group, accent)
  body
}
