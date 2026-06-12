// Multi-page demonstration that exercises every section the template
// supports — useful as a reference for a fuller CV and as a render
// target for features that don't fit inside the one-page
// `example.typ`. Free to overflow onto a second page.
//
// Build locally with:
//   typst compile --root .. example_full.typ example_full.pdf

#import "../lib.typ": alta

#let cv = (
  basics: (
    name: "Jane Doe",
    label: "Senior Software Engineer",
    summary: [
      Backend engineer with eight years of experience designing
      distributed, event-driven systems. Specialises in functional
      programming, observability, and developer experience.
    ],
    email: "jane@example.com",
    phone: "+353 1 555 0100",
    location: "Dublin, Ireland",
    image: read("avatar-placeholder.svg", encoding: none),
    profiles: (
      (network: "LinkedIn", username: "janedoe",     url: "https://linkedin.com/in/janedoe"),
      (network: "GitHub",   username: "janedoe",     url: "https://github.com/janedoe"),
      (network: "Website",  username: "janedoe.dev", url: "https://janedoe.dev"),
    ),
  ),

  focusAreas: (
    [Distributed systems: Kafka, CDC, idempotent consumers, event sourcing.],
    [Functional programming and type-driven design in Scala and Haskell.],
    [Developer experience: tooling, CI/CD, observability.],
    [Engineering culture: ADRs, RFCs, mentoring.],
  ),

  work: (
    (
      name: "Acme Corp",
      position: "Senior Software Engineer",
      location: "Dublin, Ireland",
      startDate: "Jan 2022",
      highlights: (
        [Led the migration of a customer-facing monolith into a set of
          event-driven microservices, halving p99 latency.],
        [Designed and rolled out an event-sourcing platform now used by
          four product teams.],
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
    (name: "Languages", keywords: ("Scala", "Haskell", "Python", "Go")),
    (name: "Infra",     keywords: ("Kafka", "AWS", "Terraform", "Docker", "Kubernetes")),
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

  awards: (
    (
      title: "Best Paper Award",
      date: "Sep 2024",
      awarder: "ScalaConf",
      summary: [For _Idempotent Kafka Consumers_.],
    ),
  ),

  publications: (
    (
      name: "Event Sourcing in Practice",
      publisher: "Personal Blog",
      releaseDate: "Jun 2024",
      url: "https://example.com/posts/event-sourcing",
    ),
  ),
)

#alta(cv)
