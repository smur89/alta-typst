// The column sections' specs: the CV field each reads (its key, unless
// `read` overrides it), its default column and the entry types it
// accepts, plus the recognised top-level CV keys. Renderers are bound
// to these keys in `registry.typ`, so reading and checking the CV
// doesn't depend on them.

#import "canonical.typ": _legacy-root-fields
#import "cv.typ": _altacv
#import "cv-checks.typ": (
  _check-entry-location, _check-language, _check-section-entries,
)

// `focusAreas` lives in `custom.altacv`; `items` lists the accepted
// entry types (default: dictionaries); `check(key, entry, prefs)`
// checks the fields its renderer reads. Insertion order is the default render
// order.
#let _section-specs = (
  work: (column: "left", check: _check-entry-location),
  volunteer: (column: "left", check: _check-entry-location),
  focusAreas: (
    column: "right",
    read: cv => _altacv(cv, "focusAreas", default: ()),
    items: (str, content),
  ),
  skills: (column: "right"),
  languages: (column: "right", check: _check-language),
  education: (column: "right", check: _check-entry-location),
  certificates: (column: "right"),
  awards: (column: "right"),
  projects: (column: "left"),
  publications: (column: "left"),
  interests: (column: "right"),
  references: (column: "right"),
)

// Every section's entries, checked before any renderer (or the
// PDF-keyword pass) reads them.
#let _read-sections(cv, prefs) = (
  _section-specs
    .pairs()
    .map(((key, spec)) => {
      let read = spec.at("read", default: cv => cv.at(key, default: ()))
      let items = spec.at("items", default: (dictionary,))
      let entries = _check-section-entries(key, read(cv), items)
      let check = spec.at("check", default: none)
      if check != none { for entry in entries { check(key, entry, prefs) } }
      (key, entries)
    })
    .to-dict()
)

// Every recognised top-level CV key: the sections that read their own
// key, the root keys that aren't sections (`custom` and `$schema` are
// accepted but not rendered), and the deprecated root forms
// `_canonical-cv` still lifts, so dropping one there (#239) rejects it
// here too.
#let _cv-keys = (
  ("$schema", "basics", "objective", "custom", "meta")
    + _section-specs.keys().filter(k => "read" not in _section-specs.at(k))
    + _legacy-root-fields
)

#let _keys-for-column(col) = (
  _section-specs.keys().filter(k => _section-specs.at(k).column == col)
)
