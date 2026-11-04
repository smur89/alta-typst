// Education. The heading is `studyType`, or `area` when that's
// absent; otherwise `area` leads the score line (`Engineering ·
// Distinction`). `courses` end the entry as one line, under it.

#import "../internal/util/fields.typ": _field
#import "../internal/data/cv.typ": _entry-period, _location-parts
#import "../internal/primitives.typ": _fact-line
#import "../internal/components/entry.typ": _entry
#import "../internal/components/frame.typ": _section

#let _education(entries, (labels, format-date, ..)) = _section(
  labels.education,
  entries,
  edu => {
    // An empty `studyType` falls through to `area`, as a missing one does.
    let study-type = _field(edu, "studyType")
    let area = _field(edu, "area")
    _entry(
      title: if study-type != none { study-type } else { area },
      org: _field(edu, "institution"),
      org-url: _field(edu, "url"),
      period: _entry-period(edu, format-date, labels.present),
      location: _location-parts(edu),
      summary: _field(edu, "summary"),
      keywords-lead: _fact-line(
        (if study-type != none { area },),
        (_field(edu, "score"),),
      ),
      keywords: edu.at("courses", default: ()),
    )
  },
)
