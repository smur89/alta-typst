// The column sections' specs: the CV field each reads (its key, unless
// `read` overrides it), its default column and the entry types it
// accepts, plus the recognised top-level CV keys. Renderers are bound
// to these keys in `registry.typ`, so reading and checking the CV
// doesn't depend on them.

#import "canonical.typ": _legacy_root_fields
#import "cv.typ": _altacv
#import "validation.typ": _check_section_entries

// `focusAreas` lives in `custom.altacv`; `items` lists the accepted
// entry types (default: dictionaries). Insertion order is the default
// render order.
#let _section_specs = (
  work: (column: "left"),
  volunteer: (column: "left"),
  focusAreas: (
    column: "right",
    read: cv => _altacv(cv, "focusAreas", default: ()),
    items: (str, content),
  ),
  skills: (column: "right"),
  languages: (column: "right"),
  education: (column: "right"),
  certificates: (column: "right"),
  awards: (column: "right"),
  projects: (column: "left"),
  publications: (column: "left"),
  interests: (column: "right"),
  references: (column: "right"),
)

// Every section's entries, shape-checked before any renderer (or the
// PDF-keyword pass) reads them.
#let _read_sections(cv) = (
  _section_specs
    .pairs()
    .map(((key, entry)) => {
      let read = entry.at("read", default: cv => cv.at(key, default: ()))
      let items = entry.at("items", default: (dictionary,))
      (key, _check_section_entries(key, read(cv), items))
    })
    .to-dict()
)

// Every recognised top-level CV key: the sections that read their own
// key, the root keys that aren't sections (`custom` and `$schema` are
// accepted but not rendered), and the deprecated root forms
// `_canonical_cv` still lifts, so dropping one there (#239) rejects it
// here too.
#let _cv_keys = (
  ("$schema", "basics", "objective", "custom", "meta")
    + _section_specs.keys().filter(k => "read" not in _section_specs.at(k))
    + _legacy_root_fields
)

#let _keys_for_column(col) = (
  _section_specs.keys().filter(k => _section_specs.at(k).column == col)
)
