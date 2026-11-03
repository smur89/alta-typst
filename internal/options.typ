// The preferences' defaults, and `_merge_options`, which turns the
// caller's labels and preferences into the merged, validated pair
// `alta()` renders with. Here, not in `data/defaults.typ`, because the
// column defaults derive from the section registry.

#import "design/presets.typ": palettes
#import "data/canonical.typ": (
  _canonical_labels, _canonical_preferences, _label_tables, _preference_tables,
)
#import "data/defaults.typ": _default_labels, maps-providers
#import "data/icon-names.typ": _publication_icons
#import "data/sections.typ": _keys_for_column, _section_specs
#import "data/validation.typ": (
  _strict_merge, _validate_labels, _validate_preferences,
)
#import "primitives.typ": name

// Documented in the README's preferences tables and grouped as there,
// which is also the order the "Supported:" list of an unknown-key
// panic follows. Comments here note only constraints the README
// doesn't need.
#let _default_preferences = (
  // Look.
  // Must be installed on the build host (CI installs it: apt in
  // setup-typst, apk in the pinned image).
  font: "Lato",
  bodySize: 10pt,
  accent: palettes.teal,
  publicationIcons: _publication_icons,
  // Header.
  // Visual only: PDF title / author metadata keep the name as given.
  uppercaseName: true,
  showPronouns: false,
  headerTextAlign: "left",
  imageSize: 6em,
  imagePosition: "right",
  imageStackOrder: "above",
  qrCode: none,
  // Page and layout.
  paper: "a4",
  margin: (x: 0.9cm, y: 1.5cm),
  columnRatio: 0.65,
  leftColumnSections: _keys_for_column("left"),
  rightColumnSections: _keys_for_column("right"),
  // Footer.
  pageFooter: none,
  lastModifiedFooter: false,
  // Rides the `lastModifiedFooter` line; no-op without it.
  footerVersion: false,
  // Formatting and links.
  dateFormat: "long",
  linkContactInfo: true,
  mapsProvider: maps-providers.google,
  maxRating: 5,
  // Deprecated, removed in the next major (#239). `groupCertificates`
  // is ignored; `_canonical_cv` turns `referencesAvailableOnRequest`
  // into a `references[].availableOnRequest` entry.
  groupCertificates: true,
  referencesAvailableOnRequest: false,
)

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
