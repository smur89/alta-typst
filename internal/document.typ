// The document setup every page renders under: the render-time context
// state, the body text, the page with its footer, and the paragraph,
// list and heading rules. `alta()` applies it, and so does the
// component gallery (`tests/components.typ`), so the gallery shows
// components exactly as a CV does.

#import "design/styles.typ": _content-styles
#import "design/theme.typ": _theme
#import "context.typ": _accent-state, _body-size-state, _max-rating-state

// For `show: _document.with(prefs, labels, footer: ...)`, with the
// merged, validated preferences and labels.
#let _document(prefs, labels, footer: none, body) = {
  let (accent, bodySize: body-size, maxRating: max-rating, ..) = prefs
  _accent-state.update(accent)
  _body-size-state.update(body-size)
  _max-rating-state.update(max-rating)
  // Before `set page`, so the footer inherits the font and language.
  set text(
    body-size,
    font: prefs.font,
    fill: _theme.colour.body,
    lang: labels.lang,
  )
  set page(paper: prefs.paper, margin: prefs.margin, footer: footer)
  show: _content-styles.with(body-size, accent, prefs.justify)
  body
}
