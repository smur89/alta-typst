// Accessors that know the CV's shape: the references flag, a profile's
// network and altacv's own `custom.altacv` namespace.

#import "../design/icon-set.typ": _network-aliases
#import "../util/fields.typ": _dict-or-empty, _field

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
