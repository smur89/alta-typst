// `_merge-options`: the caller's labels and preferences, merged over the
// defaults and validated, as the pair `alta()` renders with.

#import "canonical.typ": (
  _canonical-labels, _canonical-preferences, _label-tables, _preference-tables,
)
#import "defaults.typ": _default-labels, _default-preferences
#import "sections.typ": _section-specs
#import "validation.typ": _strict-merge, _validate-labels, _validate-preferences

// The caller's `labels` and `preferences`, each canonicalised before
// its merge over the defaults and validated after it. The raw labels
// go to `_canonical-preferences`, which folds in the deprecated
// `labels.publicationIcons`.
#let _merge-options(labels, preferences) = {
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
