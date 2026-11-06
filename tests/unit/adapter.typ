// The public adapter helpers, over the internal ones alta() uses.

#import "/lib.typ": adapter, maps-providers

// format-date: the "long" default, a named format, a template, and a
// non-ISO value as written; `months` names them in another language.
#assert.eq(adapter.format-date("2024-06"), "Jun 2024")
#assert.eq(adapter.format-date("2024-06", format: "short"), "06/2024")
#assert.eq(adapter.format-date("2024-06-03", format: "[year]"), "2024")
#assert.eq(adapter.format-date("Jan 2022"), "Jan 2022")
#assert.eq(
  adapter.format-date("2024-06", months: range(1, 13).map(str)),
  "6 2024",
)

// location-text: the parts in display order, for the theme to join.
#assert.eq(
  adapter.location-text((city: "Cork", countryCode: "IE")),
  ("Cork", "IE"),
)
#assert.eq(adapter.location-text("Dublin"), ("Dublin",))
#assert.eq(adapter.location-text(none), ())

// fluency-rating: a term on the scale, else `custom.altacv.rating`.
#assert.eq(adapter.fluency-rating((language: "Irish", fluency: "Native")), 5)
#assert.eq(
  adapter.fluency-rating((language: "X", custom: (altacv: (rating: 2.5)))),
  2.5,
)
#assert.eq(
  adapter.fluency-rating((language: "X", fluency: "Elementary"), max: 10),
  2,
)
#assert.eq(adapter.fluency-rating((language: "X", fluency: "Some")), none)

// group-by-type: `(type, items)` pairs in first-seen order, the
// untyped under `none` by default.
#assert.eq(
  adapter
    .group-by-type((
      (name: "a", type: "talk"),
      (name: "b"),
      (name: "c", type: "talk"),
    ))
    .map(((type, items)) => (type, items.map(i => i.name))),
  (("talk", ("a", "c")), (none, ("b",))),
)
#assert.eq(adapter.group-by-type(()), ())
// A type is read as `alta()` reads it: trimmed, a blank one untyped.
#assert.eq(
  adapter
    .group-by-type(((type: " talk "), (type: " "), (type: "talk")))
    .map(((type, items)) => (type, items.len())),
  (("talk", 2), (none, 1)),
)
// `untyped` names the untyped group, which a type of that name shares;
// `key` maps a type to its group.
#assert.eq(
  adapter
    .group-by-type(((type: "OSS"), (:), (type: "Other")), untyped: "Other")
    .map(((type, items)) => (type, items.len())),
  (("OSS", 1), ("Other", 2)),
)
#assert.eq(
  adapter
    .group-by-type(
      ((type: "Talk"), (:), (type: "talk")),
      key: lower,
      untyped: "article",
    )
    .map(((type, items)) => (type, items.len())),
  (("talk", 2), ("article", 1)),
)

// entry-type: trimmed, a blank or missing one `none`.
#assert.eq(adapter.entry-type((type: " Talk ")), "Talk")
#assert.eq(adapter.entry-type((type: " ")), none)
#assert.eq(adapter.entry-type((:)), none)

// basics-contacts: the details, a linebreak, then the profiles, as
// cv-header takes them, linked per `linked`.
#let basics = (
  email: "j@d.ie",
  location: (city: "Cork"),
  profiles: (
    (network: "GitHub", username: "jd", url: "https://github.com/jd"),
  ),
)
#let contacts = adapter.basics-contacts(basics)
#assert.eq(contacts.filter(c => type(c) == content).len(), 1)
#let records = contacts.filter(c => type(c) == dictionary)
#assert.eq(records.map(c => c.icon), ("email", "location", "github"))
#assert.eq(
  records.map(c => c.url),
  (
    "mailto:j@d.ie",
    maps-providers.google.replace("{q}", "Cork"),
    "https://github.com/jd",
  ),
)
// The alt text as `alta()` reads it: the profile's network as written,
// the rest resolved by `cv-header`.
#assert.eq(records.map(c => c.alt), (auto, auto, "GitHub"))
#assert.eq(
  adapter
    .basics-contacts(basics, linked: (profiles: false), full-urls: true)
    .last()
    .value,
  "github.com/jd",
)
#assert.eq(
  adapter.basics-contacts(basics, maps-provider: none).at(1).url,
  none,
)
#assert.eq(
  adapter
    .basics-contacts(
      (profiles: ((network: "Kaggle", username: "jd"),)),
      icons: (kaggle: "kaggle"),
    )
    .map(c => c.glyph),
  ("kaggle",),
)
// No linebreak with only one group.
#assert.eq(adapter.basics-contacts((email: "j@d.ie")).len(), 1)
#assert.eq(adapter.basics-contacts((:)), ())

