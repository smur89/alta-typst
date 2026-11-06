// JSON Resume `references`. Documents:
//
//   1. Populated: `name` + `reference` entries with the divider rule
//      between them, plus a quote-only entry rendered anonymously, plus
//      a name-only entry that's silently skipped (no orphan heading).
//   2. Empty references + `references-available-on-request: true`: the
//      section renders the heading with the italic fallback line
//      underneath, no entries.
//   3. Empty references + the default (`references-available-on-request:
//      false`): the section is suppressed entirely (no heading, no
//      fallback line).
//   4. JSON Resume 1.7.0 `relationship`, `organization` and `date`
//      render as one line under the referee's name, missing parts
//      dropping out with their separator. (`date-format` handling is
//      covered in tests/unit/references.typ.)
//   5. JSON Resume 1.7.0 `availableOnRequest`: "show 'available on
//      request' rather than publishing the reference". Mixed: a quoted
//      reference, a named referee on request (name +
//      `labels.references-available-on-request` in place of the quote),
//      an entry with both a quote and the flag (the flag wins, the
//      quote stays private), and a non-boolean flag (ignored, so the
//      quote-less entry is skipped as before).
//   6. Every entry on request: one line under the heading, no names,
//      the same output as `preferences.references-available-on-request`.
//   7. Every entry on request with a translated label.

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
  preferences: (references-available-on-request: true),
)

#pagebreak()

// Empty references + default (suppressed) — header only, no section.
#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  references: (),
))

#pagebreak()

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  references: (
    (
      // Every part.
      name: "Dr Ada Lovelace",
      relationship: "Manager",
      organization: "Pied Piper",
      date: "2024-03",
      reference: "Calm, methodical, and left every system better than she found it.",
    ),
    (
      // Relationship and date only.
      name: "Grace Hopper",
      relationship: "Thesis advisor",
      date: "2019",
      reference: "An exemplary collaborator.",
    ),
    (
      // Organisation only, on an on-request entry.
      name: "Alan Turing",
      organization: "Bletchley Park",
      availableOnRequest: true,
    ),
    (
      // Anonymous, with attribution: the line still renders.
      relationship: "Client",
      reference: "Would hire again in a heartbeat.",
    ),
    (
      // No attribution parts (empty or non-string): no line.
      name: "Margaret Hamilton",
      relationship: "",
      organization: 42,
      reference: "Rigorous and generous with her time.",
    ),
  ),
))

#pagebreak()

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  references: (
    (
      name: "Dr Ada Lovelace",
      reference: "A calm, methodical engineer. Recommended without reservation.",
    ),
    (name: "Grace Hopper", availableOnRequest: true),
    (
      name: "Alan Turing",
      reference: "This quote stays private.",
      availableOnRequest: true,
    ),
    // Not a boolean: ignored, and with no quote the entry is skipped.
    (name: "Not Shown", availableOnRequest: "yes"),
  ),
))

#pagebreak()

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  references: (
    (name: "Grace Hopper", availableOnRequest: true),
    (name: "Alan Turing", availableOnRequest: true),
  ),
))

#pagebreak()

#alta(
  (
    basics: (name: "Jane Doe", email: "jane@example.com"),
    references: ((name: "Grace Hopper", availableOnRequest: true),),
  ),
  labels: (references-available-on-request: "Referenzen auf Anfrage."),
)
