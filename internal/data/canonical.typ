// Rewrites caller input into the one shape renderers read: `none`
// fields drop out, deprecated CV, preference and label forms (#239)
// become their current spelling,
// and case-insensitive label tables get lowercase keys. Dropping a
// legacy form in the next major then touches only this module.

#import "../util/fields.typ": _dict-or-empty, _field, _string-at
#import "cv.typ": _altacv-ns, _reference-usable

// #239: the deprecated top-level homes of altacv's non-spec fields,
// lifted into `custom.altacv` (which wins when both are set).
#let _legacy-root-fields = ("focusAreas",)
#let _legacy-entry-fields = (languages: ("rating",), awards: ("url",))

// #239: sections whose `description` is a deprecated alias of `summary`.
#let _summary-alias-sections = ("work", "volunteer", "projects")

// #239: plural free-text publication types, mapped to their code so
// `"Articles"` and untyped entries share one subheading.
#let _legacy-type-codes = (
  articles: "article",
  books: "book",
  patents: "patent",
  theses: "thesis",
  talks: "talk",
)

// #239: icons for deprecated free-text publication types.
#let _legacy-publication-icons = (
  "blog posts": "newspaper",
  "blog post": "newspaper",
  presentations: "microphone",
  presentation: "microphone",
  "conference papers": "newspaper",
  "conference paper": "newspaper",
  papers: "newspaper",
  paper: "newspaper",
)

// Tables matched case-insensitively and merged entry by entry over
// their defaults (`_strict-merge`'s `tables`).
#let _label-tables = ("publicationTypes",)
#let _preference-tables = ("publicationIcons",)

// `custom.altacv` wins when both are set. A non-dictionary `custom`
// or `altacv` is replaced, as nothing else reads it.
#let _lift-into-custom(obj, keys) = {
  let ns = _altacv-ns(obj)
  let lifted = keys
    .filter(k => (
      obj.at(k, default: none) != none and ns.at(k, default: none) == none
    ))
    .map(k => (k, obj.at(k)))
    .to-dict()
  if lifted.len() == 0 { obj } else {
    let custom = _dict-or-empty(obj.at("custom", default: none))
    obj + (custom: custom + (altacv: ns + lifted))
  }
}

#let _alias-summary(entry) = {
  let description = entry.at("description", default: none)
  if _field(entry, "summary") != none or description == none { entry } else {
    entry + (summary: description)
  }
}

// `" talk "` groups with `talk`; an all-space `type` becomes untyped.
#let _trim-type(entry) = {
  let raw = _string-at(entry, "type")
  if raw == none { entry } else {
    let trimmed = raw.trim()
    entry + (type: if trimmed != "" { trimmed })
  }
}

#let _canonical-type(pub) = {
  let pub = _trim-type(pub)
  let raw = _string-at(pub, "type")
  let code = if raw != none { _legacy-type-codes.at(lower(raw), default: none) }
  if code == none { pub } else { pub + (type: code) }
}

// Non-dictionary entries are left for the shape checks to report.
#let _map-entries(cv, key, f) = {
  let entries = cv.at(key, default: none)
  if type(entries) != array { cv } else {
    cv + ((key): entries.map(e => if type(e) == dictionary { f(e) } else { e }))
  }
}

// #239: `preferences.referencesAvailableOnRequest` means the same as
// one `availableOnRequest: true` entry when no reference is usable.
#let _references-on-request(cv, prefs) = {
  let refs = cv.at("references", default: ())
  let usable(r) = type(r) == dictionary and _reference-usable(r)
  if (
    not prefs.referencesAvailableOnRequest
      or type(refs) != array
      or refs.any(usable)
  ) { cv } else { cv + (references: refs + ((availableOnRequest: true),)) }
}

// `none` (JSON's `null`) means absent: a key set to it is dropped, at
// any depth, so checks and renderers meet one absent form, a missing
// key, and a reader's default applies.
#let _drop-nones(v) = if type(v) == dictionary {
  v
    .pairs()
    .filter(((_, x)) => x != none)
    .map(((k, x)) => (k, _drop-nones(x)))
    .to-dict()
} else if type(v) == array { v.map(_drop-nones) } else { v }

// `prefs` is the merged, validated preferences dict.
#let _canonical-cv(cv, prefs) = (
  _drop-nones,
  cv => _lift-into-custom(cv, _legacy-root-fields),
  cv => _legacy-entry-fields
    .pairs()
    .fold(cv, (acc, (key, fields)) => _map-entries(
      acc,
      key,
      e => _lift-into-custom(e, fields),
    )),
  cv => _summary-alias-sections.fold(cv, (acc, key) => _map-entries(
    acc,
    key,
    _alias-summary,
  )),
  cv => _map-entries(cv, "publications", _canonical-type),
  cv => _map-entries(cv, "projects", _trim-type),
  cv => _references-on-request(cv, prefs),
  // Absent `meta` reads as empty, so its readers needn't default it.
  cv => (meta: (:)) + cv,
).fold(cv, (acc, step) => step(acc))

// Panics when two keys collapse onto one (`Talks` + `talks`) rather
// than letting the last silently win. `name` is the table's full path
// (`labels.publicationTypes`), for the message.
#let _lowercase-table(table, name) = {
  let keys = table.keys()
  if keys.map(lower).dedup().len() != keys.len() {
    panic(
      name
        + " has keys that collide after lowercasing — "
        + "matching is case-insensitive, so e.g. `Talks` and `talks` are equivalent. "
        + "Source keys: "
        + repr(keys),
    )
  }
  table.pairs().map(((k, v)) => (lower(k), v)).to-dict()
}

// Runs before the merge over the defaults; a non-dictionary (overall
// or as a table) passes through for `_strict-merge` to reject.
#let _canonical-labels(overrides) = if type(overrides) != dictionary {
  overrides
} else {
  let types = overrides.at("publicationTypes", default: (:))
  if type(types) != dictionary { overrides } else {
    let types = _lowercase-table(types, "labels.publicationTypes")
    // #239: a set `labels.articles` heads `article`, unless
    // `publicationTypes.article` is set too.
    let articles = if "articles" in overrides {
      (article: overrides.articles)
    } else { (:) }
    overrides + (publicationTypes: articles + types)
  }
}

// Runs before the merge over the defaults. #239: the deprecated
// free-text icons, then a set `labels.publicationIcons`, sit beneath
// the caller's `publicationIcons`, all lowercased, so the merge sees
// one table, and the string `pageFooter: "auto"` becomes `auto`. A
// non-dictionary (overall or as the table) passes through for
// `_strict-merge` to reject.
#let _canonical-preferences(overrides, labels) = {
  let overrides = if (
    type(overrides) == dictionary
      and overrides.at("pageFooter", default: none) == "auto"
  ) { overrides + (pageFooter: auto) } else { overrides }
  let icons = if type(overrides) == dictionary {
    overrides.at("publicationIcons", default: (:))
  }
  if type(icons) != dictionary { overrides } else {
    let label-icons = _dict-or-empty(labels).at(
      "publicationIcons",
      default: none,
    )
    let from-label = if type(label-icons) == dictionary {
      _lowercase-table(label-icons, "labels.publicationIcons")
    } else { (:) }
    let merged = (
      _legacy-publication-icons
        + from-label
        + _lowercase-table(icons, "preferences.publicationIcons")
    )
    overrides + (publicationIcons: merged)
  }
}
