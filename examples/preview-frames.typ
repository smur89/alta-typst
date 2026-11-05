// Source for `examples/preview.gif` — the animated README hero.
// One frame per built-in theme, each layering a small override on
// top of the shared `base` preferences below so the GIF reads as
// "the template with one or two knobs turned" rather than
// independent configurations.
//
// Frame 1 is the baseline minus the portrait. The later frames each
// re-arrange the section columns (moving work to the right,
// pulling volunteer or interests in, dropping one section in
// favour of another) on top of their accent / image / date /
// label variations. The body layout shifts visibly frame-to-frame
// so the GIF reads as more than just a colour cycle.
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
#import "_cv.typ": cv, no-image

// Irish-language label overrides used by frames 4, 8 and 12 to
// demonstrate localisation. Loaded once at parse time — the same
// dict is passed to `alta(..., labels: ga-labels)`.
#let ga-labels = toml("labels-ga.toml")

// Baseline preferences the per-frame overrides patch on top of. A
// richer-than-defaults setup (the altacv theme, ISO short-date,
// OSM maps, auto footer, CEFR-style 6-dot rating) gives the GIF
// more visual surface to vary — frames flip themes, swap columns,
// invert layouts on top of this same starting point.
#let base = (
  theme: themes.altacv,
  dateFormat: "[day padding:none] [month repr:short] [year]",
  mapsProvider: maps-providers.osm,
  pageFooter: auto,
  maxRating: 6,
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

