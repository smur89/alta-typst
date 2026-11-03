// The paragraph, list and heading rules for everything `alta()`
// renders, from `theme.typ`, and `_treat`, which applies the theme's
// named treatments. `set text` is `_document`'s (`document.typ`).

#import "theme.typ": _theme

// Applies a named treatment from the theme (`_theme.treatment`,
// `section.case`); `"none"` leaves the body as it is.
#let _treatments = (emph: emph, strong: strong, upper: upper, "none": b => b)
#let _treat(name, body) = _treatments.at(name)(body)

// For `show: _content-styles.with(body-size, accent)`. Levels: 2
// section title, 3 role / qualification, 4 sub-grouping (e.g.
// publication type).
#let _content-styles(body-size, accent, body) = {
  let (par: p, list: l, section, subheading, ..) = _theme
  let (type: ty, colour, stroke-width: sw, ..) = _theme
  set par(leading: p.leading, spacing: p.spacing)
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
  let sub-heading((above, below, weight), fill) = it => block(
    above: above * body-size,
    below: below * body-size,
    sticky: true,
    text(ty.title.size * body-size, fill: fill, weight: weight, it.body),
  )
  show heading.where(level: 3): sub-heading(subheading.entry, colour.emphasis)
  // In the accent, so a group reads apart from the entries under it.
  show heading.where(level: 4): sub-heading(subheading.group, accent)
  body
}
