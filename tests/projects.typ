// JSON Resume `projects`. Documents:
//
//   1. The flat (untyped) layout with the practical field set: linked
//      title, `entity` as the organisation, description, date range,
//      highlights, `roles` tags, keyword tags. Includes a minimal entry
//      (name only) and skipped entries (missing / null name).
//   2. Clustered by `type` (an optional field): when at least one entry
//      is typed, entries group under `====` subheadings in
//      first-occurrence order; untyped entries pool under
//      `labels.other-projects` ("Other"). Covers two entries sharing a
//      type, a second type, and an untyped entry falling through to
//      the "Other" bucket.
//   3. JSON Resume 1.6.0 made `summary` the preferred field and kept
//      `description` as a deprecated alias: `summary` wins when both
//      are set, and an empty `summary` falls through to `description`
//      (the same precedence `work[]` uses). Covers summary only,
//      description only (legacy), both (summary wins), empty summary
//      (falls back), and content-form summary.

#import "../lib.typ": alta

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  projects: (
    (
      name: "Hyperion",
      entity: "Acme Corp",
      description: "Distributed task scheduler in Rust",
      startDate: "Jan 2024",
      endDate: "Aug 2024",
      url: "https://github.com/janedoe/hyperion",
      roles: ("Lead", "Architect"),
      keywords: ("Rust", "Tokio", "gRPC"),
      highlights: (
        [Handled 10k tasks/s on a single node.],
        [Designed an idempotent retry protocol.],
      ),
    ),
    (
      // Minimum viable entry — name only. Renders without dates,
      // highlights, keywords, or description.
      name: "Quill",
    ),
    (
      name: "Crucible",
      // Ongoing — endDate omitted, should render as "Present".
      startDate: "Sep 2024",
      highlights: ([Migration tool for legacy databases.],),
    ),
    (
      // Description + keywords only, no URL / dates / highlights.
      name: "Tinkerbell",
      description: "Tiny IRC bot",
      keywords: ("Lua",),
    ),
    (
      // Entries without a name are silently skipped.
      description: "Should not render",
    ),
    (
      // Entries with name explicitly set to `none` (e.g. from a JSON
      // null deserialization) are also skipped.
      name: none,
      description: "Should also not render",
    ),
  ),
))

#pagebreak()

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  projects: (
    (
      name: "Hyperion",
      type: "Application",
      entity: "Acme Corp",
      description: "Distributed task scheduler in Rust",
      startDate: "Jan 2024",
      endDate: "Aug 2024",
      url: "https://github.com/janedoe/hyperion",
      roles: ("Lead", "Architect"),
      keywords: ("Rust", "Tokio", "gRPC"),
    ),
    (
      // Same type → clusters with Hyperion under "Application".
      name: "Quill",
      type: "Application",
      description: "Markdown note-taking app",
      keywords: ("Swift",),
    ),
    (
      // Distinct type → its own "Library" subheading.
      name: "Crucible",
      type: "Library",
      startDate: "Sep 2024",
      roles: ("Maintainer",),
      highlights: ([Migration tool for legacy databases.],),
    ),
    (
      // No type → falls under the "Other" bucket.
      name: "Tinkerbell",
      description: "Tiny IRC bot",
      keywords: ("Lua",),
    ),
  ),
))

#pagebreak()

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  projects: (
    (
      name: "Summary Only",
      summary: "Event-sourced ledger for a payments start-up.",
      startDate: "2024",
    ),
    (
      name: "Description Only",
      description: "Legacy spelling, still rendered.",
      startDate: "2023",
    ),
    (
      name: "Both Set",
      summary: "Summary wins.",
      description: "Description is ignored when summary is present.",
      startDate: "2022",
    ),
    (
      name: "Empty Summary",
      summary: "",
      description: "Falls back to description.",
      startDate: "2021",
    ),
    (
      name: "Content Summary",
      summary: [Markup _renders_ too.],
      startDate: "2020",
    ),
  ),
))
