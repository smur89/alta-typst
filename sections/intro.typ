// The intro between the header and the first section: the root
// `objective` (JSON Resume 1.4.0) and `basics.summary` mapped onto
// `_intro-block`. Like the header, `alta()` calls it directly.

#import "../internal/util/checks.typ": _check-type
#import "../internal/util/fields.typ": _field
#import "../internal/util/values.typ": _present
#import "../internal/components/intro.typ": _intro-block

#let _intro(cv) = {
  let objective = cv.at("objective", default: none)
  _check-type(
    "objective",
    objective,
    (str, content, type(none)),
    "a string or content",
  )
  _intro-block(
    objective: if _present(objective) { objective },
    summary: _field(cv.basics, "summary"),
  )
}
