// Single-column / ATS-friendly layout (`preferences.layout: "single-
// column"`). Sections render full-width, top-to-bottom — easier for
// recruiter portals and ATS PDF text extractors to linearise than
// the default two-column grid. The portrait is auto-dropped and pill
// tags degrade to plain comma-separated text.
//
// Four documents exercise the API surface:
//   1. Defaults — the auto-resolved behaviour for the typical caller.
//   2. Custom `singleColumnSections` order.
//   3. `plainTags: false` explicitly opts pills back in.
//   4. `plainTags: true` in two-column mode (the inverse opt-in:
//      ATS-friendly text without dropping the photo or the grid).

#import "../lib.typ": alta

#let cv = (
  basics: (
    name: "Jane Doe",
    label: "Senior Software Engineer",
    summary: [
      Backend engineer with eight years of experience designing
      distributed, event-driven systems.
    ],
    email: "jane@example.com",
    phone: "+353 1 555 0100",
    location: "Dublin, Ireland",
    // Supplied to confirm the single-column path actually drops the
    // image — if it leaked through, the layout would be broken.
    image: read("../examples/avatar-placeholder.svg", encoding: none),
    profiles: (
      (network: "LinkedIn", username: "janedoe", url: "https://linkedin.com/in/janedoe"),
      (network: "GitHub",   username: "janedoe", url: "https://github.com/janedoe"),
    ),
  ),
  focusAreas: (
    [Distributed systems and event sourcing.],
    [Functional programming in Scala and Haskell.],
  ),
  work: (
    (
      name: "Acme Corp",
      position: "Senior Software Engineer",
      location: "Dublin, Ireland",
      startDate: "Jan 2022",
      highlights: (
        [Led the migration of a customer-facing monolith into a set
          of event-driven microservices, halving p99 latency.],
        [Mentored three engineers from mid to senior level.],
      ),
    ),
    (
      name: "Liffey Labs",
      position: "Software Engineer",
      location: "Remote",
      startDate: "Jun 2019",
      endDate: "Dec 2021",
      highlights: (
        [Built and shipped the first version of a SaaS product
          alongside a two-person team.],
      ),
    ),
  ),
  skills: (
    (name: "Languages", keywords: ("Scala", "Haskell", "Python")),
    (name: "Infra",     keywords: ("Kafka", "AWS", "Kubernetes")),
  ),
  languages: (
    (language: "English", fluency: "Native"),
    (language: "Irish",   fluency: "Professional Working"),
  ),
  education: (
    (
      institution: "Example University",
      studyType: "M.Sc. in Computer Science",
      startDate: "2017",
      endDate: "2019",
      score: "Distinction",
    ),
  ),
  certificates: (
    (name: "Certified Kubernetes Administrator", issuer: "CNCF"),
    (name: "AWS Solutions Architect",            issuer: "Amazon Web Services"),
  ),
  projects: (
    (
      name: "Idempotent Kafka",
      description: "Open-source library for at-most-once Kafka consumers.",
      url: "https://example.com/idempotent-kafka",
      keywords: ("Scala", "Kafka", "Functional"),
    ),
  ),
  publications: (
    (
      name: "Event Sourcing in Practice",
      releaseDate: "Jun 2024",
      url: "https://example.com/posts/event-sourcing",
    ),
  ),
  interests: (
    (name: "Music",   keywords: ("Guitar", "Bouzouki")),
    (name: "Outdoor", keywords: ("Cycling", "Hiking", "Sailing")),
  ),
)

// 1. Defaults: layout switch is the only required override. The
//    portrait drops, sections render full-width in
//    `_default_single_column_sections` order, and pill tags
//    degrade to plain text.
#alta(cv, preferences: (
  layout: "single-column",
))

#pagebreak()

// 2. Custom section order — drops `projects` and `publications`,
//    moves `education` ahead of `work`.
#alta(cv, preferences: (
  layout: "single-column",
  singleColumnSections: (
    "focusAreas",
    "education",
    "work",
    "skills",
    "languages",
    "certificates",
  ),
))

#pagebreak()

// 3. Explicit `plainTags: false` brings the pill chrome back inside
//    the single-column layout — for users who want sequential
//    sections but keep the visual style.
#alta(cv, preferences: (
  layout: "single-column",
  plainTags: false,
))

#pagebreak()

// 4. Two-column layout with plain-text tags. The inverse opt-in:
//    keeps the photo and the grid but renders skills / certs /
//    project keywords as ATS-friendly comma-separated text.
#alta(cv, preferences: (
  plainTags: true,
))
