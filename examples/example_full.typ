// Multi-page demonstration that exercises every section + every
// notable value variation the template supports — useful as a
// reference for a fuller CV and as a render target for features
// that don't fit inside the one-page `example.typ`. Free to
// overflow onto extra pages.
//
// Sections show: every supported profile network, both ongoing
// and closed-range work entries, fluency-string and numeric (incl.
// fractional) language ratings, education with and without score
// (and `area` vs `studyType`), multi-issuer certificate grouping,
// awards with and without each optional field, every projects
// field variant, publication grouping by `type`, and a
// `preferences` override to demonstrate the API surface.
//
// Build locally with:
//   typst compile --root .. example_full.typ example_full.pdf

#import "../lib.typ": alta

#let cv = (
  basics: (
    name: "Shane Murphy",
    label: "Senior Software Engineer",
    summary: [
      Backend engineer with eight years of experience designing
      distributed, event-driven systems. Specialises in functional
      programming, observability, and developer experience.
    ],
    email: "shane@example.com",
    phone: "+353 1 555 0100",
    location: "Tallaght, Dublin",
    image: read("avatar-placeholder.svg", encoding: none),
    // One entry per built-in network so the icon set gets a full visual sweep. `Link` is the generic-URL fallback
    profiles: (
      (network: "LinkedIn",      username: "shanemurphy",     url: "https://linkedin.com/in/shanemurphy"),
      (network: "GitHub",        username: "shanemurphy",     url: "https://github.com/shanemurphy"),
      (network: "GitLab",        username: "shanemurphy",     url: "https://gitlab.com/shanemurphy"),
      (network: "Bluesky",       username: "@shanemurphy",    url: "https://bsky.app/profile/shanemurphy"),
      (network: "Mastodon",      username: "@shane@fosstodon.org", url: "https://fosstodon.org/@shane"),
      (network: "Medium",        username: "@shanemurphy",    url: "https://medium.com/@shanemurphy"),
      (network: "Stackoverflow", username: "shanemurphy",     url: "https://stackoverflow.com/u/1"),
      (network: "X",             username: "@shanemurphy",    url: "https://x.com/shanemurphy"),
      (network: "Website",       username: "shanemurphy.dev", url: "https://shanemurphy.dev"),
      (network: "Link",          username: "talk recording",  url: "https://example.com/talk"),
    ),
  ),

  focusAreas: (
    [Distributed systems: Kafka, CDC, idempotent consumers, event sourcing.],
    [Functional programming and type-driven design in Scala and Haskell.],
    [Developer experience: tooling, CI/CD, observability.],
    [Engineering culture: ADRs, RFCs, mentoring.],
  ),

  work: (
    (
      // Ongoing role — `endDate` omitted → renders as "Present".
      name: "Acme Corp",
      position: "Senior Software Engineer",
      location: "Dublin, Ireland",
      startDate: "Jan 2022",
      highlights: (
        [Led the migration of a customer-facing monolith into a set of
          event-driven microservices, halving p99 latency.],
        [Designed and rolled out an event-sourcing platform now used by
          four product teams.],
        [Mentored three engineers from mid to senior level.],
      ),
    ),
    (
      // Closed-range role with both dates.
      name: "Liffey Labs",
      position: "Software Engineer",
      location: "Remote",
      startDate: "Jun 2019",
      endDate: "Dec 2021",
      highlights: (
        [Built and shipped the first version of a SaaS product from
          scratch alongside a two-person team.],
        [Introduced the CI/CD pipeline and developer-onboarding flow
          that scaled the engineering org from 3 to 15.],
      ),
    ),
  ),

  skills: (
    (name: "Languages", keywords: ("Scala", "Haskell", "Python", "Go")),
    (name: "Infra",     keywords: ("Kafka", "AWS", "Terraform", "Docker", "Kubernetes")),
  ),

  // Languages exercise both inputs: named `fluency` strings and
  // numeric `rating` (with fractional half-dot precision).
  languages: (
    (language: "English",    fluency: "Native"),
    (language: "Irish",      fluency: "Professional Working"),
    (language: "French",     rating: 4),
    (language: "Portuguese", rating: 2.5),
  ),

  education: (
    (
      // Full entry with `studyType` and `score`.
      institution: "Example University",
      studyType: "M.Sc. in Computer Science",
      startDate: "2017",
      endDate: "2019",
      score: "Distinction",
    ),
    (
      // `area` fallback (used when `studyType` is absent), no score.
      institution: "Trinity College Dublin",
      area: "Computer Science",
      startDate: "2014",
      endDate: "2017",
    ),
  ),

  // Multiple issuers + multiple certs per issuer so the
  // `groupCertificates: true` default visibly clusters them. Singletons
  // (Hashicorp) pool into the trailing "other" group.
  certificates: (
    (name: "Certified Kubernetes Administrator",        issuer: "CNCF"),
    (name: "Certified Kubernetes Application Developer", issuer: "CNCF"),
    (name: "AWS Solutions Architect — Professional",    issuer: "AWS"),
    (name: "AWS DevOps Engineer — Professional",        issuer: "AWS"),
    (name: "Hashicorp Terraform Associate",             issuer: "Hashicorp"),
  ),

  // Awards: complete entry plus title-only minimal entry.
  awards: (
    (
      title: "Best Paper Award",
      date: "Sep 2024",
      awarder: "ScalaConf",
      // Content-form summary so emphasis markup renders.
      summary: [For _Idempotent Kafka Consumers_.],
    ),
    (
      // Title-only minimal — every other field absent.
      title: "Dean's List",
    ),
  ),

  // Projects exercise every documented field combination:
  // a complete entry, an ongoing entry, a minimal name-only entry,
  // and a description+keywords-only entry (no URL or dates).
  projects: (
    (
      name: "Hyperion",
      description: "Distributed task scheduler in Rust",
      startDate: "Jan 2024",
      endDate: "Aug 2024",
      url: "https://github.com/shanemurphy/hyperion",
      keywords: ("Rust", "Tokio", "gRPC"),
      highlights: (
        [Handled 10k tasks/s on a single node.],
        [Designed an idempotent retry protocol.],
      ),
    ),
    (
      // Ongoing — `endDate` omitted, renders as "Present".
      name: "Crucible",
      description: "Migration tool for legacy databases",
      startDate: "Sep 2024",
      highlights: ([Schema diffing across PostgreSQL and MySQL.],),
    ),
    (
      // Minimal — only the required field.
      name: "Quill",
    ),
    (
      // Description + keywords, no URL / dates / highlights.
      name: "Tinkerbell",
      description: "Tiny IRC bot",
      keywords: ("Lua",),
    ),
  ),

  // Publications split across explicit `type` values + an untyped
  // entry that falls under `labels.articles`. Dict insertion order
  // controls the rendered group order.
  publications: (
    (
      name: "Event Sourcing in Practice",
      type: "Articles",
      publisher: "Personal Blog",
      releaseDate: "Jun 2024",
      url: "https://example.com/posts/event-sourcing",
    ),
    (
      name: "Designing for Failure",
      type: "Talks",
      releaseDate: "Sep 2023",
      url: "https://example.com/talks/failure",
    ),
    (
      // No `type` → falls into the default `labels.articles` group.
      name: "Untyped Note",
      releaseDate: "Jan 2024",
      url: "https://example.com/untyped",
    ),
  ),
)

// `preferences` override demonstrating the API surface — keeps the
// defaults visually close so the render stays readable.
#alta(cv, preferences: (
  imageSize: 6em,
))
