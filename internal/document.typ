// The `altacv` template's body, applied by `altacv` (`render.typ`) and
// by the component gallery (`tests/components.typ`), so the gallery
// shows components exactly as a CV does. It holds the theme state, the
// body text and margins, and the paragraph, list and heading rules.

#import "design/styles.typ": _content-styles
#import "context.typ": _theme-state

// The `altacv` template's body (`render.typ`), with the built theme:
// the theme state, the default text and margins, and the paragraph,
// list and heading rules. A user's `set` rules after it win: the page
// size, the text's size, font and language, the footer.
#let _document(theme, margin, body) = {
  _theme-state.update(theme)
  set text(
    10pt,
    font: theme.font,
    weight: theme.type.body.weight,
    fill: theme.colours.body,
  )
  set page(margin: margin)
  show: _content-styles.with(theme)
  body
}
