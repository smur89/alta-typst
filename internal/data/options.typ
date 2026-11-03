// `_merge-options`: the caller's labels and preferences, merged over the
// defaults and validated, as the pair `alta()` renders with.

#import "canonical.typ": (
  _canonical-labels, _canonical-preferences, _label-tables, _preference-tables,
)
#import "../util/fields.typ": _dict-or-empty
#import "defaults.typ": _default-labels, _default-preferences
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
// `projectIcons` has no such fold but is checked the same way.
#let _merge-options(labels, preferences) = {
  for table in _preference-tables {
    let icons = _dict-or-empty(preferences).at(table, default: none)
    if type(icons) == dictionary {
      _check-icon-names(icons, "preferences." + table)
    }
  }
  let merged-labels = _strict-merge(
    _default-labels,
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
