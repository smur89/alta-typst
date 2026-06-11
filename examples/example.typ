// Minimal demonstration of the altacv template. Renders a fictional
// CV that exercises every section the template supports.
//
// Build locally with:
//   typst compile --root .. example.typ example.pdf
//
// Or, after installing the package as @local/altacv:0.1.0:
//   #import "@local/altacv:0.1.0": alta

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
    profiles: (
      (network: "LinkedIn", username: "janedoe", url: "https://linkedin.com/in/janedoe"),
      (network: "Medium",   username: "janedoe", url: "https://medium.com/@janedoe"),
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
      name: "ShamrockTech",
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
  ),

  skills: (
    (name: "Languages", keywords: ("Scala", "Haskell", "Python", "Go")),
    (name: "Infra",     keywords: ("Kafka", "AWS", "Terraform", "Docker", "Kubernetes")),
    (name: "Databases", keywords: ("PostgreSQL", "Redis", "Elasticsearch")),
  ),

  languages: (
    (language: "English", fluency: "Native"),
    (language: "Irish",   fluency: "Professional Working"),
    (language: "German",  fluency: "Elementary"),
  ),

  education: (
    (
      institution: "Example University",
      studyType: "M.Sc. in Computer Science",
      startDate: "2017",
      endDate: "2019",
      score: "Distinction",
    ),
    (
      institution: "Example University",
      studyType: "B.Sc. in Computer Science",
      startDate: "2014",
      endDate: "2017",
    ),
  ),

  certificates: (
    (name: "AWS Certified Solutions Architect — Professional", issuer: "Amazon Web Services"),
    (name: "Certified Kubernetes Administrator",               issuer: "CNCF"),
  ),

  publications: (
    (
      name: "Event Sourcing in Practice",
      publisher: "Personal Blog",
      releaseDate: "Jun 2024",
      url: "https://example.com/posts/event-sourcing",
    ),
    (
      name: "Functional Patterns for Distributed Systems",
      publisher: "Personal Blog",
      releaseDate: "Nov 2023",
      url: "https://example.com/posts/fp-distributed",
    ),
  ),
)

#alta(cv)
