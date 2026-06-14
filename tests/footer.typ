// `preferences.pageFooter` — two documents covering the API surface:
//
//   1. `"auto"` on a multi-page CV — emits name + "Page N / M" on
//      every page. The auto renderer reactively reads the final page
//      counter, so growth in the body propagates without any caller
//      change.
//   2. A user-supplied content footer — rendered verbatim on every
//      page, regardless of page count. Demonstrates the escape hatch
//      for callers who want a custom footer (e.g. a confidentiality
//      notice).
//
// Single-page suppression is a document-level property and cannot be
// isolated inside a multi-`alta()` fixture (every `alta()` call shares
// the document's `counter(page).final()`), so it is exercised
// implicitly: every other fixture compiles a single-page CV without
// the footer enabled, and the default for `pageFooter` is `none`.

#import "../lib.typ": alta

#let role(name, position, start, end, highlights) = (
  name: name,
  position: position,
  location: "Dublin, Ireland",
  startDate: start,
  endDate: end,
  highlights: highlights,
)

// Multi-page with "auto" footer.
#alta(
  (
    basics: (
      name: "Jane Doe",
      label: "Staff Software Engineer",
      summary: [
        Long CV that overflows a single page so the auto footer
        renders "Page N / M" with N spanning more than one value.
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
      (institution: "Trinity College Dublin", studyType: "M.Sc. in Computer Science",
        startDate: "2017", endDate: "2019", score: "Distinction"),
      (institution: "Trinity College Dublin", studyType: "B.Sc. in Computer Science",
        startDate: "2014", endDate: "2017", score: "First Class Honours"),
    ),
    certificates: (
      (name: "Certified Kubernetes Administrator", issuer: "CNCF"),
      (name: "AWS Solutions Architect — Professional", issuer: "AWS"),
      (name: "Hashicorp Terraform Associate", issuer: "Hashicorp"),
    ),
  ),
  preferences: (pageFooter: "auto"),
)

#pagebreak()

// User-supplied content footer — rendered verbatim on every page.
#alta(
  (
    basics: (
      name: "Custom Footer User",
      label: "Verbatim content footer",
      email: "custom@example.com",
    ),
    work: (
      role("Acme Corp", "Engineer", "Jan 2024", none, (
        [Custom footer renders on every page regardless of page count.],
      )),
    ),
  ),
  preferences: (
    pageFooter: align(center, text(0.8em, fill: rgb("#888888"), [Confidential — do not distribute])),
  ),
)
