// `preferences.left-column-sections` and `preferences.right-column-sections`
// control which sections render in which column, and in what order.
// Sections are placeable in either column; section renderers are
// width-agnostic so they adapt to wherever they land.
//
// Four documents exercise the API surface:
//   1. Reversed right-column order (default left column).
//   2. Subset (only `skills` + `education` on the right).
//   3. The inverted layout: the side-panel sections (focus areas,
//      skills, languages, education, certificates) move to a narrow
//      left column, and the experience block + publications take the
//      wide right column. The complement of the default `column-ratio`
//      (0.35 instead of 0.65) swaps which column is the wide one, and
//      the photo moves to the left with it. A real-shape CV (several
//      work entries and skill categories, a publication) so the page
//      is a meaningful reference for the layout.
//   4. Both columns empty — only the header renders.

#import "../lib.typ": alta

#let cv = (
  basics: (name: "Jane Doe", email: "jane@example.com"),
  custom: (altacv: (focusAreas: ([Item one.], [Item two.]))),
  work: (
    (
      name: "Acme",
      position: "Engineer",
      startDate: "Jan 2022",
      highlights: ([Did work.],),
    ),
  ),
  skills: ((name: "Lang", keywords: ("Scala",)),),
  languages: ((language: "English", fluency: "Native"),),
  education: (
    (institution: "Example U", studyType: "B.Sc.", endDate: "2017"),
  ),
  certificates: ((name: "CKA", issuer: "CNCF"),),
  publications: (
    (name: "Article", releaseDate: "Jun 2024", url: "https://example.com"),
  ),
)

// 1. Reversed right-column order; left stays at its default (work).
#alta(cv, preferences: (
  right-column-sections: (
    "publications",
    "certificates",
    "education",
    "languages",
    "skills",
    "focus-areas",
  ),
))

#pagebreak()

// 2. Subset on the right.
#alta(cv, preferences: (
  right-column-sections: ("skills", "education"),
))

#pagebreak()

// 3. Inverted layout, on its own fuller CV: side-panel sections move to
//    the (now narrower) left column, work to the (now wider) right one.
#alta(
  (
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
      // Photo placed on the LEFT to match the column inversion below.
      image: read("../assets/avatar-placeholder.svg", encoding: none),
      profiles: (
        (
          network: "LinkedIn",
          username: "janedoe",
          url: "https://linkedin.com/in/janedoe",
        ),
        (
          network: "GitHub",
          username: "janedoe",
          url: "https://github.com/janedoe",
        ),
      ),
    ),

    custom: (
      altacv: (
        focusAreas: (
          [Distributed systems and event sourcing.],
          [Functional programming in Scala and Haskell.],
          [Developer experience and observability.],
        ),
      ),
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
          [Designed and rolled out an event-sourcing platform now used
            by four product teams.],
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
          [Built and shipped the first version of a SaaS product from
            scratch alongside a two-person team.],
          [Introduced the CI/CD pipeline and developer-onboarding flow
            that scaled the engineering org from 3 to 15.],
        ),
      ),
    ),

    skills: (
      (name: "Languages", keywords: ("Scala", "Haskell", "Python")),
      (name: "Infra", keywords: ("Kafka", "AWS", "Kubernetes")),
    ),

    languages: (
      (language: "English", fluency: "Native"),
      (language: "Irish", fluency: "Professional Working"),
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
    ),

    publications: (
      (
        name: "Event Sourcing in Practice",
        releaseDate: "Jun 2024",
        url: "https://example.com/posts/event-sourcing",
      ),
    ),
  ),
  preferences: (
    // Halve the left-column fraction so the (now side-panel) left
    // column becomes the narrow one and the (now experience) right
    // column gets the wider share.
    column-ratio: 0.35,
    // Photo flips to the left as part of the inverted layout. The
    // default left-aligned header text keeps every line starting at
    // a consistent edge regardless of the photo position.
    photo-position: left,
    // Side-panel sections take the narrow left column.
    left-column-sections: (
      "focus-areas",
      "skills",
      "languages",
      "education",
      "certificates",
    ),
    // Experience + publications take the wide right column.
    right-column-sections: ("work", "publications"),
  ),
)

#pagebreak()

// 4. Both columns empty — header only.
#alta(cv, preferences: (
  left-column-sections: (),
  right-column-sections: (),
))
