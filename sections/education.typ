// Education entries — qualification heading, accent-coloured
// institution (optionally linked), date range and location, italic
// summary, score, and pill-tagged courses. Falls back to `area` when
// `studyType` is missing.

#import "../internal/text.typ": _entry_summary, _present
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
    #_preamble(_entry_summary(edu))

    #let score = edu.at("score", default: none)
    #if _present(score) [#score]
    // Courses render as pill tags — same treatment as `skills[].keywords`
    // and `projects[].keywords`, which are the other array-of-strings
    // surfaces in the template. Empty arrays skip silently.
    #let courses = edu.at("courses", default: ())
    #if courses.len() > 0 [
      #for course in courses [#tag(course)]
    ]
  ],
)
