// Source for `examples/preview.gif` — the animated README hero.
// Seven frames, each layering a small override on top of
// `example.typ`'s preferences baseline so the GIF reads as
// "example.typ with one or two knobs turned" rather than "seven
// independent configurations". Frame 1 is literally example.typ
// minus the portrait; subsequent frames vary accent, image
// position, column ratio, date format, and so on.
//
// Image presence alternates frame-to-frame: odd frames render
// without a portrait (realistic for ATS / anti-bias CVs), even
// frames render with one in a different position (centred above,
// left, right). The alternation reinforces that the portrait is
// optional — one more knob among many, not the visual anchor.
//
// Each frame's `leftColumnSections` + `rightColumnSections` is
// either inherited from `example.typ`'s preferences (full section
// list) or trimmed where needed to keep that specific frame on a
// single page. Single-column (`columnRatio: 1`) is the only frame
// that requires a substantial trim.
//
// `imageStackOrder: "below"` is deliberately excluded — the photo
// reads as an afterthought when stacked below the contact bar.

#import "../lib.typ": alta, palettes
#import "_cv.typ": cv, no-image
#import "example.typ": preferences as base

// Section selection used by every two-column frame — trims
// `volunteer` from example.typ's left column (the heaviest
// secondary section the rich CV carries) so each frame fits on
// one page. Frames that re-arrange columns more aggressively
// (inverted layout, single column) override this with their own
// section lists inline.
#let trimmed-sections = (
  leftColumnSections: ("work", "projects", "publications", "interests"),
  rightColumnSections: (
    "focusAreas", "skills", "languages", "education", "certificates", "awards",
  ),
)

// Each entry is `(cv-to-render, preferences-dict)`. Frames using
// `no-image(cv)` drop the portrait; frames using `cv` keep it.
// Dict spread (`base + (key: value)`) is Typst's equivalent of
// Scala's `base.copy(key = value)`, so each frame reads as a small
// patch over the baseline.
#let frames = (
  // ── Frame 1 ─ example.typ, no image ─────────────────────────────
  // Identical to example.typ's output minus the portrait — the
  // realistic baseline most users ship (ATS-friendly, anti-bias).
  (no-image(cv), base + trimmed-sections),

  // ── Frame 2 ─ example.typ + portrait centred above ──────────────
  // Same configuration as frame 1, the portrait reappears stacked
  // above a centred header text block.
  (cv, base + trimmed-sections + (
    imagePosition: "center",
    imageStackOrder: "above",
    headerTextAlign: "center",
  )),

  // ── Frame 3 ─ teal + no image + inverted columns ────────────────
  // Different accent (teal — the lib default), narrow side-panel
  // layout (`columnRatio: 0.35`); the compact sections lead the
  // (now narrow) left column and work + projects sit on the wide
  // right side. Name cased naturally. Volunteer is dropped (same
  // reason as the trimmed-sections baseline — heaviest secondary).
  (no-image(cv), base + (
    accent: palettes.teal,
    uppercaseName: false,
    columnRatio: 0.35,
    leftColumnSections: ("focusAreas", "skills", "languages", "education", "certificates", "interests"),
    rightColumnSections: ("work", "projects", "publications", "awards"),
  )),

  // ── Frame 4 ─ crimson + portrait left ───────────────────────────
  // Image on the left of the header (the mirror of the default
  // right position).
  (cv, base + trimmed-sections + (
    accent: palettes.crimson,
    imagePosition: "left",
  )),

  // ── Frame 5 ─ forest + no image + right-aligned ─────────────────
  // Header text aligned right; certificates ungrouped (flat pill
  // strip — distinct from the default grouped issuer rows).
  (no-image(cv), base + trimmed-sections + (
    accent: palettes.forest,
    headerTextAlign: "right",
    groupCertificates: false,
  )),

  // ── Frame 6 ─ plum + portrait right + short dates ───────────────
  // Image on the right (canonical default); compact European-style
  // `[day]/[month]/[year]` date format.
  (cv, base + trimmed-sections + (
    accent: palettes.plum,
    dateFormat: "[day]/[month]/[year]",
  )),

  // ── Frame 7 ─ charcoal + no image + single column ───────────────
  // Single-column layout (`columnRatio: 1`) stacks every section
  // vertically — the only frame that needs an aggressive section
  // trim to fit one page. Closure-formatted dates ("Q3 2024"-style
  // quarterly labels) round out the frame.
  (no-image(cv), base + (
    accent: palettes.charcoal,
    columnRatio: 1,
    dateFormat: parts => {
      if parts.month == none { return str(parts.year) }
      let quarter = int((parts.month - 1) / 3) + 1
      "Q" + str(quarter) + " " + str(parts.year)
    },
    leftColumnSections: ("work",),
    rightColumnSections: ("skills", "languages", "education", "certificates"),
  )),
)

#for (i, (frame-cv, prefs)) in frames.enumerate() {
  if i > 0 { pagebreak(weak: true) }
  alta(frame-cv, preferences: prefs)
}
