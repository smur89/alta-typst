// The paragraph, list and heading rules for everything `alta()`
// renders, from `theme.typ`. `set text` stays in `alta()`: it must
// precede `set page` so the footer inherits the font and language.

#import "theme.typ": _theme

// For `show: _content_styles.with(body-size, accent)`. Levels: 2
// section title, 3 role / qualification, 4 sub-grouping (e.g.
// publication type).
#let _content_styles(body-size, accent, body) = {
  let (par: p, list: l, section, subheading, size, colour, ..) = _theme
  set par(leading: p.leading, spacing: p.spacing)
  set list(
    marker: text(l.marker * 1em, "•"),
    indent: 0pt,
    body-indent: l.body-indent * body-size,
    spacing: l.spacing,
  )
  show heading.where(level: 2): it => block(sticky: true)[
    #v(section.above * body-size)
    #text(size.section * body-size, fill: accent, weight: "bold", upper(
      it.body,
    ))
    #v(section.rule-gap * body-size)
    #line(length: 100%, stroke: section.rule + accent)
    #v(section.below * body-size)
  ]
  let sub-heading((above, below, weight)) = it => block(
    above: above * body-size,
    below: below * body-size,
    sticky: true,
    text(
      size.subheading * body-size,
      fill: colour.emphasis,
      weight: weight,
      it.body,
    ),
  )
  show heading.where(level: 3): sub-heading(subheading.entry)
  show heading.where(level: 4): sub-heading(subheading.group)
  body
}
