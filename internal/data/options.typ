// `_merge-options`: the caller's labels and preferences, merged over the
// defaults and validated, as the pair `alta()` renders with.

#import "canonical.typ": (
  _canonical-labels, _canonical-preferences, _kebab-options, _label-tables,
  _preference-tables,
)
#import "../util/fields.typ": _dict-or-empty
#import "defaults.typ": _default-labels, _default-preferences, _translations
#import "sections.typ": _section-specs
#import "validation.typ": (
  _check-icon-names, _check-theme, _strict-merge, _validate-labels,
  _validate-preferences,
)

// The theme is the template's: `theme` and `colours` aren't
// preferences, in the template or standalone. The deprecated `accent`
// still recolours standalone `alta()` (#239).
#let _check-theme-routed(preferences) = {
  for key in ("theme", "colours") {
    if key in _dict-or-empty(preferences) {
      panic(
        "preferences."
          + key
          + " isn't an alta() preference: theme the CV with `#show: altacv.with(theme: themes.navy)` before `#alta(cv)`, and recolour a theme as `themes.navy + (colours: (..themes.navy.colours, accent: ..))`.",
      )
    }
  }
}

// The one label resolver: the English defaults, the bundled
// translation for `lang` (if any), then each layer of overrides in
// turn, already in kebab-case, canonicalised and merged; validated. The layers
// are the templates' (`altacv.with(labels: ..)`, outermost first),
// then a call's (`alta(cv, labels: ..)`), so a later layer wins.
#let _resolve-labels(lang, ..layers) = {
  // A non-string `labels.lang` has no translation; validation names it.
  let translation = if type(lang) == str {
    _translations.at(lang, default: (:))
  } else { (:) }
  let merge(labels, layer) = _strict-merge(
    labels,
    layer,
    "labels",
    tables: _label-tables,
  )
  let merged = layers
    .pos()
    .map(_canonical-labels)
    .fold(merge(_default-labels, translation + (lang: lang)), merge)
  _validate-labels(merged)
  merged
}

// The caller's `labels` and `preferences`, each canonicalised before
// its merge over the defaults and validated after it. The raw labels
// go to `_canonical-preferences`, which folds in the deprecated
// `labels.publication-icons`. Only the caller's own icon names are
// checked, before that fold: the deprecated label's are left to fail
// where used, so an unused bad one doesn't stop a CV compiling.
// `project-icons` and `profile-icons` have no such fold but are checked
// the same way, each against its own rule (`_icon-table-rules`).
//
// Option names are read in kebab-case first (`_kebab-options`), so
// every step after it, the icon-name checks included, sees one form.
//
// `lang` is the document's language (`text.lang` where `alta()` is
// called); the deprecated `labels.lang` wins over it (#239). The
// labels resolve over the enclosing templates' (`template`, the
// `_labels-state` stack), the caller's last.
#let _merge-options(labels, preferences, lang: "en", template: ()) = {
  let (labels, preferences) = _kebab-options(labels, preferences)
  _check-theme-routed(preferences)
  for table in _preference-tables {
    let icons = _dict-or-empty(preferences).at(table, default: none)
    if type(icons) == dictionary {
      _check-icon-names(icons, table)
    }
  }
  let merged-labels = _resolve-labels(
    _dict-or-empty(labels).at("lang", default: lang),
    ..template,
    labels,
  )
  let merged-preferences = _strict-merge(
    _default-preferences,
    _canonical-preferences(preferences, labels),
    "preferences",
    tables: _preference-tables,
  )
  _validate-preferences(merged-preferences, _section-specs.keys())
  (labels: merged-labels, prefs: merged-preferences)
}

// `altacv`'s `labels`, in kebab-case for `_labels-state`, checked as
// `alta()`'s are: over the English, as the language they render in is
// known only where they're read. Neither the deprecated `lang` nor the
// deprecated `publication-icons` is a label there: the first is
// `set text`'s, the second a preference.
#let _template-labels(labels) = {
  let (labels, _) = _kebab-options(labels, (:))
  let instead = (
    lang: "`set text(lang: ..)` after `#show: altacv.with(..)`",
    publication-icons: "`alta(cv, preferences: (publication-icons: ..))`",
  )
  for (key, use) in instead {
    if key in _dict-or-empty(labels) {
      panic("labels." + key + " isn't an altacv() label: use " + use + ".")
    }
  }
  let _ = _resolve-labels("en", labels)
  labels
}

// `altacv`'s `theme`, checked, without the
// rest of the preferences.
#let _checked-theme(theme) = {
  _check-theme(theme)
  theme
}

// Inside the `altacv` template, what each document-level preference
// is instead: a template argument or a `set` rule after the show line.
#let _template-replacements = (
  accent: "`altacv.with(theme: ..)` (the deprecated `accent` is a theme colour)",
  font: "`set text(font: ..)`",
  body-size: "`set text(size: ..)`",
  paper: "`set page(paper: ..)`",
  margin: "`set page(margin: ..)`",
  page-footer: "`set page(footer: cv-footer())` for `auto`, or `set page(footer: ..)` with your own content",
  last-modified-footer: "`set page(footer: cv-updated-footer())`",
  footer-version: "`set page(footer: cv-updated-footer(version: true))`",
)

// Panics on a document-level preference passed to `alta()` inside the
// template, naming what replaces it, and on the deprecated `labels.lang`,
// which the document's `text.lang` replaces. camelCase names count
// (#389).
#let _check-template-preferences(labels, preferences) = {
  let (labels, prefs) = _kebab-options(labels, preferences)
  if "lang" in _dict-or-empty(labels) {
    panic(
      "labels.lang isn't an alta() label inside the altacv template: use `set text(lang: ..)` after `#show: altacv.with(..)`.",
    )
  }
  for key in _dict-or-empty(prefs).keys() {
    if key in _template-replacements {
      panic(
        "preferences."
          + key
          + " isn't an alta() preference inside the altacv template: use "
          + _template-replacements.at(key)
          + " after `#show: altacv.with(..)`.",
      )
    }
  }
}
