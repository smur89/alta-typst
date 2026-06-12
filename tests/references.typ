// JSON Resume `references` section. Each entry is `{name, reference}`.
// Three documents exercise the API surface:
//   1. Multiple entries — referee name + quote, with skip cases.
//   2. Empty references + `referencesAvailableOnRequest: true` —
//      renders the conventional fallback line under the heading.
//   3. Empty references + `referencesAvailableOnRequest: false` —
//      section is suppressed entirely (no orphan heading).

#import "../lib.typ": alta

#let cv = (
  basics: (name: "Jane Doe", email: "jane@example.com"),
  references: (
    (
      name: "Aoife Ní Bhriain",
      reference: [Jane is one of the most thoughtful engineers I have
        worked with — equally at home in distributed systems design
        and in mentoring the team around her.],
    ),
    (
      // Name-only minimal: quote is mandatory, so this is skipped.
      name: "Should Not Render",
    ),
    (
      // Anonymous reference — no name, quote still renders.
      reference: [A consistently strong contributor with an unusually
        broad technical range.],
    ),
    (
      // Explicit nil reference — skipped.
      name: "Also Not Rendered",
      reference: none,
    ),
  ),
)

// 1. Multiple entries.
#alta(cv)

#pagebreak()

// 2. Empty list + opt-in fallback.
#alta(
  (
    basics: (name: "Jane Doe", email: "jane@example.com"),
    references: (),
  ),
  preferences: (referencesAvailableOnRequest: true),
)

#pagebreak()

// 3. Empty list, default preference — section suppressed.
#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  references: (),
))
