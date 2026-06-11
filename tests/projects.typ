// JSON Resume `projects` section. Covers the practical field set:
// linked title, description, date range, highlights, keywords.
// Includes a minimal entry (name only) and a complete entry to
// exercise every optional field.

#import "../lib.typ": alta

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  projects: (
    (
      name: "Hyperion",
      description: "Distributed task scheduler in Rust",
      startDate: "Jan 2024",
      endDate: "Aug 2024",
      url: "https://github.com/janedoe/hyperion",
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
  ),
))
