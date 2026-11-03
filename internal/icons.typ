// `icon()`: draws a logical icon name's FontAwesome glyph (the names
// and glyphs are in `data/icon-names.typ`) at a fixed size.
// `@preview/fontawesome` resolves glyphs against the desktop FA fonts,
// which are not vendored: users need them installed locally, or must
// compile on typst.app, which preinstalls them.

#import "@preview/fontawesome:0.6.2": fa-icon
#import "design/theme.typ": _theme
#import "context.typ": _body_size_state
#import "data/icon-names.typ": _icon_glyphs, _solid_names

// Emits a trailing `h(...)` so callers needn't space icons themselves.
// The fixed-size box evens out FA's varied glyph widths, which would
// otherwise jitter icon-led rows.
//
// By default the glyph is a `pdf.artifact`, so screen readers skip it
// rather than read a private-use codepoint aloud. When the icon alone
// carries meaning (a network beside a bare username), `alt` wraps it
// in `figure(alt: ...)` instead, as `box` and `link` take no alt text;
// the outer `box` keeps the figure inline.
#let icon(name, size: auto, shift: 0pt, fill: auto, alt: none) = context {
  let body-size = _body_size_state.get()
  let resolved-size = if size == auto { body-size } else { size }
  let resolved-fill = if fill == auto { _theme.colour.body } else { fill }

  let glyph = _icon_glyphs.at(name)
  let solid = name in _solid_names
  let mark = box(
    baseline: shift,
    width: resolved-size,
    height: resolved-size,
    align(
      center + horizon,
      fa-icon(
        glyph,
        solid: solid,
        size: _theme.icon.glyph * resolved-size,
        fill: resolved-fill,
      ),
    ),
  )
  if alt == none { pdf.artifact(mark) } else {
    box(figure(
      mark,
      alt: alt,
      numbering: none,
      outlined: false,
      gap: 0pt,
    ))
  }
  h(_theme.icon.gap * body-size)
}
