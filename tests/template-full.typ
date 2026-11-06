// The template path of `alta(cv)` with every section, for the
// mapping's position parity (#370): `#show: altacv`, then a CV with
// every section, two entries where a section takes them, and the
// header's every part. The right column runs onto a second page, so
// the parity covers a column breaking across pages too.

#import "../lib.typ": alta, altacv, avatar-placeholder, themes

#show: altacv.with(theme: themes.navy)

#let cv = (
  basics: (
    name: "Jane Doe",
    label: "Senior Software Engineer",
    image: avatar-placeholder,
    summary: [Backend engineer building event-driven systems.],
    email: "jane@example.com",
    phone: "+353 1 555 0100",
    location: (city: "Cork", region: "Munster", countryCode: "IE"),
    url: "https://janedoe.dev",
    profiles: (
      (
        network: "GitHub",
        username: "janedoe",
        url: "https://github.com/janedoe",
      ),
      (
        network: "LinkedIn",
        username: "janedoe",
        url: "https://linkedin.com/in/janedoe",
      ),
    ),
  ),
  objective: [Lead a platform team building reliable systems.],
  custom: (
    altacv: (
      focusAreas: (
        [Distributed systems and event sourcing.],
        [Developer experience and observability.],
      ),
    ),
  ),
  work: (
    (
      name: "Acme Corp",
      position: "Senior Software Engineer",
      location: (city: "Dublin", countryCode: "IE"),
      startDate: "2022-03",
      summary: [Platform team lead.],
      highlights: (
        [Moved settlement to an event-sourced ledger.],
        [Cut p99 latency by 40%.],
      ),
      keywords: ("Scala", "Kafka"),
    ),
    (
      name: "Globex",
      position: "Software Engineer",
      location: "Remote",
      startDate: "2018-01",
      endDate: "2022-02",
    ),
  ),
  volunteer: (
    (
      organization: "CoderDojo",
      position: "Mentor",
      startDate: "2019",
    ),
    (
      organization: "PyCon Ireland",
      position: "Organiser",
      startDate: "2017",
      endDate: "2019",
    ),
  ),
  education: (
    (
      institution: "University College Cork",
      studyType: "M.Sc.",
      area: "Computer Science",
      startDate: "2015",
      endDate: "2016",
      score: "First",
      courses: ("Distributed Systems", "Type Theory"),
    ),
    (
      institution: "Trinity College Dublin",
      area: "Computer Science",
      startDate: "2011",
      endDate: "2015",
    ),
  ),
  projects: (
    (
      name: "Hyperion",
      type: "Application",
      summary: "A task scheduler in Rust.",
      keywords: ("Rust", "Tokio"),
    ),
    (name: "kafka-idem", type: "Library"),
    (name: "dotfiles"),
  ),
  publications: (
    (
      name: "Idempotent Kafka Consumers",
      type: "article",
      publisher: "Journal of Systems",
      releaseDate: "2023-05",
      authors: ("Jane Doe", "Alex Roe"),
      volume: "12",
      issue: "3",
      pages: "45–60",
      identifiers: (doi: "10.1000/xyz123"),
    ),
    (
      name: "Event Sourcing in Practice",
      type: "talk",
      publisher: "ScalaConf",
      releaseDate: "2022-11",
      authors: ("Jane Doe",),
    ),
  ),
  skills: (
    (name: "Languages", level: "Expert", keywords: ("Scala", "Go")),
    (name: "Infra", keywords: ("Kafka", "AWS")),
  ),
  languages: (
    (language: "English", fluency: "Native"),
    (language: "French", custom: (altacv: (rating: 2.5))),
  ),
  interests: (
    (name: "Music", keywords: ("Trad", "Jazz")),
    (name: "Sport", keywords: ("Hurling",)),
  ),
  certificates: (
    (
      name: "CKA",
      issuer: "CNCF",
      date: "2023-01",
      expiryDate: "2026-01",
      credentialId: "LF-1A2B3C",
    ),
    (name: "Terraform", issuer: "HashiCorp"),
  ),
  awards: (
    (
      title: "Best Paper",
      awarder: "ScalaConf",
      date: "2023",
      custom: (altacv: (url: "https://example.com/award")),
    ),
    (title: "Dean's List"),
  ),
  references: (
    (name: "Alex Roe", reference: [Jane is a superb engineer.]),
    (availableOnRequest: true),
  ),
)

#alta(cv)
