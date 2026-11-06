// Starter CV produced by `typst init @preview/altacv`. Edit in place.
//
// The full data schema is documented in the package README:
//   https://github.com/smur89/alta-typst#data-schema
//
// Every field below is optional except `basics.name`. Sections with
// empty input are skipped, so deleting an entry is enough to hide it.
//
// This file is also the canonical demo for the project — what
// renders as `examples/cv.png` (reviewer artifact and release asset), as
// `thumbnail.png` (Typst Universe package card), and as the data
// behind every frame of `examples/preview.webp` (via
// `examples/_cv.typ`).

// x-release-please-start-version
#import "@preview/altacv:1.8.0": (
  alta, alta-from-json, altacv, avatar-placeholder,
)
// x-release-please-end

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
    // Replace with your own: `path("your-photo.png")` for a local
    // file, `none` to drop the portrait, or keep `avatar-placeholder`
    // (the built-in silhouette).
    image: avatar-placeholder,
    profiles: (
      (
        network: "GitHub",
        username: "seanomurchu",
        url: "https://github.com/seanomurchu",
      ),
      (
        network: "LinkedIn",
        username: "seanomurchu",
        url: "https://linkedin.com/in/seanomurchu",
      ),
    ),
  ),

  // A short career goal, shown in the header under the tagline.
  objective: [
    Lead a platform team building reliable, event-driven systems.
  ],

  custom: (
    altacv: (
      focusAreas: (
        [Distributed systems and functional programming.],
      ),
    ),
  ),

  work: (
    (
      name: "Acme Corp",
      url: "https://acme.example.com",
      position: "Senior Software Engineer",
      location: "Dublin, Ireland",
      startDate: "2022-01",
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
      startDate: "2019-06",
      endDate: "2022-01",
      highlights: (
        [Shipped the first version of a SaaS product alongside a two-person team.],
        [Built the CI/CD pipeline that scaled the engineering org from 3 to 15.],
      ),
    ),
  ),

  skills: (
    (name: "Languages", keywords: ("Scala", "Haskell", "Go")),
    (name: "Infra", keywords: ("Kafka", "AWS", "Kubernetes")),
  ),

  languages: (
    (language: "English", fluency: "Native"),
    (language: "Irish", fluency: "Professional Working"),
  ),

  education: (
    (
      institution: "Tallaght Institute of Technology",
      url: "https://example.edu/tit",
      studyType: "M.Sc. in Computer Science",
      startDate: "2015",
      endDate: "2017",
    ),
  ),

  certificates: (
    (
      name: "Certified Kubernetes Administrator",
      issuer: "CNCF",
      date: "2023-09",
      url: "https://www.cncf.io/training/certification/cka/",
    ),
  ),

  awards: (
    (
      title: "Best Paper — Distributed Systems Track",
      awarder: "EuroSys",
      date: "2024-09",
      custom: (altacv: (url: "https://example.com/eurosys")),
    ),
  ),

  publications: (
    (
      name: "Event Sourcing in Practice",
      publisher: "Personal Blog",
      releaseDate: "2024-06-15",
      url: "https://example.com/posts/event-sourcing",
    ),
  ),

  projects: (
    (
      name: "open-source: kafka-idempotent",
      url: "https://example.com/projects/kafka-idempotent",
      summary: "Small Scala library for idempotent consumers.",
      startDate: "2023-04",
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
      startDate: "2020-09",
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

// Visual preferences for this starter. The portrait stacks above a
// centred header; the rest takes the template's shipped defaults
// (teal accent, two-column layout, long-form dates). Edit any
// preference you like — `alta(cv, preferences: (...))` accepts any
// subset, with unknown keys panicking so typos surface immediately.
#let preferences = (
  image-position: top,
  header-text-align: center,
)

// The template, then your own rules (they win), then the CV:
// `#set page(paper: "us-letter")`, `#set text(lang: "de")`, … .
#show: altacv.with()

#alta(cv, preferences: preferences)

// Or load the same CV from JSON Resume: `resume.json`, beside this
// file, holds it in the standard schema (https://jsonresume.org), so
// any JSON Resume tool can write it. It has no photo: the one above is
// set in Typst (`basics.image`).
// #alta-from-json(path("resume.json"), preferences: preferences)
//
// To go further: write sections of your own in markup after the CV,
// or copy the mapping `alta()` draws with and change how a section
// looks. The README covers both ("Write the CV in markup", "Your own
// mapping").
