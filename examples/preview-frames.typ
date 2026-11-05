// Source for `examples/preview.webp` — the animated README hero.
// One frame per built-in theme, each layering a small override on
// top of the shared `base` preferences below so the animation reads as
// "the template with one or two knobs turned" rather than
// independent configurations.
//
// Frame 1 is the baseline minus the portrait. The later frames each
// re-arrange the section columns (moving work to the right,
// pulling volunteer or interests in, dropping one section in
// favour of another) on top of their accent / image / date /
// label variations. The body layout shifts visibly frame-to-frame
// so the animation reads as more than just a colour cycle.
//
// Image presence alternates frame-to-frame: odd frames render
// without a portrait (realistic for ATS / anti-bias CVs), even
// frames render with one in a different position, shape or size
// (centred above, left, right; circle, rounded, square). The alternation reinforces that the portrait is
// optional — one more knob among many, not the visual anchor.
//
// The theme also changes every frame, one built-in theme each: the
// `altacv` theme (dark red headings over a gold rule) leads, and the
// bolder themes (odd frames) alternate with the single-hue ones (even
// frames), so neighbouring frames differ in character, not just hue.
//
// `imageStackOrder: "below"` is deliberately excluded — the photo
// reads as an afterthought when stacked below the contact bar.

#import "@preview/fontawesome:0.6.2": fa-icon
#import "../lib.typ": alta, maps-providers, tag, themes
#import "_cv.typ": cv, in-irish, no-image

// Frames 4, 8 and 12 render in Irish: `set text(lang: "ga")` picks the
// package's Irish labels, with the CV's content translated to match
// (`in-irish`), to demonstrate localisation.
#let in-ga(body) = {
  set text(lang: "ga")
  body
}

// Baseline preferences the per-frame overrides patch on top of. A
// richer-than-defaults setup (the altacv theme, ISO short-date,
// OSM maps, auto footer, CEFR-style 6-dot rating) gives the animation
// more visual surface to vary — frames flip themes, swap columns,
// invert layouts on top of this same starting point.
#let base = (
  theme: themes.altacv,
  dateFormat: "[day padding:none] [month repr:short] [year]",
  mapsProvider: maps-providers.osm,
  pageFooter: auto,
  maxRating: 6,
  // One body size for every frame, so what changes between frames is
  // the theme and layout, not the type.
  bodySize: 10.5pt,
  leftColumnSections: (
    "work",
    "volunteer",
    "projects",
    "publications",
    "interests",
  ),
  rightColumnSections: (
    "focusAreas",
    "skills",
    "languages",
    "education",
    "certificates",
    "awards",
  ),
)

// Show rules over a frame, as a user's restyling: stars in place of
// the rating dots (FontAwesome, in each dot's colour), and entries'
// keywords as pills, spaced as skill rows are.
#let restyled(body) = {
  let star(name, solid: true) = fa-icon(name, solid: solid, size: 0.85em)
  show <alta-rating-full>: star("star")
  show <alta-rating-half>: star("star-half-stroke")
  show <alta-rating-empty>: star("star", solid: false)
  show <alta-keyword>: tag
  show <alta-keywords>: set par(leading: 0.8em, spacing: 0.8em)
  body
}

