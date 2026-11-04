// The bibliography list item publications map onto, and the line
// builders for its author and identifier records.

#import "../design/styles.typ": _treat
#import "../context.typ": _theme-state
#import "../util/values.typ": _join-present
#import "../primitives.typ": _fact-line, _link-if, _meta, _preamble, styled-link

// `(name, owner)` records, the owner set apart (`treatment.owner`,
// bold by default: the academic-CV convention), with `theme`'s
// separator; `none` when there are none.
#let _author-names(theme, authors) = (
  authors
    .map(a => if a.owner { _treat(theme.treatment.owner, a.name) } else {
      a.name
    })
    .join(theme.separator.items)
)

// `_author-names` with the theme's; `none` decided outside context, as
// `_fact-line` does.
#let _author-line(authors) = if authors.len() > 0 {
  context _author-names(_theme-state.get(), authors)
}

// `(name, id, url)` records as `_fact-line` groups, one per record:
// `name id`, the id linked when `url` is set.
#let _identifier-groups(refs) = refs.map(r => (
  [#r.name #_link-if(r.url, r.id)],
))

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
) = {
  let lines = _join-present(
    (
      _author-line(authors),
      _fact-line((source,), (_meta(date),)),
      _meta(_fact-line(.._identifier-groups(identifiers))),
      _preamble(summary),
    ),
    [\ ],
  )
  [- #styled-link(title, dest: url). #if lines != none [\ #lines]]
}
