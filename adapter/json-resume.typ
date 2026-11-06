// The JSON Resume mapping: a CV dictionary in the JSON Resume schema
// turned into altacv's public markup blocks (`cv-header`, `entry`,
// `publication`, `skill-row`, …). It is what `alta(cv)` renders inside
// `#show: altacv.with(..)`, written to be read and copied (#370).
//
// It takes validated JSON Resume: `alta()`'s checked CV, or
// gairm-import's `parse(..)` of a `resume.json`. It reads JSON
// Resume's camelCase fields (`startDate`) and altacv's extensions under
// `custom.altacv` as the schema types them, without checking them.
//
// To adapt it, copy this file into your project, replace the imports
// below with one
//
//   #import "@preview/altacv:<version>": adapter, cv-columns, cv-header, divider, entry, icon, label-row, publication, rating, skill-row
//
// and edit what it draws. Then, in your CV:
//
//   #import "@preview/altacv:<version>": altacv
//   #import "@preview/gairm-import:0.10.1": parse
//   #import "json-resume.typ": resume
//   #show: altacv
//   #set document(title: "Jane Doe", author: "Jane Doe")
//   #resume(parse(path("resume.json")))
//
// Labels come from the template, `#show: altacv.with(labels: ..)`,
// which the blocks read too. The `set document` is only the PDF's
// metadata. In your copy, a bare `basics.image` path resolves from
// your copy's file.
//
// The names below are the public API (`lib.typ` re-exports exactly
// these); this file imports them from the modules that define them
// because `alta()`, which renders it, sits inside `lib.typ`.

#import "../internal/blocks.typ": (
  cv-columns, cv-header, entry, label-row, publication, skill-row,
)
#import "../internal/components/ratings.typ": rating
#import "../internal/icons.typ": icon
#import "../internal/primitives.typ": divider
#import "../internal/adapter.typ" as adapter

// A field's value, or `none` when it's absent: an empty string or
// blank content counts as missing, so it leaves no empty line.
#let _field(obj, key) = {
  let value = obj.at(key, default: none)
  if value not in ("", []) { value }
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

