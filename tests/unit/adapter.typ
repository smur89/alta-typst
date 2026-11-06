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
// untyped under `none`, as `alta()` groups projects.
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

// basics-contacts: the details, a linebreak, then the profiles, as
// cv-header takes them, linked per `link`.
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
    .basics-contacts(basics, link: (profiles: false), full-urls: true)
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
