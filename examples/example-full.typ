// The reference for a fully populated CV: every section, and as many
// features as fit, with two or three entries a section rather than
// every permutation. Distinct from `template/cv.typ` (the one-page
// canonical demo that drives `examples/cv.png` and `thumbnail.png`).
//
// What this renders:
//   • Header: photo, name (uppercase), label, objective, summary, a
//     contact bar with email, phone, a structured `basics.location`,
//     `basics.url` and three profile networks, and a QR code to the
//     homepage.
//   • `meta` populates the PDF metadata date / keywords / description.
//   • Work: open-ended + closed roles, `summary` preamble, highlights,
//     keywords.
//   • Volunteer: distinct organisation/position shape.
//   • Areas of focus: `custom.altacv.focusAreas`, a short list.
//   • Skills: two tag groups.
//   • Languages: a `fluency` string, and integer and fractional
//     half-dot `custom.altacv.rating`.
//   • Education: `studyType` + `score` + `courses`, plus the `area`
//     fallback for an entry missing `studyType`.
//   • Certificates: a full entry (link, credential ID, expiry), a dated
//     one and an issuer-only one.
//   • Awards: full entry with a `custom.altacv.url` link, plus a
//     title-only minimal entry.
//   • Projects: grouped by `type`, each group with its icon, plus an
//     untyped minimal entry under "Other".
//   • Publications: grouped by `type` code (`article`, `paper`,
//     `talk`); `paper` gets its heading and icon at the `alta()` call.
//     The paper lists `authors`, the owner set apart via `owner-names`,
//     and a DOI.
//   • Interests: structured `{name, keywords}` form.
//   • References: a populated entry plus an anonymous (no `name`)
//     quote.
//   • The template: a theme, and a page footer with the name and page
//     numbers.
//   • Preferences: short dates, custom maps provider, QR code,
//     `owner-names`, a non-default `max-rating`, custom publication and
//     project icons, and the column layout.

