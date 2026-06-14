// Shared CV data used by both the static page-1 preview
// (`example.typ` → `examples/preview.png`) and the animated
// multi-frame preview (`preview-frames.typ` → `examples/preview.gif`).
//
// Keeping the data in one file means every frame of the GIF shows the
// SAME fictional CV — only the preferences differ — so accent /
// layout / column-arrangement changes read as preference customisation
// rather than data differences.

#import "_dates.typ": ago

#let cv = (
  basics: (
    name: "Seán Ó Murchú",
    label: "Senior Software Engineer",
    summary: [
      Backend engineer with eight years of experience designing
      distributed, event-driven systems. Specialises in functional
      programming, observability, and developer experience.
    ],
    email: "sean@example.com",
    phone: "+353 1 555 0100",
    location: "Tallaght, Dublin",
    url: "https://seanomurchu.dev",
    image: read("avatar-placeholder.svg", encoding: none),
    profiles: (
      (network: "GitHub", username: "seanomurchu", url: "https://github.com/seanomurchu"),
    ),
  ),

  focusAreas: (
    [Distributed systems and functional programming.],
  ),

  work: (
    (
      name: "Acme Corp",
      url: "https://acme.example.com",
      position: "Senior Software Engineer",
      location: "Dublin, Ireland",
      startDate: ago(years: 4),
      summary: [Platform team lead. Owns the event-sourcing stack.],
      highlights: (
        [Migrated a customer-facing monolith to event-driven services, halving p99 latency.],
        [Rolled out an event-sourcing platform now used by four product teams.],
      ),
    ),
    (
      name: "Liffey Labs",
      position: "Software Engineer",
      location: "Remote",
      startDate: ago(years: 7),
      endDate: ago(years: 4),
      highlights: (
        [Shipped the first version of a SaaS product alongside a two-person team.],
        [Built the CI/CD pipeline that scaled the engineering org from 3 to 15.],
      ),
    ),
    (
      name: "Grand Canal Systems",
      position: "Software Engineer",
      location: "Dublin, Ireland",
      startDate: ago(years: 9),
      endDate: ago(years: 7),
      highlights: (
        [Led the migration of services from VMs to Kubernetes.],
      ),
    ),
  ),

  skills: (
    (name: "Languages", keywords: ("Scala", "Haskell", "Go")),
    (name: "Infra",     keywords: ("Kafka", "AWS", "Kubernetes")),
  ),

  languages: (
    (language: "English", fluency: "Native"),
    (language: "Irish",   fluency: "Professional Working"),
  ),

  education: (
    (
      institution: "Tallaght Institute of Technology",
      url: "https://example.edu/tit",
      studyType: "M.Sc. in Computer Science",
      startDate: ago(years: 9, precision: "year"),
      endDate: ago(years: 7, precision: "year"),
    ),
  ),

  certificates: (
    (
      name: "Certified Kubernetes Administrator",
      issuer: "CNCF",
      date: ago(years: 3),
      url: "https://www.cncf.io/training/certification/cka/",
    ),
    (
      name: "Certified Kubernetes Application Developer",
      issuer: "CNCF",
      date: ago(years: 2),
      url: "https://www.cncf.io/training/certification/ckad/",
    ),
  ),

  awards: (
    (
      title: "Best Paper — Distributed Systems Track",
      awarder: "EuroSys",
      date: ago(years: 2),
      url: "https://example.com/eurosys",
    ),
  ),

  publications: (
    (
      name: "Event Sourcing in Practice",
      publisher: "Personal Blog",
      releaseDate: ago(years: 2, precision: "day"),
      url: "https://example.com/posts/event-sourcing",
    ),
  ),

  projects: (
    (
      name: "open-source: kafka-idempotent",
      url: "https://example.com/projects/kafka-idempotent",
      description: "Small Scala library for idempotent consumers.",
      startDate: ago(years: 3),
      keywords: ("Scala", "Kafka", "OSS"),
      highlights: (
        [Underpins the awarded EuroSys paper above.],
      ),
    ),
  ),

  volunteer: (
    (
      organization: "CoderDojo Dublin",
      position: "Mentor",
      startDate: ago(years: 6),
      highlights: (
        [Weekly mentoring sessions for 10–14 year-olds learning to code.],
      ),
    ),
  ),

  interests: (
    (name: "Music", keywords: ("Trad", "Jazz")),
    (name: "Sport", keywords: ("Hurling", "Climbing")),
  ),
)
