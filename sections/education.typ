// Education. The heading falls back to `area` when `studyType` is
// absent; `courses` render as pills like other string arrays, inline
// after the score.

#import "../internal/util/fields.typ": _field
#import "../internal/data/cv.typ": _entry-period, _format-location
#import "../internal/components/entry.typ": _entry
#import "../internal/components/frame.typ": _section

#let _education(entries, (labels, format-date, ..)) = _section(
  labels.education,
  entries,
  edu => _entry(
    // An empty `studyType` falls through to `area`, as a missing one does.
    title: (_field(edu, "studyType"), _field(edu, "area")).find(t => t != none),
    org: _field(edu, "institution"),
    org-url: _field(edu, "url"),
    period: _entry-period(edu, format-date, labels.present),
    location: _format-location(edu.at("location", default: none)),
    summary: _field(edu, "summary"),
    tags-lead: _field(edu, "score"),
    tags: edu.at("courses", default: ()),
  ),
)
