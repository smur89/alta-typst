// Source for `examples/preview.webp` — the animated README hero.
// One frame per built-in theme, each layering a small override on
// top of the shared `base` preferences below so the animation reads as
// "the template with one or two knobs turned" rather than
// independent configurations.
//
// Frame 1 is the baseline minus the photo. The later frames each
// re-arrange the section columns (moving work to the right,
// pulling volunteer or interests in, dropping one section in
// favour of another) on top of their accent / image / date /
// label variations. The body layout shifts visibly frame-to-frame
// so the animation reads as more than just a colour cycle.
//
// Image presence alternates frame-to-frame: odd frames render
// without a photo (realistic for ATS / anti-bias CVs), even
// frames render with one in a different position, shape or size
// (centred above, left, right; circle, rounded, square). The alternation reinforces that the photo is
// optional — one more knob among many, not the visual anchor.
//
// The theme also changes every frame, one built-in theme each: the
// `altacv` theme (dark red headings over a gold rule) leads, and the
// bolder themes (odd frames) alternate with the single-hue ones (even
// frames), so neighbouring frames differ in character, not just hue.
//
// `photo-position: bottom` is deliberately excluded — the photo
// reads as an afterthought when stacked below the contact bar.

#import "@preview/fontawesome:0.6.2": fa-icon
#import "../lib.typ": alta, altacv, cv-footer, maps-providers, tag, themes
#import "_cv.typ": cv, in-irish, no-image

// Frames 4, 8 and 12 render in Irish: `set text(lang: "ga")` picks the
// package's Irish labels, with the CV's content translated to match
// (`in-irish`), to demonstrate localisation.
#let in-ga(body) = {
  set text(lang: "ga")
  body
}

// Baseline preferences the per-frame overrides patch on top of. A
// richer-than-defaults setup (ISO short-date, OSM maps, CEFR-style
// 6-dot rating) gives the animation more visual surface to vary —
// frames flip themes, swap columns, invert layouts on top of this same
// starting point. Every frame is themed by the template, with a page
// footer and one body size (the loop at the end), so what changes
// between frames is the theme and layout, not the type.
#let base = (
  date-format: "[day padding:none] [month repr:short] [year]",
  maps-provider: maps-providers.osm,
  max-rating: 6,
  left-column-sections: (
    "work",
    "volunteer",
    "projects",
    "publications",
    "interests",
  ),
  right-column-sections: (
    "focus-areas",
    "skills",
    "languages",
    "education",
    "certificates",
    "awards",
  ),
)

// Show rules over a frame, as a user's restyling: stars in place of
// the rating dots (FontAwesome, in each dot's colour), and entries'
// keywords as tags, spaced as skill rows are.
#let restyled(body) = {
  let star(name, solid: true) = fa-icon(name, solid: solid, size: 0.85em)
  show <alta-rating-full>: star("star")
  show <alta-rating-half>: star("star-half-stroke")
  show <alta-rating-empty>: star("star", solid: false)
  show <alta-keyword>: tag
  show <alta-keywords>: set par(leading: 0.8em, spacing: 0.8em)
  body
}

