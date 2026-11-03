// JSON Resume `projects` clustered by `type` (an optional field).
// When at least one entry is typed, entries group under `====`
// subheadings in first-occurrence order; untyped entries pool under
// `labels.otherProjects` ("Other"). Fixture covers: two entries
// sharing a type, a second type, and an untyped entry falling through
// to the "Other" bucket.

#import "../lib.typ": alta

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
