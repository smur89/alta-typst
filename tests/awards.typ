// JSON Resume `awards` section. Each entry has an optional date,
// awarder, and summary. Fixture covers: full entry, no-summary entry,
// no-date entry, title-only minimal, and skip cases (missing title
// and explicit `title: none`).

#import "../lib.typ": alta

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  awards: (
    (
      title: "Best Paper Award",
      date: "Sep 2024",
      awarder: "ScalaConf",
      // Content-form summary so markup (emphasis) renders, not just
      // plain text. Mirrors the way `basics.summary` accepts content.
      summary: [For _Idempotent Kafka Consumers_.],
    ),
    (
      // No summary.
      title: "President's Award",
      date: "Mar 2023",
      awarder: "Example University",
    ),
    (
      // No date.
      title: "Hackathon Winner",
      awarder: "Dublin HackWeek",
      summary: "First place out of 24 teams.",
    ),
    (
      // Title-only minimal entry.
      title: "Dean's List",
    ),
    (
      // Missing title — skipped.
      awarder: "Should Not Render",
    ),
    (
      // Explicit nil title — also skipped.
      title: none,
      summary: "Should also not render",
    ),
  ),
))