// labels: the document language's, as `alta()` resolves them: its
// translation over the English, nested tables too, `overrides` over
// both, camelCase read as `alta()` reads it.
#context {
  let en = adapter.labels()
  assert.eq(en.work, "Experience")
  assert.eq(en.months.first(), "Jan")
  assert.eq(en.publication-types.talk, "Talks")
}
#[
  #set text(lang: "ga")
  #context {
    let ga = adapter.labels()
    assert.eq(ga.work, "Taithí Oibre")
    assert.eq(ga.present, "I láthair")
    assert.eq(ga.publication-types.article, "Ailt")
    // A table key the translation leaves out keeps the English.
    assert.eq(ga.publication-types.patent, "Patents")
    let ours = adapter.labels(overrides: (
      work: "Obair",
      otherProjects: "Eile",
      publication-types: (Talk: "Cainteanna"),
    ))
    assert.eq(ours.work, "Obair")
    assert.eq(ours.other-projects, "Eile")
    assert.eq(ours.publication-types.talk, "Cainteanna")
    assert.eq(ours.publication-types.article, "Ailt")
    assert.eq(ours.present, "I láthair")
  }
]

// preferences: every key, `overrides` over alta()'s defaults, the
// deprecated and camelCase forms read as alta() reads them.
#let prefs = adapter.preferences()
#assert.eq(prefs.column-ratio, 0.65)
#assert.eq(prefs.left-column-sections, (
  "work",
  "volunteer",
  "projects",
  "publications",
))
#assert.eq(prefs.publication-icons.talk, "microphone")
#assert.eq(prefs.maps-provider, maps-providers.google)
// The header follows the alignment around it unless set.
#assert.eq(prefs.header-text-align, none)
#assert.eq(
  adapter.preferences(overrides: (headerTextAlign: "center")).header-text-align,
  center,
)
#let ours = adapter.preferences(overrides: (
  columnRatio: 0.7,
  project-icons: (OSS: "github"),
))
#assert.eq(ours.column-ratio, 0.7)
#assert.eq(ours.project-icons, (oss: "github"))
#assert.eq(ours.max-rating, 5)

// entries: a section's entries as alta() renders them, the ones it
// skips left out; `focus-areas` from `custom.altacv`.
#let cv = (
  work: ((name: "A"), (position: "B")),
  projects: ((name: "P"), (summary: "No name"), (name: "")),
  skills: ((name: "Go", keywords: ("Channels",)), (name: "Empty")),
  references: (
    (name: "R", reference: "Great."),
    (name: "S"),
    (availableOnRequest: true),
  ),
  custom: (altacv: (focusAreas: ("Payments",))),
)
#assert.eq(adapter.entries(cv, "work").len(), 2)
#assert.eq(adapter.entries(cv, "projects"), ((name: "P"),))
#assert.eq(adapter.entries(cv, "skills").map(g => g.name), ("Go",))
#assert.eq(adapter.entries(cv, "references").len(), 2)
#assert.eq(adapter.entries(cv, "focus-areas"), ("Payments",))
#assert.eq(adapter.entries(cv, "awards"), ())
#assert.eq(adapter.entries((:), "focus-areas"), ())
