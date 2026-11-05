// Rewrites caller input into the one shape renderers read: `none`
// fields drop out, deprecated CV, preference and label forms (#239)
// become their current spelling,
// and case-insensitive label tables get lowercase keys. Dropping a
// legacy form in the next major then touches only this module.

#import "../util/fields.typ": _dict-or-empty, _field, _string-at
#import "../design/theme.typ": _accent-roles, _treatment-names
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
#let _preference-tables = ("publicationIcons", "projectIcons", "profileIcons")

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

// The CV's values in JSON Resume's forms, at any depth. `none` (JSON's
// `null`) means absent: a key set to it is dropped, so checks and
// renderers meet one absent form, a missing key, and a reader's
// default applies. A `datetime` with a date reads as the ISO string
// the spec writes (`2024-06-15`, with its time if it has one): a Typst
// convenience over the string, so every date reader meets one form.
#let _spec-values(v) = if type(v) == dictionary {
  v
    .pairs()
    .filter(((_, x)) => x != none)
    .map(((k, x)) => (k, _spec-values(x)))
    .to-dict()
} else if type(v) == array { v.map(_spec-values) } else if (
  type(v) == datetime and v.year() != none
) {
  v.display(
    "[year]-[month]-[day]"
      + if v.hour() != none { "T[hour]:[minute]:[second]" } else { "" },
  )
} else { v }

// `prefs` is the merged, validated preferences dict.
#let _canonical-cv(cv, prefs) = (
  _spec-values,
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

// #239: the top-level `accent` colours the accent roles with one
// colour (`_accent-roles`), beneath the caller's `colours`.
// It's dropped even when `colours` isn't a dictionary, so the check
// names `colours` rather than an unknown `accent`; a non-dictionary
// `preferences` passes through for `_strict-merge` to reject.
#let _fold-accent(overrides) = {
  if type(overrides) != dictionary or "accent" not in overrides {
    overrides
  } else {
    let colours = overrides.at("colours", default: (:))
    let folded = if type(colours) == dictionary {
      _accent-roles(overrides.accent) + colours
    } else { colours }
    let rest = overrides.pairs().filter(((k, _)) => k != "accent").to-dict()
    rest + (colours: folded)
  }
}

// #239: the strings `headerTextAlign` and `imagePosition` took become
// Typst's alignments. `"center"` placed the portrait on its own row,
// `imageStackOrder` (`"above"`, the default, or `"below"`) the text,
// so it becomes `top` or `bottom`. A string with no alignment passes
// through for validation to name.
// `v`'s value in `table` when it names one, else `v`.
#let _named(table, v) = if type(v) == str and v in table { table.at(v) } else {
  v
}

#let _alignments = (left: left, center: center, right: right)
#let _canonical-alignments(overrides) = if type(overrides) != dictionary {
  overrides
} else {
  let at(key, default: none) = overrides.at(key, default: default)
  // Only the keys the caller set, so a missing one keeps its default.
  let set-only(key, value) = if key in overrides { ((key): value) } else {
    (:)
  }
  let position = if at("imagePosition") == "center" {
    _named((above: top, below: bottom), at("imageStackOrder", default: "above"))
  } else { _named(_alignments, at("imagePosition")) }
  (
    overrides
      + set-only("headerTextAlign", _named(_alignments, at("headerTextAlign")))
      + set-only("imagePosition", position)
  )
}

// #239: a theme's `treatment` names (`"italic"`) become their
// functions. An unknown name passes through for validation to name.
#let _canonical-treatments(overrides) = {
  let theme = _dict-or-empty(overrides).at("theme", default: none)
  let treatment = _dict-or-empty(theme).at("treatment", default: none)
  if type(treatment) != dictionary { overrides } else {
    let treatment = treatment
      .pairs()
      .map(((k, v)) => (k, _named(_treatment-names, v)))
      .to-dict()
    overrides + (theme: theme + (treatment: treatment))
  }
}

// Runs before the merge over the defaults. #239: the deprecated
// top-level `accent` becomes `colours` (`_fold-accent`), the string
// alignments and treatment names become Typst's values, and the
// free-text icons, then a set `labels.publicationIcons`, sit beneath
// the caller's `publicationIcons`, all lowercased, so the merge sees
// one table. `projectIcons` and `profileIcons` are lowercased too.
// #239: the string `pageFooter: "auto"` becomes `auto`. A
// non-dictionary (overall or as a table) passes through for
// `_strict-merge` to reject.
#let _canonical-preferences(overrides, labels) = {
  let overrides = _canonical-treatments(
    _canonical-alignments(_fold-accent(overrides)),
  )
  let overrides = if (
    type(overrides) == dictionary
      and overrides.at("pageFooter", default: none) == "auto"
  ) { overrides + (pageFooter: auto) } else { overrides }
  let lowercase-key(prefs, key) = {
    let table = _dict-or-empty(prefs).at(key, default: none)
    if type(table) != dictionary { prefs } else {
      prefs + ((key): _lowercase-table(table, "preferences." + key))
    }
  }
  // `publicationIcons` is lowercased with its deprecated sources below.
  let overrides = _preference-tables
    .filter(t => t != "publicationIcons")
    .fold(overrides, lowercase-key)
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
