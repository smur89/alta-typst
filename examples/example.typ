// Reference rendering of the altacv template. Renders the full
// fictional CV from `_cv.typ` with a representative preferences
// override — the artifact that ships as the static README preview
// (`preview.png`) and is what readers compile to see what the
// template produces.
//
// `preferences` is also exported as a module-level binding so
// `preview-frames.typ` can re-use the same baseline for every
// animated-GIF frame, layering frame-specific overrides on top
// without duplicating the configuration.
//
// What this renders:
//   • Header: name (uppercase by default), label, summary, contact
//     bar covering every channel — email, phone, structured
//     `basics.location`, `basics.url`, and every built-in profile
//     network. Portrait on the right.
//   • `meta` populates the PDF metadata date / keywords / description.
//   • Work, volunteer, projects, publications, focus areas, skills,
//     languages, education, certificates (multi-issuer grouped),
//     awards, interests — every section the template supports.
//   • Preferences override exercises a meaningful slice of the API
//     surface — accent palette swap, custom date format, custom
//     maps provider, auto page footer (multi-page only), and a
//     non-default `maxRating: 6` for the language scale.

#import "../lib.typ": alta, palettes, maps-providers
#import "_cv.typ": cv

#let preferences = (
  accent: palettes.navy,
  dateFormat: "[day padding:none] [month repr:short] [year]",
  mapsProvider: maps-providers.osm,
  pageFooter: "auto",
  maxRating: 6,
  leftColumnSections: ("work", "volunteer", "projects", "publications", "interests"),
  rightColumnSections: (
    "focusAreas", "skills", "languages", "education", "certificates", "awards",
  ),
)

#alta(cv, preferences: preferences)
