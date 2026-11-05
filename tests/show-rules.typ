// A user's show rules, written before `alta()`, restyling one part at
// a time: the name (the level-1 heading) and section headings (level-2
// headings) in a serif over the sans body, and a rule for every label
// in the README's Restyling parts table, lines included. The labels
// override the template's own settings, colour included, which a rule
// on `heading` can't. Icons keep the theme's colour, except the date
// and location icons, and the rating dots, which a rule can recolour
// or replace. The list bullet is a dash, through
// `show list: set list(...)`, and the line between entries is thicker,
// through Typst's own `show divider: set line(...)`, alongside the
// deprecated `<alta-divider>` rule's colour, which still applies.

#import "@preview/fontawesome:0.6.2": fa-icon
#import "../lib.typ": alta

#show heading.where(level: 1).or(heading.where(level: 2)): set text(
  font: "Libertinus Serif",
)
#show <alta-name>: set text(tracking: 0.08em)
#show <alta-headline>: set text(fill: rgb("#5b2c6f"), style: "italic")
#show <alta-section-title>: set text(fill: rgb("#1f618d"))
#show <alta-entry-title>: set text(weight: "bold")
#show <alta-group-title>: set text(fill: rgb("#b03a2e"))
#show <alta-contact>: set text(font: "DejaVu Sans Mono", weight: "regular")
#show <alta-date>: set text(fill: rgb("#b03a2e"), style: "italic")
#show <alta-location>: set text(size: 0.85em)
#show <alta-org>: set text(fill: rgb("#7d6608"))
#show <alta-facts>: set text(style: "italic")
#show <alta-summary>: set text(fill: rgb("#117864"))
#show <alta-pill>: set text(font: "New Computer Modern")
#show <alta-pill-label>: set text(fill: rgb("#b03a2e"))
#show <alta-rating-label>: set text(weight: "bold")
#show <alta-keyword>: set text(fill: rgb("#1f618d"), style: "italic")
#show <alta-keywords>: set par(spacing: 1.5em)
#show <alta-footer>: set text(fill: rgb("#b03a2e"))
#show <alta-section-rule>: set line(stroke: 2pt + rgb("#7d6608"))
#show <alta-divider>: set line(stroke: (paint: rgb("#b03a2e")))
#show divider: set line(stroke: (thickness: 1.5pt))
#show list: set list(marker: [–])
#show <alta-date-icon>: set text(fill: rgb("#b03a2e"))
#show <alta-location-icon>: fa-icon("map-pin", solid: true)
#show <alta-rating-full>: set circle(fill: rgb("#7d6608"))
#show <alta-rating-half>: [#text(font: "DejaVu Sans Mono")[◐]]
#show <alta-rating-empty>: [#text(font: "DejaVu Sans Mono")[○]]

#alta(
  (
    basics: (
      name: "Jane Doe",
      label: "Senior Software Engineer",
      email: "jane@example.com",
      phone: "+353 1 555 0100",
      location: "Dublin, Ireland",
    ),
    work: (
      (
        name: "Acme Corp",
        position: "Staff Engineer",
        summary: "Platform team lead.",
        location: "Dublin, Ireland",
        startDate: "2022-01",
        highlights: ("Led the platform team.",),
      ),
      (name: "Liffey Labs", position: "Engineer", startDate: "2019-06"),
    ),
    projects: (
      (
        name: "Event pipeline",
        summary: "Streaming ingestion.",
        keywords: ("Kafka", "Flink"),
      ),
    ),
    skills: ((name: "Languages", keywords: ("Scala", "Haskell")),),
    languages: (
      (language: "English", fluency: "Native"),
      // 3.5: full, half and empty dots.
      (language: "Spanish", custom: (altacv: (rating: 3.5))),
    ),
    publications: (
      (
        name: "Event Sourcing in Practice",
        type: "talk",
        publisher: "ScalaConf",
      ),
    ),
  ),
  preferences: (page-footer: align(right)[Jane Doe · CV]),
)
