// The intro between the header and the first section: the root
// `objective` (JSON Resume 1.4.0) and `basics.summary` mapped onto
// `_intro_block`. Like the header, `alta()` calls it directly.

#import "../internal/util/checks.typ": _check_type
#import "../internal/util/fields.typ": _field
#import "../internal/util/values.typ": _present
#import "../internal/components/intro.typ": _intro_block

#let _intro(cv) = {
  let objective = cv.at("objective", default: none)
  _check_type(
    "objective",
    objective,
    (str, content, type(none)),
    "a string or content",
  )
  _intro_block(
    objective: if _present(objective) { objective },
    summary: _field(cv.basics, "summary"),
  )
}
