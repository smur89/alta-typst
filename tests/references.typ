// JSON Resume `references` section. Three separate documents stacked
// in one fixture to cover the three paths through the renderer:
//
//   1. Populated — `name` + `reference` entries with the divider rule
//      between them, plus a quote-only entry rendered anonymously, plus
//      a name-only entry that's silently skipped (no orphan heading).
//   2. Empty references + `referencesAvailableOnRequest: true` —
//      the section renders the heading with the italic fallback line
//      underneath, no entries.
//   3. Empty references + the default (`referencesAvailableOnRequest:
//      false`) — the section is suppressed entirely (no heading, no
//      fallback line).

#import "../lib.typ": alta

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  references: (
    (
      name: "Dr Ada Lovelace",
      reference: [
        Jane is a calm, methodical engineer who left every system she
        touched in a better state than she found it. Recommended without
        reservation.
      ],
    ),
    (
      name: "Grace Hopper",
      reference: "An exemplary collaborator — pragmatic, curious, and unfailingly kind.",
    ),
    (
      // Anonymous quote — no `name`, the `reference` still renders.
      reference: "Would hire again in a heartbeat.",
    ),
    (
      // Skipped — `reference` missing, so no orphan heading.
      name: "Alan Turing",
    ),
    (
      // Skipped — explicit empty quote.
      name: "Edsger Dijkstra",
      reference: "",
    ),
  ),
))

#pagebreak()

// Empty references + opt-in fallback. Heading + italic line.
#alta(
  (
    basics: (name: "Jane Doe", email: "jane@example.com"),
    references: (),
  ),
  preferences: (referencesAvailableOnRequest: true),
)

#pagebreak()

// Empty references + default (suppressed) — header only, no section.
#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  references: (),
))