#import "../lib.typ": (
  alta, altacv, avatar-placeholder, cv-footer, maps-providers, themes,
)
#import "_dates.typ": ago, today

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
    // Structured location dict — `city`/`region`/`countryCode` are
    // joined with ", ", the other JSON Resume keys round-trip but
    // aren't rendered (a CV header isn't a mailing label).
    location: (
      address: "1 Sample Street",
      postalCode: "D24 X123",
      city: "Tallaght",
      region: "Dublin",
      countryCode: "IE",
    ),
    url: "https://seanomurchu.dev",
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
      (
        network: "ORCID",
        username: "0000-0002-1825-0097",
        url: "https://orcid.org/0000-0002-1825-0097",
      ),
    ),
  ),

  // A short career goal, shown in the header under the tagline.
  objective: [
    Lead a platform team building reliable, event-driven systems.
  ],

  // PDF document metadata. `lastModified` accepts a bare ISO date or
  // a full timestamp; only the calendar part is used for `set
  // document(date:)`, and it surfaces optionally in a page footer,
  // `cv-updated-footer()`. `canonical` and `version` have no dedicated
  // Typst document field, so they append to the PDF Keywords (and
  // `version` can suffix that footer: `cv-updated-footer(version: true)`).
  meta: (
    canonical: "https://example.com/cv.json",
    version: "v1.0.0",
    lastModified: today.display("[year]-[month]-[day]"),
  ),

  custom: (
    altacv: (
      focusAreas: (
        [Distributed systems: Kafka, CDC, idempotent consumers, event sourcing.],
        [Functional programming and type-driven design in Scala and Haskell.],
        [Developer experience: tooling, CI/CD, observability.],
      ),
    ),
  ),

  work: (
    (
      name: "Acme Corp",
      url: "https://acme.example.com",
      position: "Senior Software Engineer",
      location: "Dublin, Ireland",
      startDate: ago(years: 4),
      // `endDate` omitted → renders as "Present".
      summary: [Platform team lead. Owns the event-sourcing stack
        underpinning the wider product surface.],
      highlights: (
        [Led the migration of a customer-facing monolith into a set of
          event-driven microservices, halving p99 latency.],
        [Designed and rolled out an event-sourcing platform now used by
          four product teams.],
        [Mentored three engineers from mid to senior level.],
      ),
      keywords: ("Scala", "Go", "Kafka", "Kubernetes"),
    ),
    (
      name: "Liffey Labs",
      position: "Software Engineer",
      location: "Remote",
      startDate: ago(years: 7),
      endDate: ago(years: 5),
      highlights: (
        [Built and shipped the first version of a SaaS product from
          scratch alongside a two-person team.],
        [Introduced the CI/CD pipeline and developer-onboarding flow
          that scaled the engineering org from 3 to 15.],
      ),
      keywords: ("Python", "Go", "AWS", "GitHub Actions"),
    ),
  ),

  volunteer: (
    (
      organization: "CoderDojo Dublin",
      url: "https://coderdojo.com",
      position: "Mentor",
      startDate: ago(years: 6),
      summary: [Volunteer-led coding club introducing young people to programming.],
      highlights: (
        [Weekly mentoring sessions for 10–14 year-olds learning to code.],
        [Curate the Scala / functional-programming track.],
      ),
    ),
  ),

  skills: (
    (name: "Languages", keywords: ("Scala", "Haskell", "Python", "Go", "Rust")),
    (
      name: "Infra",
      keywords: ("Kafka", "AWS", "Terraform", "Docker", "Kubernetes"),
    ),
  ),

  // Languages exercise every supported input: a named `fluency` string
  // and numeric `custom.altacv.rating` (with fractional half-dot
  // precision).
  languages: (
    (language: "English", fluency: "Native"),
    (language: "French", custom: (altacv: (rating: 4))),
    (language: "Portuguese", custom: (altacv: (rating: 2.5))),
  ),

  education: (
    (
      // Full entry with `studyType`, `score`, and `courses` tags.
      institution: "Tallaght Institute of Technology",
      url: "https://example.edu/tit",
      studyType: "M.Sc. in Computer Science",
      startDate: ago(years: 9, precision: "year"),
      endDate: ago(years: 7, precision: "year"),
      score: "Distinction",
      courses: ("Distributed Systems", "Type Theory", "Concurrency"),
    ),
    (
      // `area` fallback used when `studyType` is absent; no score.
      institution: "Trinity College Dublin",
      area: "Computer Science",
      startDate: ago(years: 12, precision: "year"),
      endDate: ago(years: 9, precision: "year"),
    ),
  ),

  // A full entry (link, credential ID, expiry, so the date is a
  // range), a dated entry, and an issuer-only one.
  certificates: (
    (
      name: "Certified Kubernetes Administrator",
      issuer: "CNCF",
      date: ago(months: 34),
      expiryDate: ago(months: -2),
      credentialId: "LF-1A2B3C4D5E",
      url: "https://www.cncf.io/training/certification/cka/",
    ),
    (
      name: "AWS Solutions Architect — Professional",
      issuer: "AWS",
      date: ago(months: 38),
    ),
    (
      name: "Hashicorp Terraform Associate",
      issuer: "Hashicorp",
    ),
  ),

  // Full entry with a `custom.altacv.url` link, plus a title-only minimal entry to
  // demonstrate the all-optional surface.
  awards: (
    (
      title: "Best Paper Award",
      date: ago(months: 21),
      awarder: "ScalaConf",
      custom: (altacv: (url: "https://example.com/awards/scalaconf")),
      summary: [For _Idempotent Kafka Consumers_.],
    ),
    (
      title: "Dean's List",
    ),
  ),

  // Two typed groups, each under its icon, and an untyped minimal
  // entry under "Other".
  projects: (
    (
      name: "Hyperion",
      type: "Application",
      entity: "Acme Corp",
      summary: "Distributed task scheduler in Rust",
      startDate: ago(months: 29),
      endDate: ago(months: 22),
      url: "https://github.com/seanomurchu/hyperion",
      roles: ("Lead", "Architect"),
      keywords: ("Rust", "Tokio", "gRPC"),
      highlights: (
        [Handled 10k tasks/s on a single node.],
        [Designed an idempotent retry protocol.],
      ),
    ),
    (
      // Distinct `type` → its own "Library" subheading.
      name: "Tinkerbell",
      type: "Library",
      summary: "Tiny IRC bot",
      keywords: ("Lua",),
    ),
    (
      // Minimal + untyped — only the required field, so it falls under
      // the "Other" bucket after the typed groups.
      name: "Quill",
    ),
  ),

  // Structured `{name, keywords}` shape — same as `skills[]` but
  // semantically a personal-interests block. Coexists with the prose
  // `focusAreas` block above.
  interests: (
    (name: "Music", keywords: ("Trad", "Jazz")),
    (name: "Sport", keywords: ("Hurling", "Climbing")),
  ),

  // Populated entry + an anonymous (no `name`) quote — exercises both
  // the named-referee path and the fallback-to-bare-quote path.
  references: (
    (
      name: "Dr Ada Lovelace",
      reference: [
        Seán is a calm, methodical engineer who left every system he
        touched in a better state than he found it. Recommended without
        reservation.
      ],
    ),
    (
      reference: "Pragmatic, curious, unfailingly kind — would hire again in a heartbeat.",
    ),
  ),

  // Three groups by `type` code: `article`, `paper`, `talk`. `paper`
  // isn't a built-in code, so the `alta()` call below names its heading
  // (`labels.publication-types`) and icon (`preferences.publication-icons`).
  // The paper lists its `authors`, the owner's entry set apart by
  // matching `preferences.owner-names`, and a DOI.
  publications: (
    (
      name: "Event Sourcing in Practice",
      type: "article",
      publisher: "Personal Blog",
      releaseDate: ago(years: 2, precision: "day"),
      url: "https://example.com/posts/event-sourcing",
      summary: [A walk-through of idempotent Kafka consumers and the
        replay strategy that ships with them.],
    ),
    (
      name: "Idempotent Kafka Consumers at Scale",
      type: "paper",
      publisher: "EuroSys",
      releaseDate: ago(months: 26),
      authors: ("A. Lovelace", "S. Ó Murchú", "G. Hopper"),
      identifiers: (doi: "10.1000/182"),
    ),
    (
      name: "Designing for Failure",
      type: "talk",
      publisher: "ScalaIO",
      releaseDate: ago(months: 33),
      url: "https://example.com/talks/failure",
    ),
  ),
)

// The template's theme and footer, and the preferences listed in the
// header comment.
#show: altacv.with(theme: themes.navy)
#set page(footer: cv-footer())

//
// `interests` is moved into the left column to fill space below the
// long-form blocks; the rest of the layout takes the shipped defaults.
#alta(
  cv,
  labels: (publication-types: (paper: "Conference Papers")),
  preferences: (
    publication-icons: (paper: "newspaper"),
    project-icons: (application: "laptop-code", library: "cubes"),
    date-format: "[day padding:none] [month repr:short] [year]",
    maps-provider: maps-providers.osm,
    qr-code: auto,
    owner-names: ("S. Ó Murchú",),
    max-rating: 6,
    left-column-sections: (
      "work",
      "volunteer",
      "projects",
      "publications",
      "interests",
    ),
    right-column-sections: (
      "focus-areas",
      "skills",
      "languages",
      "education",
      "certificates",
      "awards",
      "references",
    ),
  ),
)
