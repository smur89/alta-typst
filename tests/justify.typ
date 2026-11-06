// `set par(justify: true)` before `alta()`: prose (the summary, highlights, focus
// areas) is justified and hyphenated. The contact bar, the wrapped
// skill tag row, the long heading and the wrapped interests row stay
// ragged.

#import "../lib.typ": alta

#set par(justify: true)

#let profile(network, username) = (network: network, username: username)

#alta(
  (
    basics: (
      name: "Jane Doe",
      email: "jane.doe@example.com",
      phone: "+353 1 555 0100",
      location: "Dublin, Ireland",
      profiles: (
        profile("GitHub", "janedoe-engineering"),
        profile("LinkedIn", "janedoe-engineering"),
        profile("Mastodon", "@janedoe@fosstodon.org"),
        profile("ORCID", "0000-0002-1825-0097"),
      ),
      summary: "Backend engineer with twelve years of experience designing distributed, event-driven systems for payments and logistics, with a particular interest in observability and incremental migrations.",
    ),
    custom: (
      altacv: (
        focusAreas: (
          "Internationalisation of transactional infrastructure across regulatory jurisdictions.",
        ),
      ),
    ),
    work: (
      (
        name: "Acme Corp",
        position: "Principal Engineer, Platform Reliability and Developer Productivity",
        highlights: (
          "Led the incremental migration of a customer-facing monolith into independently deployable, event-driven services, halving p99 latency.",
        ),
      ),
    ),
    skills: (
      (
        name: "Languages",
        keywords: (
          "Scala",
          "Haskell",
          "Python",
          "TypeScript",
          "Go",
          "Rust",
          "Kotlin",
        ),
      ),
    ),
    interests: (
      (
        name: "Music",
        keywords: ("Traditional Irish", "Jazz", "Choral", "Early music"),
      ),
    ),
  ),
)
