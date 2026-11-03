// `_read-cv`: the caller's CV checked, canonicalised and split into
// its column sections' entries, before anything renders. Runs after
// `_merge-options`, as some checks read the preferences.

#import "../util/checks.typ": _check-type, _check-unknown-keys, _require
#import "../util/fields.typ": _field
#import "canonical.typ": _canonical-cv
#import "sections.typ": _cv-keys, _read-sections
#import "cv-checks.typ": _check-root

// `(cv, sections)`: the canonical CV and each column section's entries.
#let _read-cv(cv, prefs) = {
  _check-type("cv", cv, (dictionary,), "a CV data dictionary")
  // The only required field.
  let basics = cv.at("basics", default: none)
  _require(
    "cv.basics.name",
    basics,
    type(basics) == dictionary and _field(basics, "name") != none,
    "set (a non-empty string; every other field is optional)",
  )
  // A misspelt section (`publication:`) would otherwise vanish silently.
  _check-unknown-keys(cv.keys(), _cv-keys, "CV top-level")
  let cv = _canonical-cv(cv, prefs)
  _check-root(cv, prefs)
  (cv: cv, sections: _read-sections(cv, prefs))
}
