// Source for `examples/preview.gif` — the animated README hero. Each
// entry in the `frames` array below is one preference variation; the
// document emits one page per entry. Compiled to a series of PNGs
// via `typst compile --format png … '{p}.png'`, then stitched by
// `make preview-gif` (ffmpeg with high-quality palette generation).
//
// Cycles the six accent palettes through the frames as a secondary
// axis so every frame demonstrates two knobs at once — the headline
// variation (image position, column ratio, date format, …) plus a
// fresh accent so the colour story is woven into the layout story
// instead of taking dedicated frames.
//
// The base `cv` is tuned so every variation — including the
// `columnRatio: 1` single-column variation, which stacks every
// section vertically — fits in exactly one page. If you add
// content here (an extra work highlight, another skill group),
// verify the single-column frame still renders as a single page
// (`pdfinfo .../preview-frames.pdf | grep Pages` should match the
// `frames` array length); otherwise the GIF carries an orphan
// continuation frame.
//
// Add a new variation by appending a `(accent: …, …)` dict to
// `frames`. Keep the base `cv` deep enough to exercise every
// demonstrated surface (languages for ratings, certificates for
// grouping, etc.) but small enough to fit in single-column.

#import "../lib.typ": alta, palettes, maps-providers
#import "_dates.typ": ago, today

#let cv = (
  basics: (
    name: "Seán Ó Murchú",
    label: "Senior Software Engineer",
    summary: [
      Backend engineer with eight years of experience designing
      distributed, event-driven systems. Specialises in functional
      programming, observability, and developer experience.
    ],
    email: "sean@example.com",
    phone: "+353 1 555 0100",
    location: "Tallaght, Dublin",
    url: "https://seanomurchu.dev",
    image: read("avatar-placeholder.svg", encoding: none),
    profiles: (
      (network: "GitHub", username: "seanomurchu", url: "https://github.com/seanomurchu"),
      (network: "LinkedIn", username: "seanomurchu", url: "https://linkedin.com/in/seanomurchu"),
    ),
  ),

  meta: (
    // Drives the `lastModifiedFooter` demo. Sourced from the same
    // `today` anchor as the rest of the example dates so the footer
    // year doesn't drift independently.
    lastModified: today.display("[year]-[month]-[day]"),
  ),

  focusAreas: (
    [Distributed systems and functional programming.],
  ),

  // CV tuned so every variation — including the `columnRatio: 1`
  // single-column variation, which stacks every section vertically
  // — fits on one page. The two-column variations leave some
  // whitespace on the right column at this size; that's fine, since
  // they're demonstrating layout not bulk.
  work: (
    (
      name: "Acme Corp",
      url: "https://acme.example.com",
      position: "Senior Software Engineer",
      location: "Dublin, Ireland",
      startDate: ago(years: 4),
      summary: [Platform team lead. Owns the event-sourcing stack.],
      highlights: (
        [Migrated a customer-facing monolith to event-driven services, halving p99 latency.],
      ),
    ),
  ),

  skills: (
    (name: "Languages", keywords: ("Scala", "Haskell", "Go")),
    (name: "Infra",     keywords: ("Kafka", "AWS", "Kubernetes")),
  ),

  // Mix fluency string + numeric ratings so the maxRating frame
  // (which switches to a CEFR-style 6-dot scale) needs only the
  // numeric values to scale correctly.
  languages: (
    (language: "English", fluency: "Native"),
    (language: "French",  rating: 2.5),
  ),

  education: (
    (
      institution: "Tallaght Institute of Technology",
      url: "https://example.edu/tit",
      studyType: "M.Sc. in Computer Science",
      startDate: ago(years: 9, precision: "year"),
      endDate: ago(years: 7, precision: "year"),
    ),
  ),

  // Two certs from the same issuer so `groupCertificates: false`
  // produces a visibly distinct flat strip vs the default grouped
  // pill row.
  certificates: (
    (
      name: "Certified Kubernetes Administrator",
      issuer: "CNCF",
      date: ago(years: 3),
    ),
    (
      name: "Certified Kubernetes Application Developer",
      issuer: "CNCF",
      date: ago(years: 2),
    ),
  ),

  awards: (
    (
      title: "Best Paper — Distributed Systems Track",
      awarder: "EuroSys",
      date: ago(years: 2),
    ),
  ),
)

// Each entry produces one frame. The accent cycles through `palettes`
// as a secondary axis so frame-to-frame colour change reinforces the
// preference change without occupying frames of its own.
#let frames = (
  // Frame 1: default — the anchor every other frame deviates from.
  (:),

  // imagePosition variations — moves the portrait, with text-align
  // matched to the position so the contact bar reads naturally.
  (accent: palettes.navy,    imagePosition: "left"),
  (accent: palettes.crimson, imagePosition: "center", headerTextAlign: "center"),
  (accent: palettes.forest,  imagePosition: "center", imageStackOrder: "below", headerTextAlign: "center"),

  // headerTextAlign variations — text shifts within the existing
  // (default right) image column.
  (accent: palettes.plum,     headerTextAlign: "right"),
  (accent: palettes.charcoal, headerTextAlign: "center"),

  // columnRatio variations — the most layout-altering knob.
  // 0.35 with swapped section arrays inverts the CV; 1.0 collapses
  // to a single full-width column.
  (
    accent: palettes.teal,
    columnRatio: 0.35,
    leftColumnSections: ("focusAreas", "skills", "languages", "education", "certificates"),
    rightColumnSections: ("work", "publications", "awards"),
  ),
  (accent: palettes.navy, columnRatio: 1),

  // Section-level toggles.
  (accent: palettes.crimson, groupCertificates: false),
  (accent: palettes.forest,  uppercaseName: false),
  (accent: palettes.plum,    lastModifiedFooter: true),

  // dateFormat variations — every date on the page reshapes.
  (accent: palettes.charcoal, dateFormat: "iso"),
  (accent: palettes.teal,     dateFormat: "short"),
  (accent: palettes.navy,     dateFormat: "[day padding:none] [month repr:short] [year]"),
  (
    accent: palettes.crimson,
    // Closure formatter — `parts` is `(year, month?, day?)`. Builds
    // a "Q1 2024"-style quarterly label.
    dateFormat: parts => {
      if parts.month == none { return str(parts.year) }
      let quarter = int((parts.month - 1) / 3) + 1
      "Q" + str(quarter) + " " + str(parts.year)
    },
  ),

  // Rating scale — language dots switch to a 6-dot CEFR-style row.
  (accent: palettes.forest, maxRating: 6),

  // Custom content footer — renders on every page, in any colour.
  (accent: palettes.plum, pageFooter: align(right, text(0.8em, fill: rgb("#666666"), "altacv preview"))),
)

#for (i, prefs) in frames.enumerate() {
  if i > 0 { pagebreak(weak: true) }
  alta(cv, preferences: prefs)
}
