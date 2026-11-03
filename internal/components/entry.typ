// The CV entry component every entry section maps its fields onto:
// the heading with its date at the right edge, then the organisation
// and the entry's other facts on one line.

#import "../design/theme.typ": _theme
#import "../context.typ": _body-size-state
#import "../util/values.typ": _join-present, _present
#import "../primitives.typ": _accent-text, _fact-line, _link-if, _preamble

// A small line under an entry's heading: a referee's attribution.
// Absent bodies render nothing.
#let _subtitle(body) = if _present(body) {
  block(below: _theme.entry.subtitle-below, body)
}

// `lead` with `date` at the right edge, on the lead's first baseline:
// `lead-size` (of the body size) is the lead's text size, and the date
// drops by the difference in cap height. A long lead wraps beside the
// date, unless the date would take more than `entry.date-max` of the
// column; then it takes a line of its own, still at the right edge.
// `sticky`, as a heading alone is, so the row stays with its entry.
#let _title-row(lead, lead-size, date) = context {
  let body-size = _body-size-state.get()
  let (date-gap, date-max) = _theme.entry
  let (above, below) = _theme.subheading.entry
  let cap-height(size) = measure(text(size, "X")).height
  let date = block(
    inset: (top: cap-height(lead-size * body-size) - cap-height(body-size)),
    date,
  )
  block(
    above: above * body-size,
    below: below * body-size,
    sticky: true,
    layout(size => {
      if measure(date).width + date-gap.to-absolute() > date-max * size.width {
        grid(columns: 1fr, lead, align(right, date))
      } else {
        grid(
          columns: (1fr, auto),
          column-gutter: date-gap,
          lead, date,
        )
      }
    }),
  )
}

// One CV entry in a fixed slot order, so the entry sections lay
// their entries out alike (publications, a bibliography list, use
// `_bib-entry`); an absent slot renders nothing. The title keeps the
// plain heading style whether or not it links.
//
// The facts line under the title joins the organisation (in the
// accent), the person's `roles`, the `location` and short `details`
// (a credential ID) with ` · `. Without a title, it leads instead.
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
  let facts = _fact-line((org,), roles, (location,), details)
  let facts = if facts != none {
    block(below: _theme.entry.facts-below, facts)
  }
  let (lead, lead-size, facts) = if _present(title) {
    ([=== #_link-if(url, title)], _theme.type.title.size, facts)
  } else { (facts, 1, none) }
  if _present(period) { _title-row(lead, lead-size, period) } else { lead }
  facts
  _subtitle(subtitle)
  _preamble(summary)
  for bullet in highlights [- #bullet]
  _join-present(
    (keywords-lead, _join-present(keywords, _theme.separator.facts)),
    [\ ],
  )
}
