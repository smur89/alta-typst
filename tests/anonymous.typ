// `preferences.anonymous` — blind-review mode. The same `basics` dict
// renders three different headers depending on the toggle:
//   1. anonymous: false (default) — regression guard. Full header
//      renders unchanged: name + photo + complete contact bar.
//   2. anonymous: true with no `basics.label`. Header collapses
//      cleanly — no orphan vertical space where the label would have
//      sat, no leftover spacing between the (suppressed) name and the
//      section grid below.
//   3. anonymous: true with a fully-populated basics (name, label,
//      photo, every contact channel, profiles). Header collapses to
//      just the label; portrait + contact bar disappear.
//
// Page 3 (anonymous + full basics) is rendered last so the document's
// PDF metadata reflects the anonymous path — each `#alta(...)` calls
// `set document(...)` and the last call wins. `pdfinfo
// examples/tests/anonymous.pdf` should report `Title: Candidate` and
// `Author: Candidate`, confirming identity doesn't leak through file
// properties either.

#import "../lib.typ": alta

// Defaults — anonymous is false. Full header.
#alta((
  basics: (
    name: "Jane Doe",
    label: "Senior Software Engineer",
    email: "jane@example.com",
    phone: "+353 1 555 0100",
    location: "Dublin, Ireland",
    url: "https://janedoe.example.com",
    image: read("../icons/avatar-placeholder.svg", encoding: none),
    profiles: (
      (network: "GitHub", username: "janedoe", url: "https://github.com/janedoe"),
      (network: "LinkedIn", username: "janedoe", url: "https://linkedin.com/in/janedoe"),
    ),
    summary: [Distributed systems engineer with a decade of work on payments infrastructure.],
  ),
  work: (
    (
      name: "Acme Corp",
      position: "Staff Engineer",
      startDate: "2022",
      highlights: ([Owned the payments rewrite end to end.],),
    ),
  ),
  skills: (
    (name: "Backend", keywords: ("Scala", "Rust", "PostgreSQL")),
  ),
))

#pagebreak()

// Anonymous, no label — header collapses to nothing (no name, no
// label, no contact bar). The summary + sections still render below
// to confirm spacing tokens don't leave a phantom strip behind.
#alta(
  (
    basics: (
      name: "Jane Doe",
      email: "jane@example.com",
      summary: [Header above is empty — no name, no label, no contact bar.],
    ),
    work: (
      (
        name: "Acme Corp",
        position: "Staff Engineer",
        startDate: "2022",
        highlights: ([Owned the payments rewrite end to end.],),
      ),
    ),
  ),
  preferences: (anonymous: true),
)

#pagebreak()

// Anonymous, full basics. Header collapses to just the label; the
// photo and every contact channel are suppressed. This is the
// canonical blind-review render — and being the last `#alta(...)`
// call, its `set document(...)` wins, so PDF metadata reads
// "Candidate" / "Candidate".
#alta(
  (
    basics: (
      name: "Jane Doe",
      label: "Senior Software Engineer",
      email: "jane@example.com",
      phone: "+353 1 555 0100",
      location: "Dublin, Ireland",
      url: "https://janedoe.example.com",
      image: read("../icons/avatar-placeholder.svg", encoding: none),
      profiles: (
        (network: "GitHub", username: "janedoe", url: "https://github.com/janedoe"),
        (network: "LinkedIn", username: "janedoe", url: "https://linkedin.com/in/janedoe"),
      ),
      summary: [Distributed systems engineer with a decade of work on payments infrastructure.],
    ),
    work: (
      (
        name: "Acme Corp",
        position: "Staff Engineer",
        startDate: "2022",
        highlights: ([Owned the payments rewrite end to end.],),
      ),
    ),
    skills: (
      (name: "Backend", keywords: ("Scala", "Rust", "PostgreSQL")),
    ),
  ),
  preferences: (anonymous: true),
)
