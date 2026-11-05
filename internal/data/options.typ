// `_merge-options`: the caller's labels and preferences, merged over the
// defaults and validated, as the pair `alta()` renders with.

#import "canonical.typ": (
  _canonical-labels, _canonical-preferences, _label-tables, _preference-tables,
)
#import "../util/fields.typ": _dict-or-empty
#import "defaults.typ": _default-labels, _default-preferences, _translations
#import "sections.typ": _section-specs
#import "validation.typ": (
  _check-icon-names, _strict-merge, _validate-labels, _validate-preferences,
)

// The caller's `labels` and `preferences`, each canonicalised before
// its merge over the defaults and validated after it. The raw labels
// go to `_canonical-preferences`, which folds in the deprecated
// `labels.publicationIcons`. Only the caller's own icon names are
// checked, before that fold: the deprecated label's are left to fail
// where used, so an unused bad one doesn't stop a CV compiling.
// `projectIcons` and `profileIcons` have no such fold but are checked
// the same way, each against its own rule (`_icon-table-rules`).
//
// `lang` is the document's language (`text.lang` where `alta()` is
// called); the deprecated `labels.lang` wins over it (#239). The
// labels start from its bundled translation, if any, over the English.
#let _merge-options(labels, preferences, lang: "en") = {
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
