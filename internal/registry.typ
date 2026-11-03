// The renderer bound to each column section in `data/sections.typ`.
// A new section needs a spec there, a renderer under `sections/`
// registered here, and a heading in `data/labels-en.toml`.

#import "../sections/awards.typ": _awards
#import "../sections/certificates.typ": _certificates
#import "../sections/education.typ": _education
#import "../sections/experience.typ": _experience, _volunteer
#import "../sections/focus-areas.typ": _focus_areas
#import "../sections/languages.typ": _languages
#import "../sections/projects.typ": _projects
#import "../sections/publications.typ": _publications
#import "../sections/references.typ": _references
#import "../sections/skills.typ": _interests, _skills

// Renderers take `(entries, ctx)`, `ctx` being `(labels, prefs,
// owner)`. Must follow the renderer imports: Typst binds identifiers
// eagerly.
#let _renderers = (
  work: _experience,
  volunteer: _volunteer,
  focusAreas: _focus_areas,
  skills: _skills,
  languages: _languages,
  education: _education,
  certificates: _certificates,
  awards: _awards,
  projects: _projects,
  publications: _publications,
  interests: _interests,
  references: _references,
)
