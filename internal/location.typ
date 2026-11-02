// JSON Resume's `location`: a free-text string or the shared
// `{address, postalCode, city, countryCode, region}` dict. One
// collapse for every caller (the header's `basics.location`, the
// `work[]` / `volunteer[]` term rows), so a location reads the same
// everywhere.

#import "text.typ": _present
#import "validation.typ": _check_unknown_keys

// `address`/`postalCode` round-trip but aren't rendered — a CV isn't
// a mailing label. Unknown keys panic to surface typos. Absent values
// (`_present`) normalise to `none` so downstream `!= none` checks
// treat them as absent (no orphan location row, no blank-query maps
// URL). `what` names the field in panic messages (e.g.
// "work[].location").
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
  let parts = _location_display_order
    .map(k => value.at(k, default: none))
    .filter(_present)
  if parts.len() == 0 { return none }
  parts.join(", ")
}
