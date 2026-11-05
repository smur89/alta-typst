// A CV written in markup that runs to several pages: 40 entries over
// four `=` sections, one with `==` groups. Each entry's divider depends
// on a query (another entry under the same heading before it) and on
// its position (none at a page top), so a long CV is where the two
// could keep relaying out: `make check` fails on Typst's "did not
// converge" warning.

#import "../lib.typ": altacv, contact, cv-header, entry, themes

#set document(title: "Jane Doe", author: "Jane Doe")
#show: altacv.with(theme: themes.navy)

#cv-header(
  tagline: "Senior Software Engineer",
  contacts: (
    contact("email", "jane@example.com", link: "mailto:jane@example.com"),
  ),
)

// `count` entries, some with highlights or keywords, so their heights
// vary and page breaks fall between and beside the dividers.
#let entries(count, title, org) = for i in range(count) {
  entry(
    title: title + " " + str(count - i),
    org: org,
    date: str(2024 - i) + " – " + str(2025 - i),
    location: "Dublin, Ireland",
    keywords: if calc.rem(i, 3) == 0 { ("Scala", "Kafka", "AWS") } else {
      ()
    },
  )[
    Worked on the payments platform.

    #if calc.rem(i, 2) == 0 [
      - Moved settlement to an event-sourced ledger.
      - Cut p99 latency by 40%.
    ]
  ]
}

= Experience

#entries(12, "Engineer", "Acme Corp")

= Education

#entries(8, "Course", "Trinity College Dublin")

= Projects

== Open source

#entries(6, "Library", "GitHub")

== Internal

#entries(6, "Service", "Acme Corp")

= Volunteering

#entries(8, "Mentor", "CoderDojo")
