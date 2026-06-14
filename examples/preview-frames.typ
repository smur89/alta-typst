// Source for `examples/preview.gif` — the animated README hero. One
// frame per accent palette (plus one extra showcasing the centred-
// above image position alongside the default teal). Each frame
// bundles several customisations at once (column arrangement, image
// position, header alignment, name casing, date format, footer …)
// so the visual difference between frames clearly signals "this
// template is configurable" rather than parading one knob at a time.
//
// The CV data is shared with `example.typ` via `_cv.typ` — every
// frame is the same fictional person, only preferences differ. Each
// frame's `leftColumnSections` + `rightColumnSections` selects a
// subset that fits on one page so the GIF cycles cleanly (the
// shared CV is deliberately larger than any single frame uses, so
// the static `example.pdf` can still showcase every section).
//
// `imageStackOrder: "below"` is deliberately excluded — the photo
// reads as an afterthought when stacked below the contact bar.

#import "../lib.typ": alta, palettes
#import "_cv.typ": cv

#let frames = (
  // ── Frame 1 ─ teal (default) ────────────────────────────────────
  // Anchor: default look, no overrides — the canonical baseline.
  // Trims the section selection so the GIF frame matches the README
  // preview (page 1 of example.pdf).
  (
    leftColumnSections: ("work", "publications"),
    rightColumnSections: (
      "focusAreas", "skills", "languages", "education", "certificates", "awards",
    ),
  ),

  // ── Frame 2 ─ teal + centred photo ──────────────────────────────
  // Same default palette as frame 1 but with the portrait stacked
  // above a centred header text block — pairs naturally with the
  // "default look" frame to show how the photo can be repositioned
  // without touching the rest of the layout.
  (
    imagePosition: "center",
    imageStackOrder: "above",
    headerTextAlign: "center",
    leftColumnSections: ("work", "publications"),
    rightColumnSections: (
      "focusAreas", "skills", "languages", "education", "certificates", "awards",
    ),
  ),

  // ── Frame 3 ─ navy ──────────────────────────────────────────────
  // Image swung to the left of the header; uppercase off so the
  // name reads in its natural case; sections reshuffled so the
  // compact ones (focusAreas / skills / languages) lead the left
  // column and work + projects sit on the wide right side.
  (
    accent: palettes.navy,
    imagePosition: "left",
    uppercaseName: false,
    columnRatio: 0.35,
    leftColumnSections: ("focusAreas", "skills", "languages", "education", "certificates"),
    rightColumnSections: ("work", "projects", "awards"),
  ),

  // ── Frame 4 ─ crimson ───────────────────────────────────────────
  // Single-column layout (`columnRatio: 1`) — every section stacks
  // top-to-bottom in one full-width column. Pairs with an ISO
  // date format and a small page footer so multiple knobs change
  // visibly in the same frame. Section list trimmed so the stacked
  // content fits on one page.
  (
    accent: palettes.crimson,
    columnRatio: 1,
    dateFormat: "iso",
    leftColumnSections: ("work",),
    rightColumnSections: ("skills", "languages", "education", "certificates"),
    pageFooter: align(right, text(0.8em, fill: rgb("#666666"), [Seán Ó Murchú — CV])),
  ),

  // ── Frame 5 ─ forest ────────────────────────────────────────────
  // Header text aligned right (mirrors the default left position);
  // certificates ungrouped (flat pill strip); CEFR-style 6-dot
  // language scale.
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

  // ── Frame 6 ─ plum ──────────────────────────────────────────────
  // Compact European-style short date format. Name cased naturally,
  // image on the left, sections rearranged so interests + volunteer
  // take the right column alongside the usual short blocks.
  (
    accent: palettes.plum,
    imagePosition: "left",
    uppercaseName: false,
    dateFormat: "[day]/[month]/[year]",
    leftColumnSections: ("work", "education"),
    rightColumnSections: (
      "focusAreas", "skills", "languages", "certificates", "volunteer", "interests",
    ),
  ),

  // ── Frame 7 ─ charcoal ──────────────────────────────────────────
  // Closure-formatted dates (quarterly labels "Q3 2024") and an
  // alternate layout where publications lead the left column and
  // projects sit in the right alongside the compact blocks.
  // Demonstrates the closure date API and an unusual section
  // ordering.
  (
    accent: palettes.charcoal,
    dateFormat: parts => {
      if parts.month == none { return str(parts.year) }
      let quarter = int((parts.month - 1) / 3) + 1
      "Q" + str(quarter) + " " + str(parts.year)
    },
    leftColumnSections: ("publications", "work", "awards"),
    rightColumnSections: ("focusAreas", "skills", "languages", "education", "certificates", "projects"),
  ),
)

#for (i, prefs) in frames.enumerate() {
  if i > 0 { pagebreak(weak: true) }
  alta(cv, preferences: prefs)
}
