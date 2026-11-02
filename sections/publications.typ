// Publications — grouped by JSON Resume's `type` code (matched
// case-insensitively) with a type-appropriate icon on each subheading.
// Known codes take their subheading from `labels.publicationTypes`;
// other types print as first written. Untyped or invalid-type entries
// count as `article`.

#import "../internal/state.typ": _body_colour, _body_size_state
#import "../internal/text.typ": _present, _present_str, styled-link
#import "../internal/primitives.typ": _group_by
#import "../internal/defaults.typ": _default_labels
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

// Subheadings per type code: the built-in table, then a CV's
// deprecated `labels.articles` override (#239: drop that line), then
// its `labels.publicationTypes` overrides. Layered like the icons, so a
// translation can set just the codes it uses.
#let _type_headings(labels) = {
  let defaults = _default_labels.publicationTypes
  let legacy = if labels.articles != _default_labels.articles {
    (article: labels.articles)
  } else { (:) }
  let overrides = if labels.publicationTypes != defaults {
    _lowercase_keys(labels.publicationTypes)
  } else { (:) }
  defaults + legacy + overrides
}

// Plural free-text types group with their JSON Resume code, so a
// legacy CV mixing `"Articles"` and untyped entries keeps one
// subheading. Deprecated with the free-text headings; dropped in the
// next major (#239).
#let _legacy_type_codes = (
  articles: "article",
  books: "book",
  patents: "patent",
  theses: "thesis",
  talks: "talk",
)

// A publication's group key: its lowercased `type`, or `article` when
// untyped or not a string, so `Talk` / `talk` and untyped / `article`
// each share one subheading.
#let _type_code(pub) = {
  let raw = pub.at("type", default: none)
  let code = if _present_str(raw) { lower(raw) } else { "article" }
  _legacy_type_codes.at(code, default: code)
}

// Groups appear in first-occurrence order (Typst dicts preserve
// insertion order). Subheading icons resolve via
// `labels.publicationIcons` → `_default_publication_icons` → `file`,
// keyed by the type code.
#let _publications(pubs, labels, prefs) = {
  // Drop entries with no usable `name` up front so the section
  // doesn't render an empty bullet, and so an empty section doesn't
  // emit an orphan heading. Matches the filter-first pattern used by
  // awards / projects.
  let valid = pubs.filter(p => _present(p.at("name", default: none)))
  if valid.len() == 0 { return }
  context {
    let body-size = _body_size_state.get()
    let groups = _group_by(valid, _type_code)
    [== #labels.publications]
    let headings = _type_headings(labels)
    let user-icons-lc = _lowercase_keys(labels.publicationIcons)
    for (code, items) in groups.pairs() [
      #let group-icon = user-icons-lc.at(
        code,
        default: _default_publication_icons.at(code, default: "file"),
      )
      // A code with no heading is free text: every entry in its group
      // has a string `type`, so print the first as written. (Not via
      // `default:`, which is evaluated even when the key exists.)
      #let heading = if code in headings { headings.at(code) } else {
        items.first().type
      }
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
