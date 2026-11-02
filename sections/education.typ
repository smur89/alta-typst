// Education. The heading falls back to `area` when `studyType` is
// absent; `courses` render as pills like other string arrays.

#import "../internal/text.typ": _field, _present
#import "../internal/primitives.typ": (
  _entry_term, _org_line, _preamble, _section, tag,
)

#let _education(entries, (labels, prefs, ..)) = _section(
  labels.education,
  entries,
  edu => [
    // An empty `studyType` falls through to `area`, as a missing one does.
    #let title = (
      edu.at("studyType", default: none),
      edu.at("area", default: none),
    ).find(_present)
    #if title != none [=== #title]
    #_org_line(
      edu.at("institution", default: none),
      url: edu.at("url", default: none),
    )
    #_entry_term(edu, "education", prefs, labels)

    // Own paragraph, so the score below starts on a new line.
    #_preamble(_field(edu, "summary"))

    #let score = edu.at("score", default: none)
    #if _present(score) [#score]
    #let courses = edu.at("courses", default: ())
    #if courses.len() > 0 [
      #for course in courses [#tag(course)]
    ]
  ],
)
