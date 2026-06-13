// JSON Resume `work[].summary` (and the related `description` field
// used by some exporters). Both render as an italic paragraph between
// the term row and the highlights list; `summary` wins when both are
// supplied. Fixture covers: content-form summary, plain-string summary,
// description-only (fallback), summary+description (summary wins),
// and the empty-string / `none` skip cases.

#import "../lib.typ": alta

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  work: (
    (
      name: "Acme Corp",
      position: "Senior Software Engineer",
      location: "Dublin, Ireland",
      startDate: "Jan 2022",
      // Content-form summary so markup (emphasis) renders, not just
      // plain text. Mirrors `awards[].summary`.
      summary: [Owned the platform team's _event-sourcing_ stack.],
      highlights: (
        [Halved p99 latency on the checkout path.],
        [Mentored three engineers from mid to senior level.],
      ),
    ),
    (
      // Plain-string summary, no highlights.
      name: "Liffey Labs",
      position: "Software Engineer",
      startDate: "Jun 2019",
      endDate: "Dec 2021",
      summary: "Built and shipped the first version of a SaaS product.",
    ),
    (
      // Description-only — exporters that map JSON Resume's optional
      // `description` should land in the same slot when `summary` is
      // absent.
      name: "Grand Canal Systems",
      position: "Software Engineer",
      startDate: "Aug 2017",
      endDate: "May 2019",
      description: [Internal-tooling team for a 200-engineer org.],
      highlights: (
        [Migrated services from VMs to Kubernetes.],
      ),
    ),
    (
      // Both supplied — summary wins. The description string must NOT
      // appear in the rendered output.
      name: "Pembroke Software",
      position: "Software Engineering Intern",
      startDate: "May 2016",
      endDate: "Jul 2017",
      summary: [Wins over description.],
      description: [Should not render.],
      highlights: ([Maintained a legacy reporting service.],),
    ),
    (
      // Empty-string summary and `none` description — both skipped,
      // no italic paragraph emitted.
      name: "Ringsend Robotics",
      position: "Junior Engineer",
      startDate: "Jan 2015",
      endDate: "Apr 2016",
      summary: "",
      description: none,
      highlights: ([Wrote the firmware update tool.],),
    ),
  ),
))
