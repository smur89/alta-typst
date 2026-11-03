// The intro between the header and the first section: the root
// `objective` (JSON Resume 1.4.0) and `basics.summary` mapped onto
// `_intro-block`. Like the header, `alta()` calls it directly.

#import "../internal/util/fields.typ": _field
#import "../internal/components/intro.typ": _intro-block

#let _intro(cv) = _intro-block(
  objective: _field(cv, "objective"),
  summary: _field(cv.basics, "summary"),
)
