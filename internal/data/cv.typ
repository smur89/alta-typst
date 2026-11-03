// Accessors that know the CV's shape: the references flag, a profile's
// network, a location, an entry's period and altacv's own
// `custom.altacv` namespace.

#import "../design/icon-set.typ": _network-aliases
#import "../util/dates.typ": _format-date-span
#import "../util/fields.typ": _dict-or-empty, _field
#import "../util/values.typ": _join-present, _present

// A `references[]` entry's flag: only a real boolean counts, so a
// stray `"yes"` doesn't hide a quote.
#let _on-request(r) = r.at("availableOnRequest", default: false) == true

// A reference worth rendering: a quote, or the on-request flag.
#let _reference-usable(r) = _on-request(r) or _field(r, "reference") != none

// `(:)` when either level is missing or not a dictionary.
#let _altacv-ns(obj) = _dict-or-empty(
  _dict-or-empty(obj.at("custom", default: none)).at("altacv", default: none),
)

// One of altacv's non-spec fields (`focusAreas`, `languages[].rating`,
// `awards[].url`) from its own `custom` namespace (#242), on the CV
// root or an entry. `_canonical-cv` has already lifted the deprecated
// top-level forms there.
#let _altacv(obj, key, default: none) = _altacv-ns(obj).at(
  key,
  default: default,
)

// A `basics.profiles[]` entry's network as its icon key: lowercased,
// with renamed networks mapped to the key their icon still ships under.
#let _profile-network(profile) = {
  let raw = lower(profile.network)
  _network-aliases.at(raw, default: raw)
}

// JSON Resume's `location` (a string or the shared dict), collapsed
// one way for every caller so a location reads the same everywhere.
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
// `value` has passed `_check-location` (`cv-checks.typ`).
#let _format-location(value) = {
  if not _present(value) { return none }
  if type(value) == str { return value }
  _join-present(
    _location-display-order.map(k => _field(value, k)),
    ", ",
  )
}

// A `startDate` / `endDate` entry's period through `format-date`, a
// missing end reading `present` (`labels.present`); a fully undated
// entry stays `none`, not a bare "Present".
#let _entry-period(entry, format-date, present) = {
  let start = _field(entry, "startDate")
  let end = _field(entry, "endDate")
  if start == none and end == none { return none }
  _format-date-span(start, end, format-date, open-end: present)
}
