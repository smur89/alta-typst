// `_merge_options`: the caller's labels and preferences, merged over the
// defaults and validated, as the pair `alta()` renders with.

#import "canonical.typ": (
  _canonical_labels, _canonical_preferences, _label_tables, _preference_tables,
)
#import "defaults.typ": _default_labels, _default_preferences
#import "sections.typ": _section_specs
#import "validation.typ": _strict_merge, _validate_labels, _validate_preferences

// The caller's `labels` and `preferences`, each canonicalised before
// its merge over the defaults and validated after it. The raw labels
// go to `_canonical_preferences`, which folds in the deprecated
// `labels.publicationIcons`.
#let _merge_options(labels, preferences) = {
  let merged-labels = _strict_merge(
    _default_labels,
    _canonical_labels(labels),
    "labels",
    tables: _label_tables,
  )
  _validate_labels(merged-labels)
  let merged-preferences = _strict_merge(
    _default_preferences,
    _canonical_preferences(preferences, labels),
    "preferences",
    tables: _preference_tables,
  )
  _validate_preferences(merged-preferences, _section_specs.keys())
  (labels: merged-labels, preferences: merged-preferences)
}
