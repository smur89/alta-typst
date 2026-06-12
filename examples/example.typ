// Demonstration of the altacv template. Renders a one-page fictional
// CV exercising the main sections. The publications section is
// covered by tests/publication_types.typ.
//
// Build locally with:
//   typst compile --root .. example.typ example.pdf

#import "../lib.typ": alta

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
    image: read("avatar-placeholder.svg", encoding: none),
    profiles: (
      (network: "LinkedIn", username: "seanomurchu",     url: "https://linkedin.com/in/seanomurchu"),
      (network: "GitHub",   username: "seanomurchu",     url: "https://github.com/seanomurchu"),
      (network: "Website",  username: "seanomurchu.dev", url: "https://seanomurchu.dev"),
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
      // endDate omitted → renders as "Present"
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
    (
      name: "Grand Canal Systems",
      position: "Software Engineer",
      location: "Dublin, Ireland",
      startDate: "Aug 2017",
      endDate: "May 2019",
      highlights: (
        [Built internal tooling adopted by the wider engineering org.],
        [Led the migration of services from VMs to containerised
          deployments on Kubernetes.],
      ),
    ),
    (
      name: "Pembroke Software",
      position: "Software Engineering Intern",
      location: "Dublin, Ireland",
      startDate: "May 2016",
      endDate: "Jul 2017",
      highlights: (
        [Maintained a legacy reporting service serving daily
          extracts to enterprise customers across two pricing tiers.],
        [Automated a manual release process previously taking half
          a day, freeing the team for higher-leverage work.],
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
      url: "https://example.edu",
      studyType: "M.Sc. in Computer Science",
      startDate: "2017",
      endDate: "2019",
      score: "Distinction",
    ),
    (
      institution: "Example University",
      url: "https://example.edu",
      studyType: "B.Sc. in Computer Science",
      startDate: "2014",
      endDate: "2017",
    ),
  ),

  certificates: (
    (name: "Certified Kubernetes Administrator", issuer: "CNCF"),
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
