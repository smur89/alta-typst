// JSON Resume's `location` (a string or the shared dict), collapsed
// one way for every caller so a location reads the same everywhere.

#import "checks.typ": _check_unknown_keys
#import "fields.typ": _field, _join_present, _present

// `address` / `postalCode` are accepted but not rendered — a CV isn't
// a mailing label. Absent values become `none`, so callers' `!= none`
// checks leave no orphan row or blank-query maps URL.
#let _location_fields = (
  "address",
  "postalCode",
  "city",
  "countryCode",
  "region",
)
#let _location_display_order = ("city", "region", "countryCode")
#let _format_location(value, what) = {
  if not _present(value) { return none }
  if type(value) == str { return value }
  if type(value) != dictionary {
    panic(
      what
        + " must be a string or a dict matching JSON Resume's {"
        + _location_fields.join(", ")
        + "}, got: "
        + repr(value),
    )
  }
  _check_unknown_keys(value.keys(), _location_fields, what)
  _join_present(
    _location_display_order.map(k => _field(value, k)),
    ", ",
  )
}
