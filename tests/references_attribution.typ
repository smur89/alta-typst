// JSON Resume 1.7.0 `references[].relationship`, `organization` and
// `date` render as one line under the referee's name, missing parts
// dropping out with their separator. (`dateFormat` handling is
// covered in tests/unit/references.typ.)

#import "../lib.typ": alta

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
