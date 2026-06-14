// Starter CV produced by `typst init @preview/altacv`. Edit in place.
//
// The full data schema is documented in the package README:
//   https://github.com/smur89/alta-typst#data-schema
//
// Every field below is optional except `basics.name`. Sections with
// empty input are skipped, so deleting an entry is enough to hide it.

#import "@preview/altacv:1.0.0": alta // x-release-please-version

#let cv = (
  basics: (
    name: "Jane Doe",
    label: "Senior Software Engineer",
    summary: [Backend engineer with eight years' experience designing distributed, event-driven systems.],
    email: "jane@example.com",
    phone: "+353 1 555 0100",
    location: "Dublin, Ireland",
    url: "https://janedoe.dev",
    profiles: (
      (network: "LinkedIn", username: "janedoe", url: "https://linkedin.com/in/janedoe"),
      (network: "GitHub",   username: "janedoe", url: "https://github.com/janedoe"),
    ),
  ),

  work: (
    (
      name: "Acme Corp",
      url: "https://acme.example.com",
      position: "Senior Software Engineer",
      location: "Dublin, Ireland",
      startDate: "2022-01",
      // omit endDate → renders as "Present"
      highlights: (
        [Led the migration of a monolith to event-driven services, halving p99 latency.],
        [Designed an event-sourcing platform now used by four product teams.],
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
      ),
    ),
  ),

  skills: (
    (name: "Languages", keywords: ("Scala", "Python", "Go")),
    (name: "Infra",     keywords: ("Kafka", "AWS", "Kubernetes")),
  ),

  languages: (
    (language: "English", fluency: "Native"),
    (language: "Irish",   fluency: "Professional Working"),
  ),

  education: (
    (
      institution: "Trinity College Dublin",
      studyType: "M.Sc. in Computer Science",
      startDate: "2017",
      endDate: "2019",
    ),
  ),
)

#alta(cv)
