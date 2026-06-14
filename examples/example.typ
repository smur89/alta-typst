// Demonstration of the altacv template. Renders a fictional CV
// covering the sections users hit most often, with the high-signal
// surfaces (work, skills, languages, education, certificates, awards,
// publications) shaped to fit on page 1 — that page is the README
// preview image. Lower-priority sections (projects, volunteer,
// interests) sit on page 2 so they're still exercised by the build
// but don't crowd the preview.
//
// The CV data is shared with `preview-frames.typ` via `_cv.typ` so
// the animated GIF and the static PNG render the same fictional
// person across every frame.
//
// Build locally with:
//   typst compile --root .. example.typ example.pdf

#import "../lib.typ": alta
#import "_cv.typ": cv

#alta(cv)
