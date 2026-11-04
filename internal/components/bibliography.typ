// The bibliography list item publications map onto, and the line
// builders for its author and identifier records.

#import "../design/styles.typ": _treat
#import "../context.typ": _theme-state
#import "../util/values.typ": _join-present
#import "../primitives.typ": (
  _join-facts, _link-if, _meta, _preamble, styled-link,
)

// `(name, owner)` records, the owner set apart (`treatment.owner`,
// bold by default: the academic-CV convention); `none` when there are
// none. `theme` is the one the caller read in context.
#let _author-line(theme, authors) = (
  authors
    .map(a => if a.owner { _treat(theme.treatment.owner, a.name) } else {
      a.name
    })
    .join(theme.separator.items)
)

// `(name, id, url)` records as `name id`, the id linked when `url` is
// set; `none` when there are none.
#let _identifier-line(theme, refs) = (
  refs.map(r => [#r.name #_link-if(r.url, r.id)]).join(theme.separator.facts)
)

// One bibliography list item: the title (linked to `url`), then
// authors, the source with its date (`Personal Blog · Jun 2024`),
// identifiers and summary, each on its own line. Absent parts drop
// out so none leaves an orphan `\` break or separator.
#let _bib-entry(
  title,
  url: none,
  authors: (),
  source: none,
  date: none,
  identifiers: (),
  summary: none,
) = [
  - #context {
      let theme = _theme-state.get()
      let lines = _join-present(
        (
          _author-line(theme, authors),
          _join-facts(theme.separator, (source,), (_meta(date),)),
          _meta(_identifier-line(theme, identifiers)),
          _preamble(summary),
        ),
        [\ ],
      )
      [#styled-link(title, dest: url). #if lines != none [\ #lines]]
    }
]
