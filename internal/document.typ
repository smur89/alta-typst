// The document setup every page renders under: the render-time context
// state, the body text, the page with its footer, and the paragraph,
// list and heading rules. `alta()` applies it, and so does the
// component gallery (`tests/visual/components/test.typ`), so the gallery shows
// components exactly as a CV does.

#import "design/styles.typ": _content-styles, _part
#import "design/theme.typ": _theme-for, _token-prefs
#import "context.typ": (
  _body-size-state, _icon-alts-state, _max-rating-state, _theme-state,
)

// For `show: _document.with(prefs, labels, footer: ...)`, with the
// merged, validated preferences and labels.
#let _document(prefs, labels, footer: none, body) = {
  let (bodySize: body-size, maxRating: max-rating, ..) = prefs
  let theme = _theme-for(prefs.theme, _token-prefs(prefs))
  _theme-state.update(theme)
  _body-size-state.update(body-size)
  _max-rating-state.update(max-rating)
  _icon-alts-state.update((date: labels.date, location: labels.location))
  // Before `set page`, so the footer inherits the font and language.
  set text(
    body-size,
    font: theme.font,
    weight: theme.type.body.weight,
    fill: theme.colours.body,
    lang: labels.lang,
  )
  set page(
    paper: prefs.paper,
    margin: prefs.margin,
    footer: _part("footer", footer),
  )
  show: _content-styles.with(body-size, theme, prefs.justify)
  body
}
