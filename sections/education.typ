// Education. The heading falls back to `area` when `studyType` is
// absent; `courses` render as pills like other string arrays, inline
// after the score.

#import "../internal/util/dates.typ": _format_date_range
#import "../internal/util/fields.typ": _field
#import "../internal/util/location.typ": _format_location
#import "../internal/components/entry.typ": _entry
#import "../internal/components/frame.typ": _section

#let _education(entries, (labels, prefs, ..)) = _section(
  labels.education,
  entries,
  edu => _entry(
    // An empty `studyType` falls through to `area`, as a missing one does.
    title: (_field(edu, "studyType"), _field(edu, "area")).find(t => t != none),
    org: _field(edu, "institution"),
    org-url: _field(edu, "url"),
    period: _format_date_range(edu, prefs, labels),
    location: _format_location(
      edu.at("location", default: none),
      "education" + "[].location",
    ),
    summary: _field(edu, "summary"),
    tags-lead: _field(edu, "score"),
    tags: edu.at("courses", default: ()),
  ),
)
