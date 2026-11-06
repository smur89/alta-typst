// The public adapter helpers, over the internal ones alta() uses:
// what each reads of the CV as `alta()` reads it. The internal stages
// with no adapter helper over them keep their own files (dates.typ,
// ratings.typ, values.typ, header.typ).

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
#assert.eq(adapter.format-date("2024-06-15", format: "short"), "15/06/2024")
#assert.eq(adapter.format-date("2024-06", format: "iso"), "2024-06")
#assert.eq(
  adapter.format-date("2024-06", format: p => str(p.year) + "Q2"),
  "2024Q2",
)
#assert.eq(adapter.format-date(""), "")
// A template's tokens and modifiers; a part the date lacks drops out
// with the separator before it.
#let template(value, format) = adapter.format-date(value, format: format)
#assert.eq(template("2024-06-05", "[day]/[month]/[year]"), "05/06/2024")
#assert.eq(
  template("2024-06-05", "[day padding:none] [month repr:long] [year]"),
  "5 Jun 2024",
)
#assert.eq(template("2024-06", "[day]/[month]/[year]"), "06/2024")
#assert.eq(template("2024", "[day] · [month repr:short] [year]"), "2024")
#assert.eq(template("2024-06", "[month repr:numerical]"), "06")
// Short month names slice by grapheme, so a localised name starting
// with a multi-byte character doesn't split mid-character.
#assert.eq(
  adapter.format-date(
    "2024-03",
    format: "[month repr:short]",
    months: range(1, 13).map(m => if m == 3 { "März" } else { str(m) }),
  ),
  "Mär",
)

// location-parts: the parts in display order, for the theme to join.
#assert.eq(
  adapter.location-parts((city: "Cork", countryCode: "IE")),
  ("Cork", "IE"),
)
#assert.eq(adapter.location-parts("Dublin"), ("Dublin",))
#assert.eq(adapter.location-parts(none), ())
// A string whole; a dictionary's city, region and country code, in
// that order, the rest (`address`) not shown and an absent one
// dropped.
#assert.eq(adapter.location-parts("Cork, Ireland"), ("Cork, Ireland",))
#assert.eq(
  adapter.location-parts((
    countryCode: "IE",
    address: "1 Main St",
    region: "Munster",
    city: "Cork",
  )),
  ("Cork", "Munster", "IE"),
)
#assert.eq(adapter.location-parts((city: "", countryCode: "IE")), ("IE",))
#assert.eq(adapter.location-parts((postalCode: "T12")), ())
#assert.eq(adapter.location-parts(""), ())

// fluency-rating: `custom.altacv.rating` as given, over the fluency;
// else LinkedIn's fluency terms, ignoring case and surrounding spaces,
// on the scale of `max`, to the half (Full Professional is 0.8: 3.2
// of 4 rounds to 3, 4.8 of 6 to 5); any other term `none`.
#let fluency(term, max: 5) = adapter.fluency-rating(
  (language: "X", fluency: term),
  max: max,
)
#assert.eq(adapter.fluency-rating((language: "Irish", fluency: "Native")), 5)
#assert.eq(
  adapter.fluency-rating((language: "X", custom: (altacv: (rating: 2.5)))),
  2.5,
)
#assert.eq(
  adapter.fluency-rating((
    language: "X",
    fluency: "Native",
    custom: (altacv: (rating: 2.5)),
  )),
  2.5,
)
#assert.eq(fluency("Elementary", max: 10), 2)
#assert.eq(fluency("Elementary", max: 6), 1)
#assert.eq(fluency("Professional Working"), 3)
#assert.eq(fluency("Full Professional", max: 4), 3)
#assert.eq(fluency("Full Professional", max: 6), 5)
#assert.eq(fluency(" native "), 5)
#assert.eq(fluency("Some"), none)

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
#let sizes(..args) = (
  adapter.group-by-type(..args).map(((type, items)) => (type, items.len()))
)
// A type is read as `alta()` reads it: trimmed, a blank, empty,
// missing or non-string one untyped.
#assert.eq(
  sizes(((type: " talk "), (type: " "), (type: "talk"))),
  (("talk", 2), (none, 1)),
)
#assert.eq(sizes(((:), (type: 3), (type: "x"))), ((none, 2), ("x", 1)))
// `untyped` names the untyped group, which a type of that name shares,
// as projects' "Other" does.
#assert.eq(
  sizes(
    ((type: "OSS"), (:), (type: ""), (type: 3), (type: "Other")),
    untyped: "Other",
  ),
  (("OSS", 1), ("Other", 4)),
)
// Publications' codes: `key: lower` matches types ignoring case, the
// untyped among the articles, in the order each group first appears.
#assert.eq(
  sizes(
    ((type: "Talk"), (:), (type: " talk "), (type: "Article")),
    key: lower,
    untyped: "article",
  ),
  (("talk", 2), ("article", 2)),
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
#assert.eq(contacts.map(type), (dictionary, dictionary, content, dictionary))
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

