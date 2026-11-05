// The CV entry component every entry section maps its fields onto:
// the heading with its date at the right edge, then the organisation
// and the entry's other facts with its location at the right edge.

#import "../design/styles.typ": _part, _subheading-block
#import "../context.typ": _theme-state
#import "../util/values.typ": _present
#import "../primitives.typ": (
  _accent-text, _date-fact, _fact-line, _joined, _link-if, _location-fact,
  _preamble, _range,
)

// A small line under an entry's heading, a referee's attribution, from
// fact groups; nothing when none of their parts is present.
#let _subtitle(groups) = {
  let line = _fact-line(..groups)
  if line != none {
    context block(below: _theme-state.get().entry.subtitle-below, line)
  }
}

// An entry's first lines as one grid: the title (or, without one,
// the facts line) over the `facts` on the left; the date and the
// location on the right, each led by its icon and flush with the
// column's right edge. A long title wraps beside the date, unless the
// date or location would take more than `entry.side-max` of the
// column; then each takes a line of its own under its row. A row
// with nothing on the right spans the grid. The grid sits in the
// entry heading's block, so it keeps that spacing and stays with its
// entry; after a facts line, `entry.facts-below`.
#let _entry-head(title, facts, date, location, alts) = context {
  let body-size = text.size
  let theme = _theme-state.get()
  let (side-gap, side-max, facts-below, row-gap) = theme.entry
  let (lead, lead-size, under) = if title != none {
    (
      // Level 3, or 4 under a group (`components/frame.typ`).
      [#heading(depth: 3, title)<alta-internal-entry>],
      theme.type.title.size * body-size,
      facts,
    )
  } else { (facts, body-size, none) }
  // A line's height runs from its top edge (the cap height, or an
  // icon's top when taller) to its baseline. Every row sets its
  // baseline that far down from the taller of its text's capitals and
  // an icon, so both sides share it and rows space alike with or
  // without an icon on the right.
  let top(body) = measure(body).height
  let icon-top = top(_date-fact("X"))
  let drop(body, baseline) = block(
    inset: (top: baseline - top(body)),
    body,
  )
  let rows = (
    (
      lead,
      lead-size,
      _date-fact(_part("date", date), alt: alts.date),
    ),
    (
      under,
      body-size,
      _location-fact(_part("location", location), alt: alts.location),
    ),
  )
    .filter(((left, _, side)) => left != none or side != none)
    .map(((left, size, side)) => {
      let baseline = calc.max(top(text(size, "X")), icon-top)
      (
        left: drop(left, baseline),
        side: side,
        dropped: if side != none { drop(side, baseline) },
        width: if side != none {
          measure(side).width + side-gap.to-absolute()
        } else {
          0pt
        },
      )
    })
  if rows.len() == 0 { return }
  let below = if title == none or rows.len() > 1 { facts-below } else {
    theme.subheading.entry.below
  }
  _subheading-block(
    theme.subheading.entry + (below: below),
    body-size,
    layout(size => {
      // Stacked, each side takes its own line, undropped.
      let own-line = rows.any(row => row.width > side-max * size.width)
      let cells = rows.map(row => if row.side == none {
        (grid.cell(colspan: if own-line { 1 } else { 2 }, row.left),)
      } else {
        (row.left, align(right, if own-line { row.side } else { row.dropped }))
      })
      grid(
        columns: if own-line { 1fr } else { (1fr, auto) },
        column-gutter: side-gap,
        row-gutter: row-gap * body-size,
        ..cells.flatten(),
      )
    }),
  )
}

// An entry's closing lines, the keywords lead then the keywords, as
// paragraphs a line's leading apart. The keyword line is the
// `<alta-keywords>` part, so a show rule can set its paragraph.
#let _entry-keywords(lead, line) = context {
  set par(spacing: par.leading)
  if lead != none { par(lead) }
  if line != none { _part("keywords", par(line)) }
}

// One CV entry in a fixed slot order, so the entry sections lay
// their entries out alike (publications, a bibliography list, use
// `_bib-entry`); an absent slot renders nothing. The title keeps the
// plain heading style whether or not it links.
//
// The facts line under the title joins the organisation (in the
// accent), the person's `roles` and short `details` (a credential
// ID); the `period` and the `location` sit at the right edge beside
// the title and the facts line. Without a title, the facts line
// leads. The `keywords` (a project's stack, education's courses) end
// the entry as one line; `keywords-lead` is a line of its own above
// them (education's area and score), so it doesn't read as one of
// them.
//
// Every fact is data, which the entry joins with the theme's
// separators. Each slot's shape, `()` when absent:
// - `roles`, `details`, `keywords`: items, each a fact of its own.
// - `period`: a range's two sides (`_date-span`), joined by `range`.
// - `location`: one place's parts, joined by `items`.
// - `subtitle`, `keywords-lead`: fact groups, as `_fact-line` takes:
//   an array of arrays, `items` within a group and `facts` between.
//
// `alts`, required so no caller drops it from the tagged PDF, holds the
// date and location icons' alt text, read aloud before them, as
// `alts.date` and `alts.location`: a section passes its labels.
#let _entry(
  alts,
  title: none,
  url: none,
  org: none,
  org-url: none,
  subtitle: (),
  roles: (),
  period: (),
  location: (),
  details: (),
  summary: none,
  highlights: (),
  keywords-lead: (),
  keywords: (),
) = {
  let org = if _present(org) {
    _accent-text(_link-if(org-url, _part("org", org)))
  }
  let facts = _part("facts", _fact-line((org,), roles, details))
  _entry-head(
    if _present(title) { _link-if(url, title) },
    facts,
    _range(period),
    _fact-line(location),
    alts,
  )
  _subtitle(subtitle)
  _preamble(summary)
  for bullet in highlights [- #bullet]
  _entry-keywords(
    _fact-line(..keywords-lead),
    // Filtered first: a labelled `""` counts as present.
    _joined("keywords", keywords.filter(_present).map(_part.with("keyword"))),
  )
}
