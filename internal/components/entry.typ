// The CV entry component every entry section maps its fields onto,
// with the date and location row beneath its heading.

#import "../theme.typ": _theme
#import "../text.typ": _join_present, _link_if, _present
#import "../dates.typ": _format_date_range
#import "../location.typ": _format_location
#import "../primitives.typ": (
  _accent_strong, _preamble, _small, _tag_row, _term_part, _term_row, name,
  term,
)

// A small line under an entry's heading: a project's client, a
// referee's attribution. Absent bodies render nothing.
#let _subtitle(body) = if _present(body) {
  block(below: _theme.entry.subtitle-below, _small(body))
}

// An organisation line via `name()`, linked when `url` is present
// (`link()` inherits the bold accent). An absent organisation renders
// nothing rather than an empty block that leaves a blank line.
#let _org_line(org, url: none) = if _present(org) {
  name(_link_if(url, org))
}

// A dated, located entry's `period` and `location`, for spreading into
// `_entry`. `key` names the section in panic messages
// ("education[].location").
#let _entry_when(entry, key, prefs, labels) = (
  period: _format_date_range(entry, prefs, labels),
  location: _format_location(
    entry.at("location", default: none),
    key + "[].location",
  ),
)

// The compact term row: period and location at natural widths (no
// column to align), then the organisation and `details` joined by
// ` · `, so several short entries stay one line each. The
// `entry.compact-gap` gaps are `em`, so scale with the row's smaller
// text.
#let _compact_term(period, location, org, org-url, details) = {
  let org = if _present(org) {
    _accent_strong(_link_if(org-url, org))
  }
  let facts = _join_present((org, ..details), _theme.separator.facts)
  let row = _join_present(
    (
      _term_part("calendar", period, width: auto),
      _term_part("location", location, width: auto),
      if facts != none { box(facts) },
    ),
    h(_theme.entry.compact-gap),
  )
  if row != none { _term_row(row) }
}

// One CV entry in a fixed slot order, so the entry sections lay
// their entries out alike (publications, a bibliography list, use
// `_bib_entry`); an absent slot renders nothing. The title keeps the
// plain heading style whether or not it links. `tags-lead` is
// inline text leading the `tags` pills (education's score).
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
  if _present(title) [=== #_link_if(url, title)]
  if not compact { _org_line(org, url: org-url) }
  _subtitle(subtitle)
  // The person's roles as darker pills, set apart from the `tags`.
  if roles.len() > 0 {
    block(below: _theme.entry.roles-below, _tag_row(roles, label: true))
  }
  if compact {
    _compact_term(period, location, org, org-url, details)
  } else {
    term(period, location: location)
  }
  _preamble(summary)
  for bullet in highlights [- #bullet]
  _join_present((tags-lead, _tag_row(tags)), [ ])
}
