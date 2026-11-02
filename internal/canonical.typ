// Rewrites caller input into the one shape the renderers read, before
// anything renders: deprecated CV, preference and label forms (#239)
// become their current spelling, and the case-insensitive label tables
// are folded to lowercase keys. Renderers never see a legacy shape, so
// dropping one in the next major is a change to this module alone.

#import "text.typ": (
  _altacv_ns, _dict_or_empty, _entry_summary, _present, _string_at,
)

// #239: the deprecated top-level homes of altacv's non-spec fields,
// lifted into `custom.altacv` (which wins when both are set).
#let _legacy_root_fields = ("focusAreas",)
#let _legacy_entry_fields = (languages: ("rating",), awards: ("url",))

// #239: sections whose `description` is a deprecated alias of `summary`.
#let _summary_alias_sections = ("work", "volunteer", "projects")

// #239: plural free-text publication types, grouped with their JSON
// Resume code so a legacy CV mixing `"Articles"` and untyped entries
// keeps one subheading.
#let _legacy_type_codes = (
  articles: "article",
  books: "book",
  patents: "patent",
  theses: "thesis",
  talks: "talk",
)

// #239: icons for the deprecated free-text publication headings, keyed
// by lowercased `type`. Seeded under the caller's `publicationIcons`.
#let _legacy_publication_icons = (
  "blog posts": "newspaper",
  "blog post": "newspaper",
  presentations: "microphone",
  presentation: "microphone",
  "conference papers": "newspaper",
  "conference paper": "newspaper",
  papers: "newspaper",
  paper: "newspaper",
)

// Label tables matched case-insensitively, so keyed in lowercase.
#let _case_insensitive_tables = ("publicationTypes", "publicationIcons")

// Moves each of `keys` present on `obj` into `obj.custom.altacv`
// unless that namespace already holds it. A non-dictionary `custom` or
// `altacv` is replaced, as nothing else reads it.
#let _lift_into_custom(obj, keys) = {
  let ns = _altacv_ns(obj)
  let lifted = keys
    .filter(k => (
      obj.at(k, default: none) != none and ns.at(k, default: none) == none
    ))
    .map(k => (k, obj.at(k)))
    .to-dict()
  if lifted.len() == 0 { obj } else {
    let custom = _dict_or_empty(obj.at("custom", default: none))
    obj + (custom: custom + (altacv: ns + lifted))
  }
}

#let _alias_summary(entry) = {
  let description = entry.at("description", default: none)
  if _entry_summary(entry) != none or description == none { entry } else {
    entry + (summary: description)
  }
}

#let _canonical_type(pub) = {
  let raw = _string_at(pub, "type")
  let code = if raw != none {
    _legacy_type_codes.at(lower(raw.trim()), default: none)
  }
  if code == none { pub } else { pub + (type: code) }
}

// Applies `f` to every dictionary entry of `cv.at(key)`; anything else
// is left for the shape checks to report.
#let _map_entries(cv, key, f) = {
  let entries = cv.at(key, default: none)
  if type(entries) != array { cv } else {
    cv + ((key): entries.map(e => if type(e) == dictionary { f(e) } else { e }))
  }
}

// #239: `preferences.referencesAvailableOnRequest` shows the
// on-request line when no reference is usable — the same as one entry
// with JSON Resume's `availableOnRequest: true`, so it becomes one.
#let _references_on_request(cv, prefs) = {
  let refs = cv.at("references", default: ())
  let usable(r) = (
    type(r) == dictionary
      and (
        r.at("availableOnRequest", default: false) == true
          or _present(r.at("reference", default: none))
      )
  )
  if (
    not prefs.referencesAvailableOnRequest
      or type(refs) != array
      or refs.any(usable)
  ) { cv } else { cv + (references: refs + ((availableOnRequest: true),)) }
}

// `prefs` is the merged, validated preferences dict.
#let _canonical_cv(cv, prefs) = (
  cv => _lift_into_custom(cv, _legacy_root_fields),
  cv => _legacy_entry_fields
    .pairs()
    .fold(cv, (acc, (key, fields)) => _map_entries(
      acc,
      key,
      e => _lift_into_custom(e, fields),
    )),
  cv => _summary_alias_sections.fold(cv, (acc, key) => _map_entries(
    acc,
    key,
    _alias_summary,
  )),
  cv => _map_entries(cv, "publications", _canonical_type),
  cv => _references_on_request(cv, prefs),
).fold(cv, (acc, step) => step(acc))

// Lowercases a case-insensitive label table's keys, panicking when two
// source keys collapse onto one (e.g. `Talks` + `talks`) instead of
// letting the last silently win.
#let _lowercase_table(table, name) = {
  let keys = table.keys()
  if keys.map(lower).dedup().len() != keys.len() {
    panic(
      "labels."
        + name
        + " has keys that collide after lowercasing — "
        + "matching is case-insensitive, so e.g. `Talks` and `talks` are equivalent. "
        + "Source keys: "
        + repr(keys),
    )
  }
  table.pairs().map(((k, v)) => (lower(k), v)).to-dict()
}

// Canonicalises the caller's `labels` overrides before they merge over
// the defaults. A non-dictionary (overall, or as a table) is passed
// through for `_strict_merge` to reject.
#let _canonical_labels(overrides) = if type(overrides) != dictionary {
  overrides
} else {
  let table(name) = overrides.at(name, default: (:))
  let tables = _case_insensitive_tables
    .filter(t => type(table(t)) == dictionary)
    .map(t => (t, _lowercase_table(table(t), t)))
    .to-dict()
  let types = tables.at("publicationTypes", default: table("publicationTypes"))
  let icons = tables.at("publicationIcons", default: table("publicationIcons"))
  // #239: a set `labels.articles` heads `article`, unless
  // `publicationTypes.article` is set too.
  let articles = if "articles" in overrides and type(types) == dictionary {
    (publicationTypes: (article: overrides.articles) + types)
  } else { (:) }
  let legacy-icons = if type(icons) == dictionary {
    (publicationIcons: _legacy_publication_icons + icons)
  } else { (:) }
  overrides + tables + articles + legacy-icons
}
