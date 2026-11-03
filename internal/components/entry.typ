// The CV entry component every entry section maps its fields onto,
// with the date and location row beneath its heading.

#import "../design/theme.typ": _theme
#import "../util/values.typ": _join-present, _present
#import "../primitives.typ": (
  _accent-text, _link-if, _preamble, _tag-row, _term-part, _term-row, name,
  term,
)

// A small line under an entry's heading: a project's client, a
// referee's attribution. Absent bodies render nothing.
#let _subtitle(body) = if _present(body) {
  block(below: _theme.entry.subtitle-below, body)
}

// An organisation line via `name()`, linked when `url` is present
// (`link()` inherits the bold accent). An absent organisation renders
// nothing rather than an empty block that leaves a blank line.
#let _org-line(org, url: none) = if _present(org) {
  name(_link-if(url, org))
}

// The compact term row: period and location at natural widths (no
// column to align), then the organisation and `details` joined by
// ` · `, so several short entries stay one line each. The
// `entry.compact-gap` gaps are `em` of the row's text.
#let _compact-term(period, location, org, org-url, details) = {
  let org = if _present(org) {
    _accent-text(_link-if(org-url, org))
  }
  let facts = _join-present((org, ..details), _theme.separator.facts)
  let row = _join-present(
    (
      _term-part("calendar", period, width: auto),
      _term-part("location", location, width: auto),
      if facts != none { box(facts) },
    ),
    h(_theme.entry.compact-gap),
  )
  if row != none { _term-row(row) }
}

// One CV entry in a fixed slot order, so the entry sections lay
// their entries out alike (publications, a bibliography list, use
// `_bib-entry`); an absent slot renders nothing. The title keeps the
// plain heading style whether or not it links. `tags-lead` is a
// line of its own above the `tags` pills (education's score), so it
// doesn't read as one of them.
//
// `compact: true` folds the organisation and `details` (short facts
// such as a credential ID) onto the date row instead of giving the
// organisation a line of its own.
#let _entry(
  title: none,
  url: none,
  org: none,
  org-url: none,
  subtitle: none,
  roles: (),
  period: none,
  location: none,
  compact: false,
  details: (),
  summary: none,
  highlights: (),
  tags-lead: none,
  tags: (),
) = {
  if _present(title) [=== #_link-if(url, title)]
  if not compact { _org-line(org, url: org-url) }
  _subtitle(subtitle)
  // The person's roles as darker pills, set apart from the `tags`.
  if roles.len() > 0 {
    block(below: _theme.entry.roles-below, _tag-row(roles, label: true))
  }
  if compact {
    _compact-term(period, location, org, org-url, details)
  } else {
    term(period, location: location)
  }
  _preamble(summary)
  for bullet in highlights [- #bullet]
  _join-present((tags-lead, _tag-row(tags)), [\ ])
}