// `resume` with the labels and preferences resolved, as `alta()` has
// them already.
#let _resume(cv, labels, prefs) = {
  // JSON Resume requires no field, `basics` included.
  let basics = cv.at("basics", default: (:))
  let name = _field(basics, "name")
  // The names set apart among publication authors, as `alta()` sets
  // them apart: the CV's name and `owner-names`; with neither, `auto`,
  // the document's author.
  let owners = (
    (name,).filter(n => n != none) + prefs.owner-names
  )
  let owners = if owners.len() > 0 { owners } else { auto }
  let max-rating = prefs.max-rating

  // A date as `alta()` shows it, per `date-format` and the months.
  let date(value) = if value != none {
    adapter.format-date(
      value,
      format: prefs.date-format,
      months: labels.months,
    )
  }
  // `entry`'s `(start, end)` pair, an open end reading the labels'
  // "Present".
  let period(obj) = (
    date(_field(obj, "startDate")),
    date(_field(obj, "endDate")),
  )
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
    publication(
      title: p.name,
      url: _field(p, "url"),
      authors: p.at("authors", default: ()),
      owners: owners,
      source: _field(p, "publisher"),
      citation: (
        volume: _field(p, "volume"),
        issue: _field(p, "issue"),
        pages: _field(p, "pages"),
      ),
      date: date(_field(p, "releaseDate")),
      identifiers: p.at("identifiers", default: (:)),
      _field(p, "summary"),
    )
  }

  let sections = (
    work: () => _section(
      labels.work,
      adapter.entries(cv, "work"),
      e => role(e, "name", keywords: e.at("keywords", default: ())),
    ),
    volunteer: () => _section(
      labels.volunteer,
      adapter.entries(cv, "volunteer"),
      e => role(e, "organization"),
    ),
    // Under a heading per `type`, in the order each first appears,
    // only when some project has one; the untyped under "Other".
    projects: () => {
      let projects = adapter.entries(cv, "projects")
      let types = projects.map(_type)
      if types.all(t => t == none) {
        _section(labels.projects, projects, project)
      } else {
        let other = labels.other-projects
        let icons = prefs.project-icons
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
      let icons = prefs.publication-icons
      // Each publication under its code, beside its type as written.
      let coded = adapter
        .entries(cv, "publications")
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
      let items = adapter.entries(cv, "focus-areas")
      _frame(
        labels.focus-areas,
        items,
        list(..items),
      )
    },
    // The group's `custom.altacv.rating` as dots, else its level, a
    // term `skill-row` rates as dots; `skill-level-display: "text"` keeps
    // the level text, as content, which `skill-row` shows as written.
    skills: () => _section(
      labels.skills,
      adapter.entries(cv, "skills"),
      g => {
        let level = _field(g, "level")
        let as-text = (
          prefs.skill-level-display == "text"
        )
        skill-row(
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
      let langs = adapter.entries(cv, "languages")
      _frame(labels.languages, langs, {
        show std.divider: none
        // Rows, not prose: a long name wraps unjustified.
        set par(justify: false)
        langs
          .map(l => {
            let value = adapter.fluency-rating(l, max: max-rating)
            block(breakable: false, rating(
              l.language,
              if value != none { value } else { _field(l, "fluency") },
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
      adapter.entries(cv, "education"),
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
        )
      },
    ),
    // Short rows: the spacing between them without the rule. A
    // certificate without an expiry has no end, not "Present".
    certificates: () => {
      show std.divider: none
      _section(
        labels.certificates,
        adapter.entries(cv, "certificates"),
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
          )
        },
      )
    },
    awards: () => _section(
      labels.awards,
      adapter.entries(cv, "awards"),
      a => entry(
        title: a.title,
        url: _altacv(a, "url"),
        org: _field(a, "awarder"),
        date: date(_field(a, "date")),
        summary: _field(a, "summary"),
      ),
    ),
    // One row per group, kept together as `alta()`'s one paragraph of
    // them keeps its lines: the first row with the second (no orphan at
    // a page's foot), the last with the one before (no widow at the top).
    interests: () => {
      let groups = adapter.entries(cv, "interests")
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
      let requested(r) = r.at("availableOnRequest", default: false)
      let refs = adapter.entries(cv, "references")
      let title = labels.references
      if refs.len() > 0 and refs.all(requested) {
        _frame(title, refs, entry(summary: on-request))
      } else {
        _section(title, refs, r => entry(
          title: _field(r, "name"),
          subtitle: (
            (_field(r, "relationship"), _field(r, "organization")),
            (date(_field(r, "date")),),
          ),
          summary: if requested(r) { on-request } else { r.reference },
        ))
      }
    },
  )

  // The header: `basics.image` framed when it's set; the QR code
  // `basics.url` when `auto`.
  // Its text follows the alignment around it, `header-text-align`'s
  // when that's set.
  let image-src = _field(basics, "image")
  let qr-code = prefs.qr-code
  let header = cv-header(
    name: if name != none { name } else { auto },
    tagline: _field(basics, "label"),
    objective: _field(cv, "objective"),
    contacts: adapter.basics-contacts(
      basics,
      linked: prefs.link-contact-info,
      maps-provider: prefs.maps-provider,
      full-urls: prefs.print-full-urls,
      icons: prefs.profile-icons,
    ),
    photo: if image-src != none { image(image-src) },
    photo-position: prefs.photo-position,
    photo-size: prefs.photo-size,
    photo-shape: prefs.photo-shape,
    qr: if qr-code == auto { _field(basics, "url") } else { qr-code },
    uppercase: prefs.uppercase-name,
  )
  let text-align = prefs.header-text-align
  if text-align != none { align(text-align, header) } else { header }

  // The prose (the intro, summaries, highlights and publications)
  // takes the caller's `set par(justify: ..)`. An entry's rows of facts
  // and keywords, and the skill and interest rows, set their own off;
  // the languages, below.

  // The intro: `basics.summary`, in a block the template spaces from
  // the header and the columns (`show <alta-intro>: set block(..)`).
  let summary = _field(basics, "summary")
  // The part label on a wrapper of its own, so a label the summary
  // carries stays. Full width, so a justified summary stretches to the
  // column rather than to its own widest line.
  if summary != none [#block(
    width: 100%,
    par[#[#summary#[]]<alta-summary>],
  )<alta-intro>]

  // The columns: the left sections beside the right, the left taking
  // `column-ratio`; one column when no section is on the right.
  let column(keys) = keys.map(key => (sections.at(key))()).join()
  let right = prefs.right-column-sections
  cv-columns(
    column(prefs.left-column-sections),
    // Content, even when the sections are empty, as `alta()` keeps the
    // right column then.
    if right.len() > 0 [#column(right)],
    ratio: prefs.column-ratio,
  )
}

/// The CV as `alta(cv)` renders it in the template: the header, the
/// intro, then the column sections side by side.
///
/// - cv (dictionary): The CV, validated JSON Resume (camelCase fields)
///   plus altacv's `custom.altacv` extensions: gairm-import's
///   `parse(path("resume.json"))`, or the CV `alta()` has checked. Its
///   field types aren't checked again here.
/// - preferences (dictionary): Settings, by `alta()`'s kebab-case
///   preference keys (`column-ratio`, `date-format`, …), merged over
///   its defaults and checked (`adapter.preferences()`).
///
/// The labels are the resolved ones (`adapter.labels()`), as the
/// blocks read them: the document language's, under the template's
/// (`altacv.with(labels: ..)`) and, through `alta(cv, labels: ..)`,
/// that call's. The name is `basics.name`, else the document's title; the owners
/// set apart among publication authors are it and `owner-names`, else
/// the document's author.
/// -> content
#let resume(cv, preferences: (:)) = context _resume(
  cv,
  adapter.labels(),
  adapter.preferences(overrides: preferences),
)
