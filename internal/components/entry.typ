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
// date or location would take more than `entry.date-max` of the
// column; then each takes a line of its own under its row. A row
// with nothing on the right spans the grid. The grid sits in the
// entry heading's block, so it keeps that spacing and stays with its
// entry; after a facts line, `entry.facts-below`.
#let _entry-head(title, facts, date, location) = context {
  let body-size = _body-size-state.get()
  let (date-gap, date-max, facts-below, row-gap) = _theme.entry
  let (above, below) = _theme.subheading.entry
  let title-size = _theme.type.title.size * body-size
  let (lead, lead-size, facts) = if title != none {
    ([=== #title], title-size, facts)
  } else { (facts, body-size, none) }
  let rows = (
    (lead, lead-size, _icon-fact("calendar", date)),
    (facts, body-size, _icon-fact("location", location)),
  ).filter(((left, _, side)) => left != none or side != none)
  if rows.len() == 0 { return }
  let below = if title == none or rows.len() > 1 { facts-below } else {
    below
  }
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
  // Stacked (`own-line`), each side takes its own line.
  let cells(own-line) = rows
    .map(((left, size, side)) => {
      let baseline = calc.max(top(text(size, "X")), icon-top)
      let left = drop(left, baseline)
      if side == none {
        (if own-line { left } else { grid.cell(colspan: 2, left) },)
      } else {
        (
          left,
          align(right, drop(side, if own-line { top(side) } else { baseline })),
        )
      }
    })
    .flatten()
  let wide(side, width) = (
    side != none
      and measure(side).width + date-gap.to-absolute() > date-max * width
  )
  _subheading-block((above: above, below: below), body-size, layout(size => {
    let own-line = rows.any(((_, _, side)) => wide(side, size.width))
    grid(
      columns: if own-line { 1fr } else { (1fr, auto) },
      column-gutter: date-gap,
      row-gutter: row-gap * body-size,
      ..cells(own-line),
    )
  }))
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
    _fact-line((org,), roles.filter(_present), details),
    period,
    location,
  )
  _subtitle(subtitle)
  _preamble(summary)
  for bullet in highlights [- #bullet]
  _join-present(
    (
      keywords-lead,
      _join-present(keywords.filter(_present), _theme.separator.facts),
    ),
    [\ ],
  )
}
