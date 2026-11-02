// Publications — grouped by JSON Resume's `type` with a
// type-appropriate icon on each subheading. Known type codes take
// their subheading from `labels.publicationTypes`; other types print
// as given. Untyped or invalid-type entries fall under
// `labels.articles`.

#import "../internal/state.typ": _body_colour, _body_size_state
#import "../internal/text.typ": _present, styled-link
#import "../internal/primitives.typ": _group_by_type
#import "../internal/icons.typ": icon
#import "../internal/dates.typ": _format_date

// Built-in icons, keyed by `type` (case-insensitive). Extend via
// `labels.publicationIcons`; unmatched types fall back to `file`.
// JSON Resume's codes (`patent` has no dedicated glyph, so it takes
// the `file` fallback):
#let _code_publication_icons = (
  article: "newspaper",
  book: "book",
  thesis: "book",
  talk: "microphone",
)
// Plural and free-text keys for the deprecated free-text headings
// (`"Articles"`, `"Talks"`); dropped with them in the next major
// (#239).
#let _legacy_publication_icons = (
  articles: "newspaper",
  "blog posts": "newspaper",
  "blog post": "newspaper",
  books: "book",
  theses: "book",
  talks: "microphone",
  presentations: "microphone",
  presentation: "microphone",
  "conference papers": "newspaper",
  "conference paper": "newspaper",
  papers: "newspaper",
  paper: "newspaper",
)
#let _default_publication_icons = (
  _code_publication_icons + _legacy_publication_icons
)

// Lowercase a label table's keys for case-insensitive lookup;
// `_validate_labels` rejects keys that collide.
#let _lowercase_keys(table) = table
.pairs()
.fold((:), (acc, (k, v)) => acc + ((lower(k)): v))

// Groups appear in first-occurrence order (Typst dicts preserve
// insertion order). Subheading icons resolve via
// `labels.publicationIcons` → `_default_publication_icons` → `file`,
// keyed by the raw type.
#let _publications(pubs, labels, prefs) = {
  // Drop entries with no usable `name` up front so the section
  // doesn't render an empty bullet, and so an empty section doesn't
  // emit an orphan heading. Matches the filter-first pattern used by
  // awards / projects.
  let valid = pubs.filter(p => _present(p.at("name", default: none)))
  if valid.len() == 0 { return }
  context {
    let body-size = _body_size_state.get()
    // A missing or non-string `type` (e.g. `none`, a number) falls
    // back to the default "Articles" heading rather than crashing at
    // `lower(group)` below.
    let groups = _group_by_type(valid, labels.articles)
    [== #labels.publications]
    let headings = _lowercase_keys(labels.publicationTypes)
    let user-icons-lc = _lowercase_keys(labels.publicationIcons)
    for (group, items) in groups.pairs() [
      #let lookup-key = lower(group)
      #let group-icon = user-icons-lc.at(
        lookup-key,
        default: _default_publication_icons.at(lookup-key, default: "file"),
      )
      #let heading = headings.at(lookup-key, default: group)
      ==== #icon(group-icon, size: 1.2 * body-size, shift: 0pt) #heading

      #for pub in items [
        #block(breakable: false)[
          #let date = pub.at("releaseDate", default: none)
          #let url = pub.at("url", default: none)
          #let title = pub.at("name", default: "")
          #let publisher = pub.at("publisher", default: none)
          #let summary = pub.at("summary", default: none)
          // `_present` so empty-string fields don't emit orphan `\` breaks.
          - #styled-link(title, dest: url).
            #if _present(publisher) [\ #text(
              0.85 * body-size,
              fill: _body_colour,
              publisher,
            )]
            #if _present(date) [\ #text(
              0.8 * body-size,
              fill: _body_colour.lighten(35%),
              _format_date(date, prefs, labels),
            )]
            #if _present(summary) [\ #par(summary)]
        ]
      ]
    ]
  }
}
