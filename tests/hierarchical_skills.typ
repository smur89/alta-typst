// Hierarchical / nested skill groups. The renderer detects per entry:
// a `groups` key triggers the nested layout (outer `name` as a `===`
// sub-heading, inner groups as the usual pill rows); a `keywords` key
// renders as today's flat row. Both shapes can coexist in the same
// `skills[]` array — the trailing entry here exercises that fallback.

#import "../lib.typ": alta

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  skills: (
    (
      name: "Backend",
      groups: (
        (name: "Languages",  keywords: ("Scala", "Haskell")),
        (name: "Frameworks", keywords: ("Akka", "Cats Effect")),
      ),
    ),
    (
      name: "Frontend",
      groups: (
        (name: "Languages", keywords: ("TypeScript",)),
        (name: "Tooling",   keywords: ("Vite", "ESLint")),
      ),
    ),
    // Flat shape still works alongside nested entries — useful for a
    // miscellaneous "Tools" row that doesn't warrant its own subgroup.
    (name: "Tools", keywords: ("Git", "Docker")),
    // Nested cluster with no usable inner rows: every inner group has
    // empty keywords. Must not emit an orphan "Empty" sub-heading.
    (name: "Empty", groups: (
      (name: "Skipped", keywords: ()),
    )),
  ),
))
