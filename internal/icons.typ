// `icon()`: draws a logical icon name's FontAwesome glyph (the names
// and glyphs are in `design/icon-set.typ`) at a fixed size.
// `@preview/fontawesome` resolves glyphs against the desktop FA fonts,
// which are not vendored: users need them installed locally, or must
// compile on typst.app, which preinstalls them.

#import "@preview/fontawesome:0.6.2": fa-icon
#import "design/icon-set.typ": _icon-glyphs, _solid-names
#import "util/checks.typ": _check, _enum-rule
#import "design/styles.typ": _inline
#import "design/theme.typ": _theme
#import "context.typ": _body-size-state

// `body` with `alt` as its alt text in tagged PDF. `figure` is Typst's
// carrier for alt text on non-image content, as `box` and `link` take
// none; unnumbered, unoutlined and gap-free, it leaves the layout
// unchanged.
#let _alt-figure(body, alt) = figure(
  body,
  alt: alt,
  numbering: none,
  outlined: false,
  gap: 0pt,
)

// Emits a trailing `h(...)` so callers needn't space icons themselves.
// The fixed-size box evens out FA's varied glyph widths, which would
// otherwise jitter icon-led rows.
//
// By default the glyph is a `pdf.artifact`, so screen readers skip it
// rather than read a private-use codepoint aloud. When the icon alone
// carries meaning (a network beside a bare username), `alt` wraps it
// in `_alt-figure` instead; the outer `box` keeps the figure inline.
#let icon(name, size: auto, shift: 0pt, fill: auto, alt: none) = context {
  let body-size = _body-size-state.get()
  let resolved-size = if size == auto { body-size } else { size }
  let resolved-fill = if fill == auto { _theme.colour.body } else { fill }

  // A public helper, so it checks its own argument; the prose list is
  // built only on a miss.
  if name not in _icon-glyphs {
    _check("icon() name", name, _enum-rule(_icon-glyphs.keys()))
  }
  let glyph = _icon-glyphs.at(name)
  let solid = name in _solid-names
  // Laid out by its ink (`bounds`), not the icon font's metrics, so
  // `_inline` centres what's drawn on the cap height; then moved by
  // `shift`.
  let mark = box(baseline: shift, _inline(to: "cap-height", box(
    width: resolved-size,
    height: resolved-size,
    align(center + horizon, {
      set text(top-edge: "bounds", bottom-edge: "bounds")
      fa-icon(
        glyph,
        solid: solid,
        size: _theme.icon.glyph * resolved-size,
        fill: resolved-fill,
      )
    }),
  )))
  if alt == none { pdf.artifact(mark) } else {
    box(_alt-figure(mark, alt))
  }
  h(_theme.icon.gap * body-size)
}
