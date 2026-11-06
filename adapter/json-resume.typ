// The JSON Resume mapping: a CV dictionary in the JSON Resume schema
// turned into altacv's public markup blocks (`cv-header`, `entry`,
// `publication`, `skills`, …). It is what `alta(cv)` renders inside
// `#show: altacv.with(..)`, written to be read and copied (#370).
//
// It reads JSON Resume's camelCase fields (`startDate`) and altacv's
// extensions under `custom.altacv`.
//
// To adapt it, copy this file into your project, replace the imports
// below with one
//
//   #import "@preview/altacv:<version>": adapter, cv-columns, cv-header, divider, entry, icon, label-row, maps-providers, publication, rating, skills
//
// and edit what it draws. Then, in your CV:
//
//   #import "json-resume.typ": resume
//   #show: altacv
//   #let cv = json("resume.json")
//   #set document(title: cv.basics.name, author: cv.basics.name)
//   #resume(cv)
//
// The `set document` is only the PDF's metadata. In your copy, a bare
// `basics.image` path resolves from your copy's file.
//
// The names below are the public API (`lib.typ` re-exports exactly
// these); this file imports them from the modules that define them
// because `alta()`, which renders it, sits inside `lib.typ`.

#import "../internal/blocks.typ": (
  cv-columns, cv-header, entry, label-row, publication, skills,
)
#import "../internal/components/ratings.typ": rating
#import "../internal/data/defaults.typ": maps-providers
#import "../internal/icons.typ": icon
#import "../internal/primitives.typ": divider
#import "../internal/adapter.typ" as adapter

// A field's value, or `none` when it's absent, empty or blank content,
// as `alta()` reads a field.
#let _field(obj, key) = {
  let value = obj.at(key, default: none)
  if value not in (none, "", []) { value }
}

// A field that's a non-empty string, else `none`: the fields `alta()`
// reads leniently (a reference's attribution, a citation's parts).
#let _string(obj, key) = {
  let value = obj.at(key, default: none)
  if type(value) == str and value != "" { value }
}

// A field that's an array of text, else `()`: work's `keywords`,
// which `alta()` reads leniently.
#let _texts(obj, key) = {
  let value = obj.at(key, default: none)
  if type(value) == array and value.all(v => type(v) in (str, content)) {
    value
  } else { () }
}

// An entry's summary: its `summary`, else its `description`, the field
// JSON Resume's projects use (and older exports' work and volunteer).
#let _summary(entry) = {
  let summary = _field(entry, "summary")
  if summary != none { summary } else { _field(entry, "description") }
}

// One of altacv's own fields, in the entry's `custom.altacv`.
#let _altacv(obj, key, default: none) = {
  let custom = obj.at("custom", default: none)
  let ns = if type(custom) == dictionary {
    custom.at("altacv", default: none)
  }
  if type(ns) == dictionary { ns.at(key, default: default) } else { default }
}

// An entry's `type` as `alta()` reads it, trimmed, or `none` when it's
// untyped: the adapter's grouping of the one entry.
#let _type(entry) = adapter.group-by-type((entry,)).first().first()

// A `==` group heading led by its icon, in the heading's colour: the
// icon's box and the gap after it in the heading's own `em`.
#let _icon-heading(name, body) = [#context icon(name, fill: text.fill) #body]

// A section: its `=` heading, then `body`; nothing, not even the
// heading, when it has no entries.
#let _frame(title, entries, body) = if entries.len() > 0 {
  [= #title]
  body
}

// A section of one block per entry.
#let _section(title, entries, render) = _frame(
  title,
  entries,
  entries.map(render).join(),
)

