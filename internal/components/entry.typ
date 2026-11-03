// The CV entry component every entry section maps its fields onto:
// the heading with its date at the right edge, then the organisation
// and the entry's other facts with its location at the right edge.

#import "../design/styles.typ": _subheading-block
#import "../design/theme.typ": _theme
#import "../context.typ": _body-size-state
#import "../util/values.typ": _join-present, _present
#import "../primitives.typ": (
  _accent-text, _fact-line, _icon-fact, _link-if, _preamble,
)

// A small line under an entry's heading: a referee's attribution.
// Absent bodies render nothing.
#let _subtitle(body) = if _present(body) {
  block(below: _theme.entry.subtitle-below, body)
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
#let _entry-head(title, facts, date, location) = context {
  let body-size = _body-size-state.get()
  let (side-gap, side-max, facts-below, row-gap) = _theme.entry
  let (lead, lead-size, under) = if title != none {
    ([=== #title], _theme.type.title.size * body-size, facts)
  } else { (facts, body-size, none) }
  // A line's height runs from its top edge (the cap height, or an
  // icon's top when taller) to its baseline. Every row sets its
  // baseline that far down from the taller of its text's capitals and
  // an icon, so both sides share it and rows space alike with or
  // without an icon on the right.
  let top(body) = measure(body).height
  let icon-top = top(_icon-fact("calendar", "X"))
  let drop(body, baseline) = block(
    inset: (top: baseline - top(body)),
    body,
  )
  let rows = (
    (lead, lead-size, _icon-fact("calendar", date)),
    (under, body-size, _icon-fact("location", location)),
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
    _theme.subheading.entry.below
  }
  _subheading-block(
    _theme.subheading.entry + (below: below),
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

// One CV entry in a fixed slot order, so the entry sections lay
// their entries out alike (publications, a bibliography list, use
// `_bib-entry`); an absent slot renders nothing. The title keeps the
// plain heading style whether or not it links.
//
// The facts line under the title joins the organisation (in the
// accent), the person's `roles` and short `details` (a credential ID)
// with ` · `; the date and `location` sit at the right edge beside
// the title and the facts line. Without a title, the facts line
// leads.
//
// The `keywords` (a project's stack, education's courses) end the
// entry as one line joined with ` · `; `keywords-lead` is a line of
// its own above them (education's score), so it doesn't read as one
// of them.
#let _entry(
  title: none,
  url: none,
  org: none,
  org-url: none,
  subtitle: none,
  roles: (),
  period: none,
  location: none,
  details: (),
  summary: none,
  highlights: (),
  keywords-lead: none,
  keywords: (),
) = {
  let org = if _present(org) { _accent-text(_link-if(org-url, org)) }
  _entry-head(
    if _present(title) { _link-if(url, title) },
    _fact-line((org,), roles, details),
    period,
    location,
  )
  _subtitle(subtitle)
  _preamble(summary)
  for bullet in highlights [- #bullet]
  _join-present(
    (
      keywords-lead,
      _join-present(keywords, _theme.separator.facts),
    ),
    [\ ],
  )
}
