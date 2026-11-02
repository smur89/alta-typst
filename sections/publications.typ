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

// Built-in icon hints for common publication `type` strings. Lookup
// is case-insensitive (`"Talks"` and `"talks"` both match) but not
// number-insensitive — singular and plural forms are listed explicitly
// so callers can use either without thinking. Extend via
// `labels.publicationIcons`; unmatched types fall back to `file`.
#let _default_publication_icons = (
  articles: "newspaper",
  article: "newspaper",
  "blog posts": "newspaper",
  "blog post": "newspaper",
  books: "book",
  book: "book",
  talks: "microphone",
  talk: "microphone",
  theses: "book",
  thesis: "book",
  presentations: "microphone",
  presentation: "microphone",
  "conference papers": "newspaper",
  "conference paper": "newspaper",
  papers: "newspaper",
  paper: "newspaper",
)

// A label table keyed case-insensitively: user keys lowercased once,
// so `(Talks: ...)` matches `type: "talks"` and vice versa.
// Collisions after lowercasing are rejected up front by
// `_validate_labels`.
#let _lowercase_keys(table) = table
.pairs()
.fold((:), (acc, (k, v)) => acc + ((lower(k)): v))

// Groups appear in first-occurrence order (Typst dicts preserve
// insertion order). A JSON Resume type code (`article`, `talk`, …)
// takes its subheading from `labels.publicationTypes`; any other type
// is printed as given. Untyped entries fall under `labels.articles`.
// Subheading icons resolve via `labels.publicationIcons` →
// `_default_publication_icons` → `file`, keyed by the raw type.
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