// Each frame is `(cv: …, prefs: …)`, with `labels` (default English)
// and `wrap` (show rules around its `alta()`, see `restyled`) where it
// sets them. Frames using `no-image(cv)` drop the portrait; frames
// using `cv` keep it. Dict spread (`base + (key: value)`) is Typst's
// equivalent of Scala's `base.copy(key = value)`, so each frame reads
// as a small patch over the baseline.
#let frames = (
  // ── Frame 1 ─ altacv + no image ─────────────────────────────────
  // Baseline arrangement: work-heavy left, support sections on the
  // right, at a slightly larger body size (`bodySize: 11pt`) so the
  // page fills. The realistic baseline most users ship — portrait
  // omitted (ATS- / anti-bias-friendly), the altacv theme from
  // `base`.
  (
    cv: no-image(cv),
    prefs: base
      + (
        bodySize: 11pt,
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

  // ── Frame 2 ─ charcoal + portrait centred above ─────────────────
  // Section arrangement matches frame 1, at the default body size;
  // the portrait reappears stacked above a centred header text block.
  // Paired with frame 1 to isolate the photo-position change; charcoal
  // contrasts the dark red baseline so the theme swap is also visible.
  (
    cv: cv,
    prefs: base
      + (
        theme: themes.charcoal,
        imagePosition: "center",
        imageStackOrder: "above",
        headerTextAlign: "center",
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

  // ── Frame 3 ─ rust + no image + single column ───────────────────
  // Single-column layout (`columnRatio: 1`) stacks every section
  // vertically — needs an aggressive section trim to fit one page.
  // Closure-formatted quarterly date labels ("Q3 2024") round out
  // the frame.
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
        leftColumnSections: ("work", "volunteer", "projects"),
        rightColumnSections: ("skills", "languages", "education"),
      ),
  ),

  // ── Frame 4 ─ crimson + portrait left + QR right + Irish labels ─
  // Image swung to the left of the header with a QR matrix mirrored
  // on the right — the flipped twin of frame 6's QR layout, exercising
  // the same feature under `imagePosition: "left"`. Section columns
  // swap emphasis (compact / support blocks lead, work, volunteer and
  // projects move right). Section headings render in Irish via
  // `labels-ga.toml`
  // — the same data dict, just localised display strings.
  (
    cv: cv,
    prefs: base
      + (
        theme: themes.crimson,
        bodySize: 10.5pt,
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
        rightColumnSections: ("work", "volunteer", "projects"),
      ),
    labels: ga-labels,
  ),

  // ── Frame 5 ─ bauhaus + no image + centred + equal columns ──────
  // A centred header over two columns of equal width
  // (`columnRatio: 0.5`), at `bodySize: 11pt`: work, volunteer,
  // projects and publications on the left, the rest on the right.
  (
    cv: no-image(cv),
    prefs: base
      + (
        theme: themes.bauhaus,
        bodySize: 11pt,
        headerTextAlign: "center",
        columnRatio: 0.5,
        leftColumnSections: ("work", "volunteer", "projects", "publications"),
        rightColumnSections: (
          "focusAreas",
          "skills",
          "languages",
          "education",
          "certificates",
          "awards",
          "interests",
        ),
      ),
  ),

  // ── Frame 6 ─ plum + portrait right + QR left + short dates + education up
  // Image on the right (canonical default) and a QR matrix on the
  // opposite side — a [QR | text | portrait] header showcasing the
  // print-affordance feature on the standard layout. Compact European-
  // style `[day]/[month]/[year]` date format, at `bodySize: 11pt`.
  // Education, certificates and awards promoted to the left column
  // alongside work and volunteer; projects and publications move to
  // the right.
  (
    cv: cv,
    prefs: base
      + (
        theme: themes.plum,
        bodySize: 11pt,
        qrCode: auto,
        dateFormat: "[day]/[month]/[year]",
        leftColumnSections: (
          "work",
          "volunteer",
          "education",
          "certificates",
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

  // ── Frame 7 ─ riso + no image + inverted columns ────────────────
  // Narrow side-panel layout (`columnRatio: 0.35`) — compact
  // sections lead the narrow left column; work, volunteer, projects,
  // publications, certificates and awards take the wide right side.
  // Name cased naturally.
  (
    cv: no-image(cv),
    prefs: base
      + (
        theme: themes.riso,
        uppercaseName: false,
        columnRatio: 0.35,
        leftColumnSections: (
          "focusAreas",
          "skills",
          "languages",
          "education",
          "interests",
        ),
        rightColumnSections: (
          "work",
          "volunteer",
          "projects",
          "publications",
          "certificates",
          "awards",
        ),
      ),
  ),

  // ── Frame 8 ─ teal + rounded portrait left + single column + justified
  // A second single column (`columnRatio: 1`), this one under a
  // rounded portrait on the left, with body text justified to both
  // edges.
  // Headings, months and the footer in Irish (`labels-ga.toml`).
  (
    cv: cv,
    prefs: base
      + (
        theme: themes.teal,
        imagePosition: "left",
        imageShape: "rounded",
        justify: true,
        columnRatio: 1,
        leftColumnSections: ("work", "projects"),
        rightColumnSections: ("skills", "languages", "education", "awards"),
      ),
    labels: ga-labels,
  ),

  // ── Frame 9 ─ catppuccin + no image + right-aligned ───────────────
  // Header text aligned right, at `bodySize: 11pt`. Interests closes
  // the main column, after work, volunteer, projects and publications.
  (
    cv: no-image(cv),
    prefs: base
      + (
        theme: themes.catppuccin,
        bodySize: 11pt,
        headerTextAlign: "right",
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
      ),
  ),

  // ── Frame 10 ─ forest + square portrait right + wide main column + restyled
  // A square-cropped portrait, a wider main column
  // (`columnRatio: 0.7`, `bodySize: 10.5pt`) for work, volunteer,
  // projects, publications and awards, and show
  // rules (`restyled`) drawing stars for the rating dots and entries'
  // keywords as pills, with the keyword separator dropped.
  (
    cv: cv,
    prefs: base
      + (
        theme: themes.forest + (separator: (keywords: "")),
        bodySize: 10.5pt,
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

  // ── Frame 11 ─ phosphor + no image + large type + ISO dates ─────
  // Large type (`bodySize: 11.5pt`) over every section but interests,
  // with ISO 8601 dates (`2024-03`) suiting the terminal look.
  (
    cv: no-image(cv),
    prefs: base
      + (
        theme: themes.phosphor,
        bodySize: 11.5pt,
        dateFormat: "[year]-[month]",
        leftColumnSections: ("work", "volunteer", "projects", "publications"),
        rightColumnSections: (
          "focusAreas",
          "skills",
          "languages",
          "education",
          "certificates",
          "awards",
        ),
      ),
  ),

  // ── Frame 12 ─ navy + large portrait right + full URLs ──────────
  // A larger portrait (`imageSize: 8em`) on the right, the contact
  // bar set up for paper (unlinked, profiles printed as URLs,
  // `github.com/…`, in place of usernames), at `bodySize: 11pt`, with
  // education, awards and publications in the main column.
  // Headings, months and the footer in Irish (`labels-ga.toml`).
  (
    cv: cv,
    prefs: base
      + (
        theme: themes.navy,
        bodySize: 11pt,
        imageSize: 8em,
        linkContactInfo: false,
        printFullUrls: true,
        leftColumnSections: (
          "work",
          "volunteer",
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
    labels: ga-labels,
  ),
)

#for (i, frame) in frames.enumerate() {
  if i > 0 { pagebreak(weak: true) }
  let (cv: frame-cv, prefs, labels, wrap) = (
    (labels: (:), wrap: it => it) + frame
  )
  wrap(alta(frame-cv, preferences: prefs, labels: labels))
}
