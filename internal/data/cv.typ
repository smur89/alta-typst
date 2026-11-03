// Accessors that know the CV's shape: the references flag and
// altacv's own `custom.altacv` namespace.

#import "../util/fields.typ": _dict_or_empty, _field

// A `references[]` entry's flag: only a real boolean counts, so a
// stray `"yes"` doesn't hide a quote.
#let _on_request(r) = r.at("availableOnRequest", default: false) == true

// A reference worth rendering: a quote, or the on-request flag.
#let _reference_usable(r) = _on_request(r) or _field(r, "reference") != none

// `(:)` when either level is missing or not a dictionary.
#let _altacv_ns(obj) = _dict_or_empty(
  _dict_or_empty(obj.at("custom", default: none)).at("altacv", default: none),
)

// One of altacv's non-spec fields (`focusAreas`, `languages[].rating`,
// `awards[].url`) from its own `custom` namespace (#242), on the CV
// root or an entry. `_canonical_cv` has already lifted the deprecated
// top-level forms there.
#let _altacv(obj, key, default: none) = _altacv_ns(obj).at(
  key,
  default: default,
)
