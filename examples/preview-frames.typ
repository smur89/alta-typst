// Source for `examples/preview.gif` — the animated README hero.
// Seven frames, one per accent palette plus an extra teal frame
// showcasing the centred-portrait header. Each frame bundles
// several customisations at once (column arrangement, image
// position, header alignment, name casing, date format, footer …)
// so the visual difference between frames clearly signals "this
// template is configurable" rather than parading one knob at a time.
//
// Image presence alternates frame-to-frame: odd frames render
// without a portrait (the realistic default for ATS-compatible /
// bias-resistant CVs), even frames render with one in a different
// position (centred above, left, right). The alternation reinforces
// that the portrait is optional and reads as ONE more knob among
// many — not the visual anchor.
//
// The CV data is shared with `example.typ` via `_cv.typ`. Each
// frame's `leftColumnSections` + `rightColumnSections` selects a
// subset that fits on one page so the GIF cycles cleanly.
//
// `imageStackOrder: "below"` is deliberately excluded — the photo
// reads as an afterthought when stacked below the contact bar.

#import "../lib.typ": alta, palettes
#import "_cv.typ": cv, no-image

// Each entry is `(cv-to-render, preferences-dict)`. Frames using
// `no-image(cv)` drop the portrait; frames using `cv` keep it.
#let frames = (
  // ── Frame 1 ─ teal / no image ───────────────────────────────────
  // Default palette, image-less header — the realistic baseline
  // most users ship (no photo for ATS / anti-bias reasons).
  (
    no-image(cv),
    (
      leftColumnSections: ("work", "publications"),
      rightColumnSections: (
        "focusAreas", "skills", "languages", "education", "certificates", "awards",
      ),
    ),
  ),

  // ── Frame 2 ─ teal / portrait centred above ─────────────────────
  // Same palette as frame 1 — the portrait appears, stacked above
  // a centred header text block. Pairs with frame 1 as "default
  // style with / without the optional photo".
  (
    cv,
    (
      imagePosition: "center",
      imageStackOrder: "above",
      headerTextAlign: "center",
      leftColumnSections: ("work", "publications"),
      rightColumnSections: (
        "focusAreas", "skills", "languages", "education", "certificates", "awards",
      ),
    ),
  ),

  // ── Frame 3 ─ navy / no image + inverted columns ────────────────
  // Narrow side-panel layout (`columnRatio: 0.35`). Compact
  // sections lead the narrow left column; work + projects + awards
  // sit on the wide right side. Name cased naturally.
  (
    no-image(cv),
    (
      accent: palettes.navy,
      uppercaseName: false,
      columnRatio: 0.35,
      leftColumnSections: ("focusAreas", "skills", "languages", "education", "certificates"),
      rightColumnSections: ("work", "projects", "awards"),
    ),
  ),

  // ── Frame 4 ─ crimson / portrait left ───────────────────────────
  // Image on the left of the header (the mirror of the default
  // right position); sections rearranged so volunteer + interests
  // sit alongside the usual compact blocks on the right.
  (
    cv,
    (
      accent: palettes.crimson,
      imagePosition: "left",
      leftColumnSections: ("work", "education"),
      rightColumnSections: (
        "focusAreas", "skills", "languages", "certificates", "volunteer", "interests",
      ),
    ),
  ),

  // ── Frame 5 ─ forest / no image + right-aligned ─────────────────
  // Image-less header text aligned right; certificates ungrouped
  // (flat pill strip); CEFR-style 6-dot language scale.
  (
    no-image(cv),
    (
      accent: palettes.forest,
      headerTextAlign: "right",
      groupCertificates: false,
      maxRating: 6,
      leftColumnSections: ("work", "publications"),
      rightColumnSections: (
        "focusAreas", "skills", "languages", "education", "certificates",
      ),
    ),
  ),

  // ── Frame 6 ─ plum / portrait right + short dates ───────────────
  // Image on the right (the canonical default position); compact
  // European-style `[day]/[month]/[year]` date format.
  (
    cv,
    (
      accent: palettes.plum,
      dateFormat: "[day]/[month]/[year]",
      leftColumnSections: ("work", "publications"),
      rightColumnSections: (
        "focusAreas", "skills", "languages", "education", "certificates", "awards",
      ),
    ),
  ),

  // ── Frame 7 ─ charcoal / no image + single column ───────────────
  // Single-column layout (`columnRatio: 1`) stacks every section
  // top-to-bottom in one full-width column — pairs naturally with
  // the image-less header. Closure-formatted dates ("Q3 2024"-style
  // quarterly labels) and a custom page footer round out the frame.
  (
    no-image(cv),
    (
      accent: palettes.charcoal,
      columnRatio: 1,
      dateFormat: parts => {
        if parts.month == none { return str(parts.year) }
        let quarter = int((parts.month - 1) / 3) + 1
        "Q" + str(quarter) + " " + str(parts.year)
      },
      leftColumnSections: ("work",),
      rightColumnSections: ("skills", "languages", "education", "certificates"),
      pageFooter: align(right, text(0.8em, fill: rgb("#666666"), [Shane Murphy — CV])),
    ),
  ),
)

#for (i, (frame-cv, prefs)) in frames.enumerate() {
  if i > 0 { pagebreak(weak: true) }
  alta(frame-cv, preferences: prefs)
}
