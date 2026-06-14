// Source for `examples/preview.gif` — the animated README hero.
// Seven frames, each layering a small override on top of the
// shared `base` preferences below so the GIF reads as "the
// template with one or two knobs turned" rather than seven
// independent configurations.
//
// Frame 1 is the baseline minus the portrait. Frames 2-7 each
// re-arrange the section columns (moving work to the right,
// pulling volunteer or interests in, dropping one section in
// favour of another) on top of their accent / image / date /
// label variations. The body layout shifts visibly frame-to-frame
// so the GIF reads as more than just a colour cycle.
//
// Image presence alternates frame-to-frame: odd frames render
// without a portrait (realistic for ATS / anti-bias CVs), even
// frames render with one in a different position (centred above,
// left, right). The alternation reinforces that the portrait is
// optional — one more knob among many, not the visual anchor.
//
// Accent palette also changes every frame — no two consecutive
// frames share an accent colour. The six built-in palettes plus
// one repeat give us seven distinct visual blocks.
//
// `imageStackOrder: "below"` is deliberately excluded — the photo
// reads as an afterthought when stacked below the contact bar.

#import "../lib.typ": alta, palettes, maps-providers
#import "_cv.typ": cv, no-image

// Irish-language label overrides used by one of the frames to
// demonstrate localisation. Loaded once at parse time — the same
// dict is passed to `alta(..., labels: ga-labels)`.
#let ga-labels = toml("labels-ga.toml")

// Baseline preferences the per-frame overrides patch on top of. A
// richer-than-defaults setup (navy palette, ISO short-date,
// OSM maps, auto footer, CEFR-style 6-dot rating) gives the GIF
// more visual surface to vary — frames flip palettes, swap columns,
// invert layouts on top of this same starting point.
#let base = (
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

// Each entry is `(cv-to-render, preferences-dict, labels-dict)`.
// Frames using `no-image(cv)` drop the portrait; frames using `cv`
// keep it. `(:)` for labels keeps the English defaults. Dict spread
// (`base + (key: value)`) is Typst's equivalent of Scala's
// `base.copy(key = value)`, so each frame reads as a small patch
// over the baseline.
#let frames = (
  // ── Frame 1 ─ navy + no image ───────────────────────────────────
  // Baseline arrangement: work-heavy left, support sections on the
  // right. The realistic baseline most users ship — portrait
  // omitted (ATS- / anti-bias-friendly), navy from `base`.
  (no-image(cv), base + (
    leftColumnSections: ("work", "projects", "publications", "interests"),
    rightColumnSections: (
      "focusAreas", "skills", "languages", "education", "certificates", "awards",
    ),
  ), (:)),

  // ── Frame 2 ─ charcoal + portrait centred above ─────────────────
  // Section arrangement matches frame 1, the portrait reappears
  // stacked above a centred header text block. Paired with frame 1
  // to isolate the photo-position change; charcoal accent contrasts
  // the navy baseline so the palette swap is also visible.
  (cv, base + (
    accent: palettes.charcoal,
    imagePosition: "center",
    imageStackOrder: "above",
    headerTextAlign: "center",
    leftColumnSections: ("work", "projects", "publications", "interests"),
    rightColumnSections: (
      "focusAreas", "skills", "languages", "education", "certificates", "awards",
    ),
  ), (:)),

  // ── Frame 3 ─ teal + no image + inverted columns ────────────────
  // Narrow side-panel layout (`columnRatio: 0.35`) — compact
  // sections lead the narrow left column; work + projects +
  // publications take the wide right side. Name cased naturally.
  (no-image(cv), base + (
    accent: palettes.teal,
    uppercaseName: false,
    columnRatio: 0.35,
    leftColumnSections: ("focusAreas", "skills", "languages", "education", "certificates", "interests"),
    rightColumnSections: ("work", "projects", "publications", "awards"),
  ), (:)),

  // ── Frame 4 ─ crimson + portrait left + Irish labels ────────────
  // Image swung to the left of the header; section columns swap
  // emphasis (compact / support blocks lead, work + projects move
  // right). Section headings render in Irish via `labels-ga.toml`
  // — the same data dict, just localised display strings.
  (cv, base + (
    accent: palettes.crimson,
    imagePosition: "left",
    leftColumnSections: ("focusAreas", "skills", "languages", "education", "certificates", "awards"),
    rightColumnSections: ("work", "projects"),
  ), ga-labels),

  // ── Frame 5 ─ forest + no image + right-aligned + volunteer up ──
  // Header text aligned right; certificates ungrouped (flat pill
  // strip). Volunteer + interests pulled up alongside work in the
  // left column. Drops publications + awards to fit on one page —
  // the volunteer arrangement is the distinctive shape here.
  (no-image(cv), base + (
    accent: palettes.forest,
    headerTextAlign: "right",
    groupCertificates: false,
    leftColumnSections: ("work", "volunteer", "interests"),
    rightColumnSections: (
      "focusAreas", "skills", "languages", "education", "certificates",
    ),
  ), (:)),

  // ── Frame 6 ─ plum + portrait right + short dates + education up ─
  // Image on the right (canonical default); compact European-style
  // `[day]/[month]/[year]` date format. Education + certificates
  // promoted to the left column alongside work; the right column
  // becomes a compact support panel.
  (cv, base + (
    accent: palettes.plum,
    dateFormat: "[day]/[month]/[year]",
    leftColumnSections: ("work", "education", "certificates"),
    rightColumnSections: (
      "focusAreas", "skills", "languages", "projects", "publications", "awards",
    ),
  ), (:)),

  // ── Frame 7 ─ teal + no image + single column ───────────────────
  // Single-column layout (`columnRatio: 1`) stacks every section
  // vertically — needs an aggressive section trim to fit one page.
  // Closure-formatted quarterly date labels ("Q3 2024") round out
  // the frame. Teal completes the no-adjacent-duplicates cycle.
  (no-image(cv), base + (
    accent: palettes.teal,
    columnRatio: 1,
    dateFormat: parts => {
      if parts.month == none { return str(parts.year) }
      let quarter = int((parts.month - 1) / 3) + 1
      "Q" + str(quarter) + " " + str(parts.year)
    },
    leftColumnSections: ("work",),
    rightColumnSections: ("skills", "languages", "education", "certificates"),
  ), (:)),
)

#for (i, (frame-cv, prefs, lbls)) in frames.enumerate() {
  if i > 0 { pagebreak(weak: true) }
  alta(frame-cv, preferences: prefs, labels: lbls)
}
