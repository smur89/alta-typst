// Publications — grouped by `type` (an altacv extension) with a
// type-appropriate icon on each subheading. Untyped entries fall
// under `labels.articles`.

#import "../internal/state.typ": _body_size_state, _body_colour
#import "../internal/text.typ": _present, _titled_link
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
  presentations: "microphone",
  presentation: "microphone",
  "conference papers": "newspaper",
  "conference paper": "newspaper",
  papers: "newspaper",
  paper: "newspaper",
)

// `pub.type` is a local extension. The grouping key is rendered
// verbatim as the subheading; groups appear in first-occurrence order
// (Typst dicts preserve insertion order). Untyped entries fall under
// `labels.articles`. Subheading icons resolve via
// `labels.publicationIcons` → `_default_publication_icons` → `file`.
#let _publications(pubs, labels, prefs) = if pubs.len() > 0 {
  context {
    let body-size = _body_size_state.get()
    let groups = (:)
    for pub in pubs {
      let key = pub.at("type", default: labels.articles)
      groups.insert(key, groups.at(key, default: ()) + (pub,))
    }
    [== #labels.publications]
    // Normalise user-supplied override keys to lowercase up front so
    // the case-insensitive contract holds symmetrically: `(Talks: ...)`
    // matches `type: "talks"` and vice versa. The built-in defaults
    // dict already uses lowercase keys. Length-mismatch after the fold
    // means two source keys collapsed onto one (e.g. `Talks` + `talks`
    // → `talks`); panic so the silent last-write-wins behaviour
    // surfaces as a configuration error.
    let user-icons = labels.at("publicationIcons", default: (:))
    let user-icons-lc = user-icons.pairs().fold(
      (:), (acc, (k, v)) => acc + ((lower(k)): v),
    )
    if user-icons-lc.len() != user-icons.len() {
      panic(
        "labels.publicationIcons has keys that collide after lowercasing — "
          + "matching is case-insensitive, so e.g. `Talks` and `talks` are equivalent. "
          + "Source keys: " + repr(user-icons.keys()),
      )
    }
    for (group, items) in groups.pairs() [
      #let lookup-key = lower(group)
      #let group-icon = user-icons-lc.at(
        lookup-key,
        default: _default_publication_icons.at(lookup-key, default: "file"),
      )
      ==== #icon(group-icon, size: 1.2 * body-size, shift: 0pt) #group

      #for pub in items [
        #block(breakable: false)[
          #let date = pub.at("releaseDate", default: none)
          #let url = pub.at("url", default: none)
          #let title = pub.at("name", default: "")
          #let publisher = pub.at("publisher", default: none)
          #let summary = pub.at("summary", default: none)
          - #_titled_link(title, url).
            #if publisher != none [\ #text(0.85 * body-size, fill: _body_colour, publisher)]
            #if date != none [\ #text(0.8 * body-size, fill: _body_colour.lighten(35%), _format_date(date, prefs, labels))]
            #if _present(summary) [\ #par(summary)]
        ]
      ]
    ]
  }
}
