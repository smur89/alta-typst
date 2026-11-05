// The `altacv` template's body, applied by `altacv` and standalone
// `alta()` (`render.typ`) and by the component gallery
// (`tests/components.typ`), so the gallery shows components exactly as
// a CV does.

#import "design/styles.typ": _content-styles, _part
#import "design/theme.typ": _theme-for, _token-prefs
#import "context.typ": _theme-state

// With the built theme: the theme state, the default text and margins,
// and the paragraph, list and heading rules: what a user's rules after
// `altacv` override.
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

// For `show: _standalone.with(prefs, labels, footer)`, with the merged,
// validated preferences and labels: the template's body, then the
// preferences that stand in for a user's set rules after it.
#let _standalone(prefs, labels, footer, body) = {
  show: _document.with(
    _theme-for(prefs.theme, _token-prefs(prefs)),
    prefs.margin,
  )
  // `text.lang` unless the deprecated `labels.lang` is set; drop with
  // it (#239). Before `set page`, so the footer inherits it.
  set text(prefs.body-size, lang: labels.lang)
  set page(paper: prefs.paper, footer: _part("footer", footer))
  body
}
