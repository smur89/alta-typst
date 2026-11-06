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
// labels start from its bundled translation, if any, over the English.
#let _merge-options(labels, preferences, lang: "en") = {
  let (labels, preferences) = _kebab-options(labels, preferences)
  for table in _preference-tables {
    let icons = _dict-or-empty(preferences).at(table, default: none)
    if type(icons) == dictionary {
      _check-icon-names(icons, table)
    }
  }
  let lang = _dict-or-empty(labels).at("lang", default: lang)
  // A non-string `labels.lang` has no translation; validation names it.
  let translation = if type(lang) == str {
    _translations.at(lang, default: (:))
  } else { (:) }
  let merged-labels = _strict-merge(
    _strict-merge(
      _default-labels,
      translation + (lang: lang),
      "labels",
      tables: _label-tables,
    ),
    _canonical-labels(labels),
    "labels",
    tables: _label-tables,
  )
  _validate-labels(merged-labels)
  let merged-preferences = _strict-merge(
    _default-preferences,
    _canonical-preferences(preferences, labels),
    "preferences",
    tables: _preference-tables,
  )
  _validate-preferences(merged-preferences, _section-specs.keys())
  (labels: merged-labels, prefs: merged-preferences)
}

// `altacv`'s `theme`, checked as `preferences.theme` is, without the
// rest of the preferences.
#let _checked-theme(theme) = {
  _check-theme(theme)
  theme
}

// Inside the `altacv` template, what each document-level preference
// is instead: a template argument or a `set` rule after the show line.
#let _template-replacements = (
  theme: "`altacv.with(theme: ..)`",
  accent: "`altacv.with(theme: ..)` (the deprecated `accent` is a theme colour)",
  colours: "theme tokens: `altacv.with(theme: themes.teal + (colours: (..themes.teal.colours, accent: ..)))`",
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
