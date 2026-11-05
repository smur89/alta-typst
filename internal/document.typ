// The `altacv` template's body, applied by `altacv` and standalone
// `alta()` (`render.typ`) and by the component gallery
// (`tests/components.typ`), which adds the CV's own styles
// (`_cv-styles`), so it shows components exactly as a CV does.

#import "design/styles.typ": _content-styles, _part
#import "design/theme.typ": _theme-for, _token-prefs
#import "context.typ": _theme-state

// The theme state, the default text and margins, and the paragraph,
// list and heading rules, from the built theme and the body size and
// margins `data/` resolves: what a user's rules after `altacv`
// override. A `scoped` template's theme ends with its body;
// standalone `alta()`'s stays set for the content after it, as the
// public helpers (`tag`, `rating`, …) there read it.
#let _document(theme, size, margin, body, scoped: true) = {
  _theme-state.update(themes => themes + (theme,))
  set text(
    size,
    font: theme.font,
    weight: theme.type.body.weight,
    fill: theme.colours.body,
  )
  set page(margin: margin)
  show: _content-styles.with(theme)
  body
  if scoped { _theme-state.update(themes => themes.slice(0, -1)) }
}

// For `show: _standalone.with(prefs, labels, footer)`, with the merged,
// validated preferences and labels: the template's body, then the
// preferences that stand in for a user's set rules after it.
#let _standalone(prefs, labels, footer, body) = {
  show: _document.with(
    _theme-for(prefs.theme, _token-prefs(prefs)),
    prefs.body-size,
    prefs.margin,
    scoped: false,
  )
  // `text.lang` unless the deprecated `labels.lang` is set; drop with
  // it (#239). Before `set page`, so the footer inherits it.
  set text(lang: labels.lang)
  set page(paper: prefs.paper, footer: _part("footer", footer))
  body
}