// `resume` with the labels resolved, as `alta()` has them already.
#let _resume(cv, labels, preferences) = {
  // JSON Resume requires no field, `basics` included.
  let basics = cv.at("basics", default: (:))
  let name = _field(basics, "name")
  // The names set apart among publication authors, as `alta()` sets
  // them apart: the CV's name and `owner-names`; with neither, `auto`,
  // the document's author.
  let owners = (
    (name,).filter(n => n != none) + preferences.at("owner-names", default: ())
  )
  let owners = if owners.len() > 0 { owners } else { auto }
  let max-rating = preferences.at("max-rating", default: 5)

  // A date as `alta()` shows it, per `date-format` and the months.
  let date(value) = if value != none {
    adapter.format-date(
      value,
      format: preferences.at("date-format", default: "long"),
      months: labels.months,
    )
  }
  // `entry`'s `(start, end)` pair: the end, else "Present" when there's
  // a start.
  let period(obj) = {
    let start = _field(obj, "startDate")
    let end = _field(obj, "endDate")
    (
      date(start),
      if end != none { date(end) } else if start != none {
        labels.present
      },
    )
  }
  // A location's parts, which `entry` joins in the theme's style.
  let location(obj) = adapter.location-text(obj.at("location", default: none))
  // Highlights as a list, the entry's body.
  let bullets(obj) = obj.at("highlights", default: ()).map(h => [- #h]).join()

  // work[] and volunteer[]: the same entry, the organisation under a
  // different key; only work shows keywords.
  let role(e, org, keywords: ()) = entry(
    title: _field(e, "position"),
    org: _field(e, org),
    org-url: _field(e, "url"),
    date: period(e),
    location: location(e),
    summary: _summary(e),
    keywords: keywords,
    bullets(e),
  )

  let project(p) = entry(
    title: p.name,
    url: _field(p, "url"),
    org: _field(p, "entity"),
    roles: p.at("roles", default: ()),
    date: period(p),
    summary: _summary(p),
    keywords: p.at("keywords", default: ()),
    bullets(p),
  )

  let pub(p) = {
    let summary = _field(p, "summary")
    let ids = p.at("identifiers", default: none)
    publication(
      title: p.name,
      url: _field(p, "url"),
      authors: p
        .at("authors", default: ())
        .filter(a => type(a) == str and a.trim() != ""),
      owners: owners,
      source: _field(p, "publisher"),
      citation: (
        volume: _string(p, "volume"),
        issue: _string(p, "issue"),
        pages: _string(p, "pages"),
      ),
      date: date(_field(p, "releaseDate")),
      identifiers: if type(ids) == dictionary {
        ids.pairs().filter(((_, id)) => type(id) == str and id != "").to-dict()
      } else { (:) },
      if summary != none [#summary] else [],
    )
  }

  let sections = (
    work: () => _section(
      labels.work,
      cv.at("work", default: ()),
      e => role(e, "name", keywords: _texts(e, "keywords")),
    ),
    volunteer: () => _section(
      labels.volunteer,
      cv.at("volunteer", default: ()),
      e => role(e, "organization"),
    ),
    // Under a heading per `type`, in the order each first appears,
    // only when some project has one; the untyped under "Other".
    projects: () => {
      let projects = cv
        .at("projects", default: ())
        .filter(p => _field(p, "name") != none)
      let types = projects.map(_type)
      if types.all(t => t == none) {
        _section(labels.projects, projects, project)
      } else {
        let other = labels.other-projects
        let icons = preferences.at("project-icons", default: (:))
        let groups = adapter.group-by-type(
          projects
            .zip(types)
            .map(((p, t)) => p + (type: if t == none { other } else { t })),
        )
        let group((kind, items)) = {
          let name = icons.at(lower(kind), default: "folder")
          [== #_icon-heading(name, kind)]
          items.map(project).join()
        }
        _section(labels.projects, groups, group)
      }
    },
    // Under a heading per `type` code, matched ignoring case, the
    // untyped among the articles; a code with no label is headed as
    // first written.
    publications: () => {
      let headings = labels.publication-types
      let icons = preferences.at("publication-icons", default: (
        article: "newspaper",
        book: "book",
        thesis: "book",
        talk: "microphone",
      ))
      // Each publication under its code, beside its type as written.
      let coded = cv
        .at("publications", default: ())
        .filter(p => _field(p, "name") != none)
        .map(p => {
          let written = _type(p)
          (
            type: if written == none { "article" } else { lower(written) },
            written: written,
            pub: p,
          )
        })
      _section(
        labels.publications,
        adapter.group-by-type(coded),
        ((code, items)) => {
          let heading = headings.at(code, default: items.first().written)
          [== #_icon-heading(icons.at(code, default: "file"), heading)]
          items.map(item => pub(item.pub)).join()
        },
      )
    },
    focus-areas: () => {
      let items = _altacv(cv, "focusAreas", default: ())
      _frame(
        labels.focus-areas,
        items,
        list(..items),
      )
    },
    // The group's `custom.altacv.rating` as dots, else its level, a
    // term `skills` rates as dots; `skill-level-display: "text"` keeps
    // the level text, as content, which `skills` shows as written.
    skills: () => _section(
      labels.skills,
      cv
        .at("skills", default: ())
        .filter(g => g.at("keywords", default: ()).len() > 0),
      g => {
        let level = _field(g, "level")
        let as-text = (
          preferences.at("skill-level-display", default: auto) == "text"
        )
        skills(
          g.name,
          g.keywords,
          level: if as-text {
            if level != none [#level]
          } else { _altacv(g, "rating", default: level) },
          max: max-rating,
        )
      },
    ),
    // Dots for a rated fluency, else the fluency as text; the rows
    // spaced as entries are, without the rule.
    languages: () => {
      let langs = cv
        .at("languages", default: ())
        .filter(l => _field(l, "language") != none)
      _frame(labels.languages, langs, {
        show std.divider: none
        // Rows, not prose: a long name wraps unjustified.
        set par(justify: false)
        langs
          .map(l => {
            let value = adapter.fluency-rating(l, max: max-rating)
            block(breakable: false, rating(
              l.language,
              if value != none { value } else { _string(l, "fluency") },
              max: max-rating,
            ))
          })
          .join(divider())
      })
    },
    // The area leads the score when it isn't the title; the courses
    // end the entry.
    education: () => _section(
      labels.education,
      cv.at("education", default: ()),
      e => {
        let study-type = _field(e, "studyType")
        let area = _field(e, "area")
        entry(
          title: if study-type != none { study-type } else { area },
          org: _field(e, "institution"),
          org-url: _field(e, "url"),
          date: period(e),
          location: location(e),
          summary: _field(e, "summary"),
          keywords-lead: (
            (if study-type != none { area },),
            (_field(e, "score"),),
          ),
          keywords: e.at("courses", default: ()),
        )[]
      },
    ),
    // Short rows: the spacing between them without the rule. A
    // certificate without an expiry has no end, not "Present".
    certificates: () => {
      show std.divider: none
      _section(
        labels.certificates,
        cv
          .at("certificates", default: ())
          .filter(c => _field(c, "name") != none),
        c => {
          let expiry = _field(c, "expiryDate")
          entry(
            title: c.name,
            url: _field(c, "url"),
            org: _field(c, "issuer"),
            details: (_field(c, "credentialId"),),
            date: if expiry != none {
              (date(_field(c, "date")), date(expiry))
            } else {
              date(_field(c, "date"))
            },
            summary: _field(c, "summary"),
          )[]
        },
      )
    },
    awards: () => _section(
      labels.awards,
      cv.at("awards", default: ()).filter(a => _field(a, "title") != none),
      a => entry(
        title: a.title,
        url: _altacv(a, "url"),
        org: _field(a, "awarder"),
        date: date(_field(a, "date")),
        summary: _field(a, "summary"),
      )[],
    ),
    // One row per group, kept together as `alta()`'s one paragraph of
    // them keeps its lines: the first row with the second (no orphan at
    // a page's foot), the last with the one before (no widow at the top).
    interests: () => {
      let groups = cv
        .at("interests", default: ())
        .filter(g => g.at("keywords", default: ()).len() > 0)
      _frame(
        labels.interests,
        groups,
        groups
          .enumerate()
          .map(((i, g)) => {
            set block(
              sticky: (
                i < groups.len() - 1 and (i == 0 or i == groups.len() - 2)
              ),
            )
            label-row(g.name, g.keywords)
          })
          .join(),
      )
    },
    // A quote under the referee's name and attribution; on request,
    // the on-request line in its place, and when every reference is
    // on request, that line alone.
    references: () => {
      let on-request = labels.references-available-on-request
      let requested(r) = r.at("availableOnRequest", default: false) == true
      let refs = cv
        .at("references", default: ())
        .filter(r => requested(r) or _field(r, "reference") != none)
      let title = labels.references
      if refs.len() > 0 and refs.all(requested) {
        _frame(title, refs, entry(summary: on-request)[])
      } else {
        _section(title, refs, r => entry(
          title: _field(r, "name"),
          subtitle: (
            (_string(r, "relationship"), _string(r, "organization")),
            (date(_string(r, "date")),),
          ),
          summary: if requested(r) { on-request } else { r.reference },
        )[])
      }
    },
  )

  // The header: `basics.image` framed when it's set; the QR code
  // `basics.url` when `auto`.
  // Its text follows the alignment around it, `header-text-align`'s
  // when that's set.
  let image-src = _field(basics, "image")
  let image-src = if type(image-src) != bytes or image-src.len() > 0 {
    image-src
  }
  let qr-code = preferences.at("qr-code", default: none)
  let header = cv-header(
    name: if name != none { name } else { auto },
    tagline: _field(basics, "label"),
    objective: _field(cv, "objective"),
    // The location's alt text from `labels.location`, as `alta()` reads
    // it.
    contacts: adapter
      .basics-contacts(
        basics,
        link: preferences.at("link-contact-info", default: true),
        maps-provider: preferences.at(
          "maps-provider",
          default: maps-providers.google,
        ),
        full-urls: preferences.at("print-full-urls", default: false),
        icons: preferences.at("profile-icons", default: auto),
      )
      .map(c => if type(c) == dictionary and c.icon == "location" {
        c + (alt: labels.location)
      } else { c }),
    photo: if image-src != none { image(image-src) },
    photo-side: preferences.at("image-position", default: right),
    photo-size: preferences.at("image-size", default: auto),
    photo-shape: preferences.at("image-shape", default: auto),
    qr: if qr-code == auto { _field(basics, "url") } else { qr-code },
    uppercase: preferences.at("uppercase-name", default: true),
  )
  let text-align = preferences.at("header-text-align", default: none)
  if text-align != none { align(text-align, header) } else { header }

  // Below the header, the paragraphs justified per `justify`: the
  // intro, summaries, highlights and publications, as `alta()`
  // justifies them. An entry's rows of facts and keywords, and the
  // skill and interest rows, set their own off; the languages, below.
  // Without the preference, the caller's own `set par` stands.
  set par(justify: preferences.at("justify", default: false)) if (
    "justify" in preferences
  )

  // The intro: `basics.summary`, in a block the template spaces from
  // the header and the columns (`show <alta-intro>: set block(..)`).
  let summary = _field(basics, "summary")
  // The part label on a wrapper of its own, so a label the summary
  // carries stays.
  if summary != none [#block(par[#[#summary#[]]<alta-summary>])<alta-intro>]

  // The columns: the left sections beside the right, the left taking
  // `column-ratio`; one column when no section is on the right.
  let column(keys) = keys.map(key => (sections.at(key))()).join()
  let right = preferences.at("right-column-sections", default: (
    "focus-areas",
    "skills",
    "languages",
    "education",
    "certificates",
    "awards",
    "interests",
    "references",
  ))
  cv-columns(
    column(preferences.at(
      "left-column-sections",
      default: ("work", "volunteer", "projects", "publications"),
    )),
    // Content, even when the sections are empty, as `alta()` keeps the
    // right column then.
    if right.len() > 0 [#column(right)],
    ratio: preferences.at("column-ratio", default: 0.65),
  )
}

/// The CV as `alta(cv)` renders it in the template: the header, the
/// intro, then the column sections side by side.
///
/// - cv (dictionary): The CV, in the JSON Resume schema (camelCase
///   fields) plus altacv's `custom.altacv` extensions.
/// - labels (auto, dictionary): Display strings, by `alta()`'s
///   kebab-case label keys (`work`, `other-projects`,
///   `publication-types`, …), over the document language's
///   (`adapter.labels()`); `auto` is those alone.
/// - preferences (dictionary): Settings, by `alta()`'s kebab-case
///   preference keys (`column-ratio`, `date-format`, …); a missing key
///   reads alta's default.
///
/// The name is `basics.name`, else the document's title; the owners
/// set apart among publication authors are it and `owner-names`, else
/// the document's author.
/// -> content
#let resume(cv, labels: auto, preferences: (:)) = context _resume(
  cv,
  adapter.labels(overrides: if labels == auto { (:) } else { labels }),
  preferences,
)
