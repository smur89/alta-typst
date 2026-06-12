// Long CV that intentionally overflows a single page so the template's
// breakable / sticky behaviour gets exercised: section headings stay
// with their first entry, individual work entries stay together, and
// the dashed dividers between entries flow naturally across pages.

#import "../lib.typ": alta

#let role(name, position, start, end, highlights) = (
  name: name,
  position: position,
  location: "Dublin, Ireland",
  startDate: start,
  endDate: end,
  highlights: highlights,
)

#alta((
  basics: (
    name: "Jane Doe",
    label: "Staff Software Engineer",
    summary: [
      Two decades of platform engineering across payments, logistics,
      and developer tools. This fixture deliberately overflows a single
      page to exercise the template's page-break behaviour.
    ],
    email: "jane@example.com",
    location: "Dublin, Ireland",
  ),
  work: (
    role("Acme Corp", "Staff Engineer", "Jan 2022", none, (
      [Led the migration of a customer-facing monolith into a set of
        event-driven microservices, halving p99 latency.],
      [Designed and rolled out an event-sourcing platform now used by
        four product teams across two business units.],
      [Mentored three engineers from mid to senior level and one from
        senior to staff.],
      [Owned the platform architecture review process and chaired the
        cross-team RFC forum.],
    )),
    role("Liffey Labs", "Senior Engineer", "Jun 2019", "Dec 2021", (
      [Built and shipped the first version of a SaaS product from
        scratch alongside a two-person team.],
      [Introduced the CI/CD pipeline and developer-onboarding flow that
        scaled the engineering org from 3 to 15 in eighteen months.],
      [Designed the data model and migration strategy for a multi-tenant
        rewrite that ran without downtime.],
    )),
    role("Grand Canal Systems", "Software Engineer", "Aug 2017", "May 2019", (
      [Built internal tooling adopted by the wider engineering org,
        including a code-review bot and a deploy dashboard.],
      [Led the migration of services from VMs to containerised
        deployments on Kubernetes across three environments.],
    )),
    role("Pembroke Software", "Software Engineering Intern", "May 2016", "Jul 2017", (
      [Maintained a legacy reporting service serving daily extracts to
        enterprise customers.],
      [Automated a manual release process previously taking half a day.],
    )),
    role("Trinity College Dublin", "Research Assistant", "Sep 2015", "Apr 2016", (
      [Implemented a benchmark harness for evaluating distributed
        consensus protocols across cloud providers.],
      [Co-authored two workshop papers on quorum-based replication.],
    )),
    role("Iveagh Analytics", "Junior Engineer", "Jun 2014", "Aug 2015", (
      [Built an ETL pipeline ingesting 50M rows/day into Redshift.],
      [Owned the on-call rotation for the data platform.],
    )),
    role("Phoenix Studios", "Software Engineering Intern", "May 2013", "Aug 2013", (
      [Maintained an iOS game's backend leaderboard service.],
    )),
    role("Howth Robotics", "Software Engineering Intern", "Jun 2012", "Aug 2012", (
      [Wrote firmware drivers for a line of educational robotics kits.],
    )),
  ),
  skills: (
    (name: "Languages",  keywords: ("Scala", "Haskell", "Python", "Go", "TypeScript")),
    (name: "Infra",      keywords: ("Kafka", "AWS", "Terraform", "Docker", "Kubernetes", "Linkerd")),
    (name: "Practices",  keywords: ("TDD", "DDD", "Event sourcing", "Pair programming")),
  ),
  education: (
    (
      institution: "Trinity College Dublin",
      studyType: "M.Sc. in Computer Science",
      startDate: "2017",
      endDate: "2019",
      score: "Distinction",
    ),
    (
      institution: "Trinity College Dublin",
      studyType: "B.Sc. in Computer Science",
      startDate: "2014",
      endDate: "2017",
      score: "First Class Honours",
    ),
  ),
  certificates: (
    (name: "Certified Kubernetes Administrator", issuer: "CNCF"),
    (name: "Certified Kubernetes Application Developer", issuer: "CNCF"),
    (name: "AWS Solutions Architect — Professional", issuer: "AWS"),
    (name: "AWS DevOps Engineer — Professional", issuer: "AWS"),
    (name: "Hashicorp Terraform Associate", issuer: "Hashicorp"),
  ),
  publications: (
    (
      name: "Event Sourcing in Practice", type: "Articles",
      releaseDate: "Jun 2024", url: "https://example.com/posts/event-sourcing",
    ),
    (
      name: "Idempotent Kafka Consumers", type: "Articles",
      releaseDate: "Mar 2024", url: "https://example.com/posts/idempotent-consumers",
    ),
    (
      name: "Designing for Failure", type: "Talks",
      releaseDate: "Sep 2023", url: "https://example.com/talks/failure",
    ),
  ),
))
