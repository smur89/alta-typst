// The component gallery: each layout component and primitive in its
// variants, from fixed slot values rather than CV data, so a change to
// one shows in this PDF on its own. It renders under `alta()`'s own
// document setup and defaults. Headings stay plain text: inline code
// would use a system monospace font, which differs between CI's runner
// and the pinned image.

#import "../lib.typ": avatar-placeholder
#import "../internal/document.typ": _document
#import "../internal/data/defaults.typ": _default-labels, _default-preferences
#import "../internal/icons.typ": icon
#import "../internal/primitives.typ": (
  _portrait, _tag-row, divider, name, styled-link, tag, term,
)
#import "../internal/components/bibliography.typ": _bib-entry
#import "../internal/components/entry.typ": _entry
#import "../internal/components/footer.typ": _auto-page-footer
#import "../internal/components/frame.typ": _grouped-section, _section
#import "../internal/components/header.typ": _page-header
#import "../internal/components/intro.typ": _intro-block
#import "../internal/components/keywords.typ": _keyword-rows
#import "../internal/components/ratings.typ": _rating-row, rating

#show: _document.with(
  _default-preferences,
  _default-labels,
  footer: _auto-page-footer("Jane Doe", _default-labels.pageNumber),
)

#let contacts = (
  (icon: "email", value: "jane@example.com", url: "mailto:jane@example.com"),
  (icon: "location", value: "Dublin, IE", url: none),
  (
    icon: "github",
    value: "janedoe",
    url: "https://github.com/janedoe",
    alt: "GitHub",
  ),
)
// One variant per unbreakable block, spaced so neighbours stay apart.
#let variant(body) = block(breakable: false, below: 2.5em, body)
#let header = _page-header.with(
  name: "Jane Doe",
  pronouns: "she/her",
  headline: "Staff Engineer",
  contacts: contacts,
  uppercase: true,
)

= Page header: each photo placement, and centred with left text
#let portrait = _portrait(
  avatar-placeholder,
  _default-preferences.imageSize,
  "Jane Doe",
)
#for (at, text-align) in (
  ("right", left),
  ("left", left),
  ("above", center),
  ("below", center),
  ("above", left),
) {
  variant(header(photo: portrait, photo-at: at, text-align: text-align))
}

#pagebreak()

= Page header: a QR code, and a contact bar that wraps
#variant(header(qr-url: "https://example.com"))
// Each entry wraps whole: no line starts with a bare value.
#variant(header(contacts: contacts * 4))

#pagebreak()

= Intro
#_intro-block(
  objective: [Lead a platform team building reliable data systems.],
  summary: [Backend engineer with eight years of distributed systems.],
)

#pagebreak()

= Section of entries: full, with roles and tags
#_section("Entries", (1, 2), _ => _entry(
  title: "Staff Engineer",
  url: "https://example.com",
  org: "Acme",
  org-url: "https://acme.example.com",
  subtitle: "Platform team",
  roles: ("Lead", "Architect"),
  period: "Jan 2022 – Present",
  location: "Dublin, IE",
  summary: [Owns the event platform.],
  highlights: ([Cut p99 latency in half.], [Mentored four engineers.]),
  tags-lead: "First class",
  tags: ("Scala", "Kafka"),
))

= Entry: compact
#_section("Compact", (1,), _ => _entry(
  title: "Certified Kubernetes Administrator",
  url: "https://example.com",
  compact: true,
  org: "CNCF",
  details: ("CKA-123",),
  period: "Mar 2024 – Mar 2027",
  summary: [Cluster administration.],
))

= Grouped section, without dividers
#_grouped-section(
  "Grouped",
  (Books: (1,), Talks: (1, 2)),
  (key, _) => key,
  _ => _entry(title: "An item", period: "2024"),
  dividers: false,
)

= Bibliography item
#_bib-entry(
  "A Paper Title",
  url: "https://doi.org/10.1000/182",
  authors: ((name: "A. Smith", owner: false), (name: "Jane Doe", owner: true)),
  source: "ACM 12(3), 45–67",
  date: "Jun 2024",
  identifiers: (
    (name: "DOI", id: "10.1000/182", url: "https://doi.org/10.1000/182"),
  ),
  summary: [What the paper is about.],
)

= Keyword rows
#_keyword-rows((
  (name: "Languages", keywords: ("Scala", "Haskell", "Go")),
  (name: "Infra", keywords: ("Kafka", "Kubernetes")),
))

= Rating rows: dots, a half dot, and the text fallback
#_rating-row("English", 5)
#_rating-row("Irish", 3.5)
#_rating-row("German", none, fallback: "Conversational")

= Primitives
#name[Acme]
#term("2022 – 2024", location: "Remote")
#tag[Scala] #tag(label: true)[Label] #tag(trailing: false)[Last]

// A row long enough to wrap: no gap after the last pill.
#block(width: 60%, _tag-row(
  ("Scala", "Python", "Rust", "Go", "TypeScript", "Kotlin", "Java"),
))
#divider()
#rating("Default scale", 4)
#rating("Six of six", 6, max: 6)
#styled-link([A linked title], dest: "https://example.com")
#icon("book") #icon("github", alt: "GitHub")