// Each frame is `(cv: …, theme: …, prefs: …)`, with `wrap` (rules
// around its template: `restyled`, `in-ga`) where it sets one. Frames using
// `no-image(cv)` drop the photo; frames using `cv`, or
// `in-irish(cv)` (the content in Irish), keep it. Dict
// spread (`base + (key: value)`) is Typst's equivalent of Scala's
// `base.copy(key = value)`, so each frame reads as a small patch over
// the baseline.
#let frames = (
  // ── Frame 1 ─ altacv + no image ─────────────────────────────────
  // Baseline arrangement: work-heavy left, support sections on the
  // right. The realistic baseline most users ship — photo
  // omitted (ATS- / anti-bias-friendly), the altacv theme.
  (
    cv: no-image(cv),
    theme: themes.altacv,
    prefs: base
      + (
        left-column-sections: (
          "work",
          "volunteer",
          "projects",
          "publications",
          "awards",
        ),
        right-column-sections: (
          "focus-areas",
          "skills",
          "languages",
          "education",
          "certificates",
          "interests",
        ),
      ),
  ),

  // ── Frame 2 ─ charcoal + photo centred above + side panel left
  // The photo stacked above a centred header, over a narrow side
  // panel on the left (`column-ratio: 0.35`) led by skills and
  // languages, with work leading the main column on the right.
  // Charcoal contrasts the dark red opener.
  (
    cv: cv,
    theme: themes.charcoal,
    prefs: base
      + (
        column-ratio: 0.35,
        photo-position: top,
        header-text-align: center,
        left-column-sections: (
          "skills",
          "languages",
          "focus-areas",
          "education",
          "certificates",
          "interests",
        ),
        right-column-sections: (
          "work",
          "volunteer",
          "projects",
          "publications",
        ),
      ),
  ),

  // ── Frame 3 ─ rust + no image + single column ───────────────────
  // Single-column layout (`column-ratio: 1`) led by areas of focus,
  // skills and languages, then work, projects and education, with
  // closure-formatted quarterly date labels ("Q3 2024").
  (
    cv: no-image(cv),
    theme: themes.rust,
    prefs: base
      + (
        column-ratio: 1,
        date-format: parts => {
          if parts.month == none { return str(parts.year) }
          let quarter = int((parts.month - 1) / 3) + 1
          "Q" + str(quarter) + " " + str(parts.year)
        },
        left-column-sections: ("focus-areas", "skills", "languages", "work"),
        right-column-sections: ("projects", "education"),
      ),
  ),

  // ── Frame 4 ─ crimson + photo left + QR right + Irish ────────
  // Image swung to the left of the header with a QR matrix mirrored
  // on the right — the flipped twin of frame 6's QR layout, exercising
  // the same feature under `photo-position: left`. Section columns
  // swap emphasis (compact / support blocks lead, work and volunteer
  // move right). In Irish: the headings, months and footer
  // (`in-ga`) and the content (`in-irish`).
  (
    cv: in-irish(cv),
    theme: themes.crimson,
    prefs: base
      + (
        photo-position: left,
        qr-code: auto,
        left-column-sections: (
          "focus-areas",
          "skills",
          "languages",
          "education",
          "certificates",
          "awards",
          "interests",
        ),
        right-column-sections: ("work", "volunteer"),
      ),
    wrap: in-ga,
  ),

  // ── Frame 5 ─ bauhaus + no image + centred + equal columns ──────
  // A centred header over two columns of equal width
  // (`column-ratio: 0.5`) that split the long-form sections: projects
  // and publications lead the left, work the right.
  (
    cv: no-image(cv),
    theme: themes.bauhaus,
    prefs: base
      + (
        header-text-align: center,
        column-ratio: 0.5,
        left-column-sections: (
          "projects",
          "publications",
          "education",
          "certificates",
          "interests",
        ),
        right-column-sections: (
          "work",
          "volunteer",
          "focus-areas",
          "skills",
          "languages",
        ),
      ),
  ),

  // ── Frame 6 ─ plum + photo right + QR left + short dates + education first
  // Image on the right (canonical default) and a QR matrix on the
  // opposite side — a [QR | text | photo] header showcasing the
  // print-affordance feature on the standard layout. Compact European-
  // style `[day]/[month]/[year]` dates. Education
  // and certificates lead the main column (`column-ratio: 0.6`), ahead
  // of work.
  (
    cv: cv,
    theme: themes.plum,
    prefs: base
      + (
        column-ratio: 0.6,
        qr-code: auto,
        date-format: "[day]/[month]/[year]",
        left-column-sections: (
          "education",
          "certificates",
          "work",
          "volunteer",
          "awards",
        ),
        right-column-sections: (
          "focus-areas",
          "skills",
          "languages",
          "projects",
          "publications",
          "interests",
        ),
      ),
  ),

  // ── Frame 7 ─ riso + no image + side panel left + projects first
  // A side panel on the left (`column-ratio: 0.42`) of compact
  // sections; projects and publications lead the main column on the
  // right, ahead of work. Name cased naturally.
  (
    cv: no-image(cv),
    theme: themes.riso,
    prefs: base
      + (
        column-ratio: 0.42,
        uppercase-name: false,
        left-column-sections: (
          "focus-areas",
          "skills",
          "languages",
          "education",
          "certificates",
          "interests",
        ),
        right-column-sections: (
          "projects",
          "publications",
          "work",
          "volunteer",
          "awards",
        ),
      ),
  ),

  // ── Frame 8 ─ teal + rounded photo left + single column + justified + Irish
  // A second single column (`column-ratio: 1`), this one under a
  // rounded photo on the left, led by education, with body text
  // justified to both edges.
  // In Irish: the headings, months and footer (`in-ga`) and
  // the content (`in-irish`).
  (
    cv: in-irish(cv),
    theme: themes.teal,
    prefs: base
      + (
        photo-position: left,
        photo-shape: "rounded",
        column-ratio: 1,
        left-column-sections: ("education", "work", "projects"),
        right-column-sections: ("skills", "languages", "awards"),
      ),
    wrap: body => in-ga({
      set par(justify: true)
      body
    }),
  ),

  // ── Frame 9 ─ catppuccin + no image + right-aligned + narrow panel left
  // Header text aligned right, over a very narrow side panel on the
  // left (`column-ratio: 0.3`) and a wide main column on the right.
  (
    cv: no-image(cv),
    theme: themes.catppuccin,
    prefs: base
      + (
        column-ratio: 0.3,
        header-text-align: right,
        left-column-sections: (
          "focus-areas",
          "skills",
          "languages",
          "certificates",
          "interests",
        ),
        right-column-sections: (
          "work",
          "volunteer",
          "projects",
          "education",
          "awards",
        ),
      ),
  ),

  // ── Frame 10 ─ forest + square photo right + wide main column + restyled
  // A square-cropped photo, a wider main column
  // (`column-ratio: 0.7`) for work, volunteer, projects, publications
  // and awards, and show rules (`restyled`) drawing stars for the
  // rating dots and entries' keywords as tags, with the keyword
  // separator dropped.
  (
    cv: cv,
    theme: themes.forest + (separator: (keywords: "")),
    prefs: base
      + (
        photo-shape: "square",
        column-ratio: 0.7,
        left-column-sections: (
          "work",
          "volunteer",
          "projects",
          "publications",
          "awards",
        ),
        right-column-sections: (
          "focus-areas",
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
  // (`column-ratio: 0.45`).
  (
    cv: no-image(cv),
    theme: themes.phosphor,
    prefs: base
      + (
        column-ratio: 0.45,
        date-format: "[year]-[month]",
        left-column-sections: (
          "focus-areas",
          "skills",
          "languages",
          "education",
          "certificates",
        ),
        right-column-sections: (
          "publications",
          "projects",
          "work",
          "volunteer",
          "awards",
        ),
      ),
  ),

  // ── Frame 12 ─ navy + large photo right + full URLs + Irish ──
  // A larger photo (`photo-size: 8em`) on the right, the contact
  // bar set up for paper (unlinked, profiles printed as URLs,
  // `github.com/…`, in place of usernames), with volunteer leading the main column (`column-ratio: 0.62`).
  // In Irish: the headings, months and footer (`in-ga`) and
  // the content (`in-irish`).
  (
    cv: in-irish(cv),
    theme: themes.navy,
    prefs: base
      + (
        column-ratio: 0.62,
        photo-size: 8em,
        link-contact-info: false,
        print-full-urls: true,
        left-column-sections: (
          "volunteer",
          "work",
          "education",
          "awards",
          "publications",
        ),
        right-column-sections: (
          "focus-areas",
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

// Each frame under the template, as a CV would be: its theme, the body
// size and a footer with the name and page numbers.
#for (i, frame) in frames.enumerate() {
  if i > 0 { pagebreak(weak: true) }
  let (cv: frame-cv, theme, prefs, wrap) = (wrap: it => it) + frame
  wrap[
    #show: altacv.with(theme: theme)
    #set text(size: 10.5pt)
    #set page(footer: cv-footer())
    #alta(frame-cv, preferences: prefs)
  ]
}
