// Canonical "inverted template" layout: the side-panel sections
// (focus areas, skills, languages, education, certificates) move to
// a narrow left column; the experience block + publications take the
// wide right column. Halving `columnRatio` from the default 0.64 to
// 0.36 swaps which column is the wide one; rearranging
// `leftColumnSections` / `rightColumnSections` decides what lives
// where. Uses a real-shape CV (multiple work entries, multiple skill
// categories, a publication) so the rendered output is a meaningful
// reference for the inverted layout.

#import "../lib.typ": alta

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
      profiles: (
        (network: "LinkedIn", username: "janedoe", url: "https://linkedin.com/in/janedoe"),
        (network: "GitHub",   username: "janedoe", url: "https://github.com/janedoe"),
      ),
    ),

    focusAreas: (
      [Distributed systems and event sourcing.],
      [Functional programming in Scala and Haskell.],
      [Developer experience and observability.],
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
    columnRatio: 0.36,
    // Side-panel sections take the narrow left column.
    leftColumnSections: ("focusAreas", "skills", "languages", "education", "certificates"),
    // Experience + publications take the wide right column.
    rightColumnSections: ("work", "publications"),
  ),
)