// Each frame is `(cv: …, prefs: …)`, with `wrap` (rules around its
// `alta()`: `restyled`, `in-ga`) where it sets one. Frames using
// `no-image(cv)` drop the portrait; frames using `cv`, or
// `in-irish(cv)` (the content in Irish), keep it. Dict
// spread (`base + (key: value)`) is Typst's equivalent of Scala's
// `base.copy(key = value)`, so each frame reads as a small patch over
// the baseline.
#let frames = (
  // ── Frame 1 ─ altacv + no image ─────────────────────────────────
  // Baseline arrangement: work-heavy left, support sections on the
  // right. The realistic baseline most users ship — portrait
  // omitted (ATS- / anti-bias-friendly), the altacv theme from
  // `base`.
  (
    cv: no-image(cv),
    prefs: base
      + (
        leftColumnSections: (
          "work",
          "volunteer",
          "projects",
          "publications",
          "awards",
        ),
        rightColumnSections: (
          "focusAreas",
          "skills",
          "languages",
          "education",
          "certificates",
          "interests",
        ),
      ),
  ),

  // ── Frame 2 ─ charcoal + portrait centred above + side panel left
  // The portrait stacked above a centred header, over a narrow side
  // panel on the left (`columnRatio: 0.35`) led by skills and
  // languages, with work leading the main column on the right.
  // Charcoal contrasts the dark red opener.
  (
    cv: cv,
    prefs: base
      + (
        theme: themes.charcoal,
        columnRatio: 0.35,
        imagePosition: "center",
        imageStackOrder: "above",
        headerTextAlign: "center",
        leftColumnSections: (
          "skills",
          "languages",
          "focusAreas",
          "education",
          "certificates",
          "interests",
        ),
        rightColumnSections: ("work", "volunteer", "projects", "publications"),
      ),
  ),

  // ── Frame 3 ─ rust + no image + single column ───────────────────
  // Single-column layout (`columnRatio: 1`) led by areas of focus,
  // skills and languages, then work, projects and education, with
  // closure-formatted quarterly date labels ("Q3 2024").
  (
    cv: no-image(cv),
    prefs: base
      + (
        theme: themes.rust,
        columnRatio: 1,
        dateFormat: parts => {
          if parts.month == none { return str(parts.year) }
          let quarter = int((parts.month - 1) / 3) + 1
          "Q" + str(quarter) + " " + str(parts.year)
        },
        leftColumnSections: ("focusAreas", "skills", "languages", "work"),
        rightColumnSections: ("projects", "education"),
      ),
  ),

  // ── Frame 4 ─ crimson + portrait left + QR right + Irish ────────
  // Image swung to the left of the header with a QR matrix mirrored
  // on the right — the flipped twin of frame 6's QR layout, exercising
  // the same feature under `imagePosition: "left"`. Section columns
  // swap emphasis (compact / support blocks lead, work and volunteer
  // move right). In Irish: the headings, months and footer
  // (`in-ga`) and the content (`in-irish`).
  (
    cv: in-irish(cv),
    prefs: base
      + (
        theme: themes.crimson,
        imagePosition: "left",
        qrCode: auto,
        leftColumnSections: (
          "focusAreas",
          "skills",
          "languages",
          "education",
          "certificates",
          "awards",
          "interests",
        ),
        rightColumnSections: ("work", "volunteer"),
      ),
    wrap: in-ga,
  ),

  // ── Frame 5 ─ bauhaus + no image + centred + equal columns ──────
  // A centred header over two columns of equal width
  // (`columnRatio: 0.5`) that split the long-form sections: projects
  // and publications lead the left, work the right.
  (
    cv: no-image(cv),
    prefs: base
      + (
        theme: themes.bauhaus,
        headerTextAlign: "center",
        columnRatio: 0.5,
        leftColumnSections: (
          "projects",
          "publications",
          "education",
          "certificates",
          "interests",
        ),
        rightColumnSections: (
          "work",
          "volunteer",
          "focusAreas",
          "skills",
          "languages",
        ),
      ),
  ),

  // ── Frame 6 ─ plum + portrait right + QR left + short dates + education first
  // Image on the right (canonical default) and a QR matrix on the
  // opposite side — a [QR | text | portrait] header showcasing the
  // print-affordance feature on the standard layout. Compact European-
  // style `[day]/[month]/[year]` dates. Education
  // and certificates lead the main column (`columnRatio: 0.6`), ahead
  // of work.
  (
    cv: cv,
    prefs: base
      + (
        theme: themes.plum,
        columnRatio: 0.6,
        qrCode: auto,
        dateFormat: "[day]/[month]/[year]",
        leftColumnSections: (
          "education",
          "certificates",
          "work",
          "volunteer",
          "awards",
        ),
        rightColumnSections: (
          "focusAreas",
          "skills",
          "languages",
          "projects",
          "publications",
          "interests",
        ),
      ),
  ),

  // ── Frame 7 ─ riso + no image + side panel left + projects first
  // A side panel on the left (`columnRatio: 0.42`) of compact
  // sections; projects and publications lead the main column on the
  // right, ahead of work. Name cased naturally.
  (
    cv: no-image(cv),
    prefs: base
      + (
        theme: themes.riso,
        columnRatio: 0.42,
        uppercaseName: false,
        leftColumnSections: (
          "focusAreas",
          "skills",
          "languages",
          "education",
          "certificates",
          "interests",
        ),
        rightColumnSections: (
          "projects",
          "publications",
          "work",
          "volunteer",
          "awards",
        ),
      ),
  ),

  // ── Frame 8 ─ teal + rounded portrait left + single column + justified + Irish
  // A second single column (`columnRatio: 1`), this one under a
  // rounded portrait on the left, led by education, with body text
  // justified to both edges.
  // In Irish: the headings, months and footer (`in-ga`) and
  // the content (`in-irish`).
  (
    cv: in-irish(cv),
    prefs: base
      + (
        theme: themes.teal,
        imagePosition: "left",
        imageShape: "rounded",
        justify: true,
        columnRatio: 1,
        leftColumnSections: ("education", "work", "projects"),
        rightColumnSections: ("skills", "languages", "awards"),
      ),
    wrap: in-ga,
  ),

  // ── Frame 9 ─ catppuccin + no image + right-aligned + narrow panel left
  // Header text aligned right, over a very narrow side panel on the
  // left (`columnRatio: 0.3`) and a wide main column on the right.
  (
    cv: no-image(cv),
    prefs: base
      + (
        theme: themes.catppuccin,
        columnRatio: 0.3,
        headerTextAlign: "right",
        leftColumnSections: (
          "focusAreas",
          "skills",
          "languages",
          "certificates",
          "interests",
        ),
        rightColumnSections: (
          "work",
          "volunteer",
          "projects",
          "education",
          "awards",
        ),
      ),
  ),

  // ── Frame 10 ─ forest + square portrait right + wide main column + restyled
  // A square-cropped portrait, a wider main column
  // (`columnRatio: 0.7`) for work, volunteer, projects, publications
  // and awards, and show rules (`restyled`) drawing stars for the
  // rating dots and entries' keywords as pills, with the keyword
  // separator dropped.
  (
    cv: cv,
    prefs: base
      + (
        theme: themes.forest + (separator: (keywords: "")),
        imageShape: "square",
        columnRatio: 0.7,
        leftColumnSections: (
          "work",
          "volunteer",
          "projects",
          "publications",
          "awards",
        ),
        rightColumnSections: (
          "focusAreas",
          "skills",
          "languages",
          "education",
          "certificates",
          "interests",
        ),
      ),
    wrap: restyled,
  ),

  // ── Frame 11 ─ phosphor + no image + publications first + ISO dates
  // ISO 8601 dates (`2024-03`) suiting the terminal look; publications
  // and projects lead the main column on the right
  // (`columnRatio: 0.45`).
  (
    cv: no-image(cv),
    prefs: base
      + (
        theme: themes.phosphor,
        columnRatio: 0.45,
        dateFormat: "[year]-[month]",
        leftColumnSections: (
          "focusAreas",
          "skills",
          "languages",
          "education",
          "certificates",
        ),
        rightColumnSections: (
          "publications",
          "projects",
          "work",
          "volunteer",
          "awards",
        ),
      ),
  ),

  // ── Frame 12 ─ navy + large portrait right + full URLs + Irish ──
  // A larger portrait (`imageSize: 8em`) on the right, the contact
  // bar set up for paper (unlinked, profiles printed as URLs,
  // `github.com/…`, in place of usernames), with volunteer leading the main column (`columnRatio: 0.62`).
  // In Irish: the headings, months and footer (`in-ga`) and
  // the content (`in-irish`).
  (
    cv: in-irish(cv),
    prefs: base
      + (
        theme: themes.navy,
        columnRatio: 0.62,
        imageSize: 8em,
        linkContactInfo: false,
        printFullUrls: true,
        leftColumnSections: (
          "volunteer",
          "work",
          "education",
          "awards",
          "publications",
        ),
        rightColumnSections: (
          "focusAreas",
          "skills",
          "languages",
          "projects",
          "certificates",
          "interests",
        ),
      ),
    wrap: in-ga,
  ),
)

#for (i, frame) in frames.enumerate() {
  if i > 0 { pagebreak(weak: true) }
  let (cv: frame-cv, prefs, wrap) = (wrap: it => it) + frame
  wrap(alta(frame-cv, preferences: prefs))
}
