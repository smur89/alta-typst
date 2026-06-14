// Section dispatch catalogue. Single source of truth for which CV
// sections exist, which column they default to, and how to render
// each. Adding an entry here places the section in the default
// layout — still need to write the renderer (under `sections/`) and
// add a `labels` key in `defaults.typ`.
//
// Defaults derived from this dict (`leftColumnSections` /
// `rightColumnSections` in `_default_preferences`) and validation
// (`alta()`'s unknown-key check) both consult `_sections`, so this
// dict is the single place that controls section availability.

#import "../sections/experience.typ": _experience, _volunteer
#import "../sections/focus-areas.typ": _focus_areas
#import "../sections/skills.typ": _skills, _interests
#import "../sections/languages.typ": _languages
#import "../sections/education.typ": _education
#import "../sections/certificates.typ": _certificates
#import "../sections/awards.typ": _awards
#import "../sections/projects.typ": _projects
#import "../sections/publications.typ": _publications

// Defined after the renderers because Typst binds closure identifiers
// eagerly.
#let _sections = (
  work: (
    column: "left",
    render: (cv, labels, prefs) => _experience(cv.at("work", default: ()), labels, prefs),
  ),
  volunteer: (
    column: "left",
    render: (cv, labels, prefs) => _volunteer(cv.at("volunteer", default: ()), labels, prefs),
  ),
  focusAreas: (
    column: "right",
    render: (cv, labels, prefs) => _focus_areas(cv.at("focusAreas", default: ()), labels),
  ),
  skills: (
    column: "right",
    render: (cv, labels, prefs) => _skills(cv.at("skills", default: ()), labels),
  ),
  languages: (
    column: "right",
    render: (cv, labels, prefs) => _languages(cv.at("languages", default: ()), labels),
  ),
  education: (
    column: "right",
    render: (cv, labels, prefs) => _education(cv.at("education", default: ()), labels, prefs),
  ),
  certificates: (
    column: "right",
    render: (cv, labels, prefs) => _certificates(
      cv.at("certificates", default: ()),
      labels,
      prefs,
      group: prefs.groupCertificates,
    ),
  ),
  awards: (
    column: "right",
    render: (cv, labels, prefs) => _awards(cv.at("awards", default: ()), labels, prefs),
  ),
  projects: (
    column: "left",
    render: (cv, labels, prefs) => _projects(cv.at("projects", default: ()), labels, prefs),
  ),
  publications: (
    column: "left",
    render: (cv, labels, prefs) => _publications(cv.at("publications", default: ()), labels, prefs),
  ),
  interests: (
    column: "right",
    render: (cv, labels, prefs) => _interests(cv.at("interests", default: ()), labels),
  ),
)
