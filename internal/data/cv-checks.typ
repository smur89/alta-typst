// Up-front checks for the CV: each section's entry array and every
// field a renderer reads, so a renderer only meets values it can draw.
// `_read-cv` runs them; the options' are in `validation.typ`.

#import "../design/icon-set.typ": _profile-networks
#import "../util/checks.typ": (
  _check-rating, _check-rules, _check-type, _check-unknown-keys, _list-rule,
  _prose-list, _require, _type-rule,
)
#import "../util/values.typ": _present, _present-str
#import "cv.typ": _altacv, _altacv-ns, _location-fields, _profile-network

// Field rules (`_section-specs`' `fields`, `basics`): the types the
// renderers can draw. Dates are text too: a non-ISO one renders as
// written.
#let _text-rule = _type-rule((str, content), "a string or content")
#let _string-rule = _type-rule((str,), "a string")
#let _texts-rule = _list-rule((str, content), "an array of strings or content")

// A dict where a list belongs fails here, not deep in a renderer.
// Returns `entries`.
#let _check-section-entries(key, entries, item-types) = {
  _check-type(key, entries, (array,), "an array")
  let bad = entries.find(e => type(e) not in item-types)
  _require(
    key + " entries",
    bad,
    bad == none,
    _prose-list(item-types.map(repr)),
  )
  entries
}

#let _location-expected = (
  "a string or a dict matching JSON Resume's {"
    + _location-fields.join(", ")
    + "}"
)

// JSON Resume's `location`: a string or the shared dict. `what` is the
// field's path, for the message.
#let _check-location(value, what) = if type(value) == dictionary {
  _check-unknown-keys(value.keys(), _location-fields, what)
} else if _present(value) {
  _check-type(what, value, (str,), _location-expected)
}

// The section `check`s (`_section-specs`) take the section's key, for
// messages, the entry and the preferences.

#let _check-entry-location(key, entry, _) = _check-location(
  entry.at("location", default: none),
  key + "[].location",
)

// An award's link, in its `custom.altacv` namespace, which `fields`
// can't reach.
#let _check-award(key, entry, _) = _check-rules(
  _altacv-ns(entry),
  (url: _string-rule),
  prefix: key + "[].custom.altacv.",
  optional: true,
)

// A `custom.altacv.rating` wins over `fluency`, so either will do.
#let _check-language(key, entry, prefs) = {
  let rating = _altacv(entry, "rating")
  if rating != none {
    _check-rating(key + "[].custom.altacv.rating", rating, prefs.maxRating)
  } else {
    _check-type(
      key + "[].fluency",
      entry.at("fluency", default: none),
      (str,),
      "a string when there's no numeric `custom.altacv.rating`",
    )
  }
}

#let _basics-fields = (
  name: _text-rule,
  label: _text-rule,
  pronouns: _text-rule,
  email: _string-rule,
  phone: _string-rule,
  url: _string-rule,
  summary: _text-rule,
  profiles: _list-rule((dictionary,), "an array of dictionaries"),
)
#let _profile-fields = (
  network: _string-rule,
  username: _text-rule,
  url: _string-rule,
)

// The root fields outside the sections: `basics` and `objective`.
#let _check-root(cv, prefs) = {
  let basics = cv.basics
  _check-rules(basics, _basics-fields, prefix: "basics.", optional: true)
  _check-type(
    "basics.image",
    basics.at("image", default: none),
    (path, str, bytes, type(none)),
    "a path, a string path, or bytes",
  )
  _check-location(basics.at("location", default: none), "basics.location")
  for profile in basics.at("profiles", default: ()) {
    _check-rules(
      profile,
      _profile-fields,
      prefix: "basics.profiles[].",
      optional: true,
    )
    _require(
      "basics.profiles[].network",
      profile.at("network", default: none),
      "network" in profile,
      "set",
    )
    if _profile-network(profile) not in _profile-networks {
      panic(
        "Unknown profile network: "
          + repr(profile.network)
          + ". Supported: "
          + _profile-networks.join(", ")
          + ". To add another, register its FontAwesome glyph in _network-icons (internal/design/icon-set.typ).",
      )
    }
  }
  if prefs.qrCode == auto {
    let url = basics.at("url", default: none)
    _require(
      "basics.url",
      url,
      _present-str(url),
      "a non-empty URL string when preferences.qrCode is `auto`",
    )
  }
  _check-type("meta", cv.meta, (dictionary,), "a dictionary")
  // `version` and `canonical` are read leniently (`_string-at`).
  _check-rules(
    cv.meta,
    (lastModified: _text-rule),
    prefix: "meta.",
    optional: true,
  )
  _check-type(
    "objective",
    cv.at("objective", default: none),
    (str, content, type(none)),
    "a string or content",
  )
}
