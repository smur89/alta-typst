// Rewrites caller input into the one shape the renderers read, before
// anything renders: deprecated CV and label forms (#239) become their
// current spelling, and the case-insensitive label tables are folded
// to lowercase keys. Renderers never see a legacy shape, so dropping
// one in the next major is a change to this module alone.

#import "text.typ": _present, _present_str

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
// by lowercased `type`.
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

// Moves each of `keys` present on `obj` into `obj.custom.altacv`
// unless that namespace already holds it. A non-dictionary `custom` or
// `altacv` is replaced, as nothing else reads it.
#let _lift_into_custom(obj, keys) = {
  let custom = obj.at("custom", default: none)
  let custom = if type(custom) == dictionary { custom } else { (:) }
  let ns = custom.at("altacv", default: none)
  let ns = if type(ns) == dictionary { ns } else { (:) }
  let lifted = keys
    .filter(k => obj.at(k, default: none) != none)
    .filter(k => ns.at(k, default: none) == none)
    .map(k => (k, obj.at(k)))
    .to-dict()
  if lifted.len() == 0 { obj } else {
    obj + (custom: custom + (altacv: ns + lifted))
  }
}

#let _alias_summary(entry) = {
  let description = entry.at("description", default: none)
  if _present(entry.at("summary", default: none)) or description == none {
    entry
  } else { entry + (summary: description) }
}

#let _canonical_type(pub) = {
  let raw = pub.at("type", default: none)
  let code = if _present_str(raw) {
    _legacy_type_codes.at(lower(raw), default: none)
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

#let _canonical_cv(cv) = {
  let cv = _lift_into_custom(cv, _legacy_root_fields)
  let cv = _legacy_entry_fields
    .pairs()
    .fold(cv, (acc, (key, fields)) => _map_entries(
      acc,
      key,
      e => _lift_into_custom(e, fields),
    ))
  let cv = _summary_alias_sections.fold(cv, (acc, key) => _map_entries(
    acc,
    key,
    _alias_summary,
  ))
  _map_entries(cv, "publications", _canonical_type)
}

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

#let _case_insensitive_tables = ("publicationTypes", "publicationIcons")

// Canonicalises the caller's `labels` overrides before they merge over
// the defaults. A non-dictionary is passed through for `_strict_merge`
// to reject.
#let _canonical_labels(overrides) = {
  if type(overrides) != dictionary { return overrides }
  let tables = _case_insensitive_tables
    .filter(t => type(overrides.at(t, default: none)) == dictionary)
    .map(t => (t, _lowercase_table(overrides.at(t), t)))
    .to-dict()
  let overrides = overrides + tables
  // #239: a set `labels.articles` heads `article`, unless
  // `publicationTypes.article` is set too.
  if "articles" not in overrides { return overrides }
  let types = overrides.at("publicationTypes", default: (:))
  if type(types) != dictionary { return overrides }
  overrides + (publicationTypes: (article: overrides.articles) + types)
}
