// JSON Resume's `location` (a string or the shared dict), collapsed
// one way for every caller so a location reads the same everywhere.

#import "fields.typ": _field
#import "values.typ": _join-present, _present

// `address` / `postalCode` are accepted but not rendered — a CV isn't
// a mailing label. Absent values become `none`, so callers' `!= none`
// checks leave no orphan row or blank-query maps URL.
#let _location-fields = (
  "address",
  "postalCode",
  "city",
  "countryCode",
  "region",
)
#let _location-display-order = ("city", "region", "countryCode")
// `value` has passed `_check-location` (`data/validation.typ`).
#let _format-location(value) = {
  if not _present(value) { return none }
  if type(value) == str { return value }
  _join-present(
    _location-display-order.map(k => _field(value, k)),
    ", ",
  )
}
