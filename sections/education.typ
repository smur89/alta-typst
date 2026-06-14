// Education entries — qualification heading, accent-coloured
// institution (optionally linked), date range, score, and pill-tagged
// courses. Falls back to `area` when `studyType` is missing.

#import "../internal/text.typ": _present
#import "../internal/primitives.typ": name, term, tag, _join_with_dividers
#import "../internal/dates.typ": _format_date_range

#let _education(entries, labels, prefs) = if entries.len() > 0 [
  == #labels.education

  #_join_with_dividers(entries, edu => [
    #block(breakable: false)[
      #let title = edu.at("studyType", default: edu.at("area", default: ""))
      #if title != "" [=== #title]
      #let institution = edu.at("institution", default: "")
      #let url = edu.at("url", default: none)
      #let body = name[#institution]
      // `link()` wraps the `name()` block as-is, so the accent-bold
      // treatment is preserved — the only visible change is that the
      // institution becomes clickable. An empty-string url is treated
      // as absent so a missing JSON field doesn't render a dead link.
      #if _present(url) and institution != "" { link(url, body) } else { body }
      #term(_format_date_range(edu, prefs, labels))

      #if "score" in edu and edu.score != none [#edu.score]
      // Courses render as pill tags — same treatment as `skills[].keywords`
      // and `projects[].keywords`, which are the other array-of-strings
      // surfaces in the template. Empty arrays skip silently.
      #let courses = edu.at("courses", default: ())
      #if courses.len() > 0 [
        #for course in courses [#tag(course)]
      ]
    ]
  ])
]
