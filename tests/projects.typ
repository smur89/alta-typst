// JSON Resume `projects` section, flat (untyped) layout. Covers the
// practical field set: linked title, `entity` subtitle, description,
// date range, highlights, `roles` pills, keyword pills. Includes a
// minimal entry (name only) and skipped entries (missing / null name).
// Grouping by `type` is exercised separately in `projects_grouped.typ`.

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