// The details in display order, an empty one left out: a phone links
// its dialable `tel:` URI, a location its maps link, URL-encoded by
// UTF-8 byte, RFC 3986's unreserved characters kept.
#let maps = "https://maps.example/?q={q}"
#let details = adapter.basics-contacts(
  (
    email: "jane@example.com",
    phone: "+353 (21) 123-4567",
    location: (city: "Cork", countryCode: "IE"),
    url: "",
  ),
  maps-provider: maps,
)
#assert.eq(details.map(c => c.icon), ("email", "phone", "location"))
#assert.eq(details.at(1).value, "+353 (21) 123-4567")
#assert.eq(
  details.map(c => c.url),
  (
    "mailto:jane@example.com",
    "tel:+353211234567",
    "https://maps.example/?q=Cork%2C%20IE",
  ),
)
#let maps-query(city) = (
  adapter
    .basics-contacts((location: (city: city)), maps-provider: maps)
    .first()
    .url
    .slice(maps.len() - 3)
)
#assert.eq(maps-query("AZaz09-._~"), "AZaz09-._~")
#assert.eq(maps-query("Zürich"), "Z%C3%BCrich")
#assert.eq(maps-query("京都"), "%E4%BA%AC%E9%83%BD")

// `linked`: a bool for every channel, or a dictionary over all-true.
#let urls(linked) = (
  adapter
    .basics-contacts(basics + (phone: "1"), linked: linked)
    .filter(c => type(c) == dictionary)
    .map(c => c.url)
)
#assert.eq(urls(false), (none, none, none, none))
#assert.eq(
  urls((phone: false)),
  (
    "mailto:j@d.ie",
    none,
    maps-providers.google.replace("{q}", "Cork"),
    "https://github.com/jd",
  ),
)

// A profile's network: an alias draws its glyph, `alt` keeps the
// spelling; without a `url` the username shows unlinked, without a
// `username` the URL shows, its scheme dropped, linked in full.
#let profile(p, ..args) = (
  adapter.basics-contacts((profiles: (p,)), ..args).first()
)
#let x = profile((network: "X", username: "jane"))
#assert.eq((x.glyph, x.alt, x.value, x.url), ("twitter", "X", "jane", none))
#let gh = profile((network: "GitHub", url: "https://github.com/jane"))
#assert.eq(
  (gh.glyph, gh.value, gh.url),
  ("github", "github.com/jane", "https://github.com/jane"),
)
// `icons`: the network as written wins over its alias's key, which
// still covers the alias when the network itself is unmapped.
#let glyph(icons) = {
  profile(
    (network: "X", username: "jane"),
    icons: icons,
  ).glyph
}
#assert.eq(glyph((x: "x-twitter", twitter: "twitter")), "x-twitter")
#assert.eq(glyph((twitter: "square-twitter")), "square-twitter")

// A homepage shows its URL without the scheme or a trailing slash.
#let homepage(url) = adapter.basics-contacts((url: url)).first().value
#assert.eq(homepage("https://jane.dev/"), "jane.dev")
#assert.eq(homepage("http://x.io/a/b?q=1"), "x.io/a/b?q=1")
#assert.eq(homepage("jane.dev"), "jane.dev")
// `full-urls`: an unlinked profile shows its URL, scheme dropped, in
// place of its username; a linked one, the email (not a web channel)
// and a profile without a `url` keep their value.
#let values(linked) = (
  adapter
    .basics-contacts(
      (
        email: "j@x.io",
        url: "https://x.io",
        profiles: (
          (network: "GitHub", username: "jane", url: "https://github.com/jane"),
          (network: "Link", username: "jane"),
        ),
      ),
      linked: linked,
      full-urls: true,
    )
    .filter(c => type(c) == dictionary)
    .map(c => c.value)
)
#assert.eq(values(false), ("j@x.io", "x.io", "github.com/jane", "jane"))
#assert.eq(values(true), ("j@x.io", "x.io", "jane", "jane"))
// A group of profiles alone: no linebreak.
#assert.eq(
  adapter
    .basics-contacts((profiles: ((network: "GitHub", username: "jd"),)))
    .len(),
  1,
)

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
// As alta() reads it: the default alignment unless set.
#assert.eq(prefs.header-text-align, left)
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

// custom: a field of `custom.altacv`, else the default.
#assert.eq(adapter.custom((custom: (altacv: (rating: 3))), "rating"), 3)
#assert.eq(adapter.custom((custom: (altacv: (:))), "url"), none)
#assert.eq(adapter.custom((:), "focusAreas", default: ()), ())
