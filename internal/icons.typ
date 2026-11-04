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
// Decorative is a `pdf.artifact`, so screen readers skip the
// private-use codepoint rather than read it; `alt` wraps the glyph in
// `_alt-figure` instead, the outer `box` keeping the figure inline.
/// A FontAwesome glyph from altacv's icon set, standing on the text's
/// baseline. Decorative in tagged PDF unless `alt` is given.
///
/// - name (str): A key of the icon set (a utility icon or a profile
///   network, e.g. `"calendar"`, `"github"`). Unknown names panic.
/// - size (auto, length): The glyph's box; `auto` is the body size.
/// - shift (length): A vertical offset from the baseline.
/// - fill (auto, color): The glyph's colour; `auto` is the body text's.
/// - alt (str, none): Alt text, when the icon alone carries meaning.
/// -> content
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
  let mark = box(baseline: shift, _inline(to: "baseline", box(
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
  )))
  if alt == none { pdf.artifact(mark) } else {
    box(_alt-figure(mark, alt))
  }
  h(_theme.icon.gap * body-size)
}
