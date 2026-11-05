// A CV written in markup, with no data dictionary: the name from
// `set document(title: ..)` shown by `cv-header` with a portrait and
// QR code, a two-column `grid`, `=` sections, a `==` group, and the
// blocks: `entry` (dividers only between entries), `publication`
// (the document's author set apart), `skills` (one row's level as
// dots), `rating` and `label-row`.

#import "../lib.typ": (
  alta-footer, altacv, avatar-placeholder, contact, cv-header, entry,
  label-row, publication, rating, skills, themes,
)

#set document(title: "Jane Doe", author: "Jane Doe")
#show: altacv.with(theme: themes.navy)
#set page(footer: alta-footer())

#cv-header(
  tagline: "Senior Software Engineer",
  objective: [Building reliable distributed systems for small teams.],
  contacts: (
    contact("email", "jane@example.com", link: "mailto:jane@example.com"),
    contact("location", "Dublin, Ireland"),
    contact("github", "janedoe", link: "https://github.com/janedoe"),
  ),
  photo: image(avatar-placeholder),
  qr: "https://example.com",
)

#grid(
  columns: (2fr, 1fr),
  column-gutter: 12pt,
  [
    = Experience

    #entry(
      title: "Senior Software Engineer",
      org: "Acme Corp",
      roles: ("Tech Lead",),
      date: "2022 – Present",
      location: "Dublin, Ireland",
      keywords: ("Scala", "Kafka", "AWS"),
    )[
      Leads the payments platform team of six.

      - Moved settlement to an event-sourced ledger.
      - Cut p99 latency by 40%.
    ]

    #entry(
      title: "Software Engineer",
      org: "Globex",
      date: "2018 – 2022",
      location: "Cork, Ireland",
    )[Built the customer data pipeline.]

    = Publications

    == Talks

    #publication(
      title: "Event Sourcing in Practice",
      authors: ("Jane Doe", "John Smith"),
      source: "ScalaDays",
      date: "2024",
      identifiers: (doi: "10.1234/example.5678"),
    )[]

    #publication(
      title: "Ledgers at Scale",
      authors: ("Alex Kim", "Jane Doe"),
      source: "Kafka Summit",
      date: "2023",
    )[]
  ],
  [
    = Skills

    #skills("Languages", ("Scala", "Python", "Go"), level: "Expert")
    #skills("Infra", ("Kafka", "AWS", "Kubernetes"))

    = Languages

    #rating("English", 5)
    #rating("Irish", 3)

    = Interests

    #label-row("Music", ("Trad", "Jazz"))
  ],
)
