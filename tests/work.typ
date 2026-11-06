// JSON Resume `work`. Documents:
//
//   1. `summary` (and the related `description` field used by some
//      exporters). Both render as an italic paragraph between the term
//      row and the highlights list; `summary` wins when both are
//      supplied. Covers a content-form summary, a plain-string summary,
//      description-only (fallback), summary+description (summary wins),
//      and the empty-string / `none` skip cases. `url` renders the
//      company name as a link, with the bold-accent treatment of an
//      unlinked one, so the two look identical apart from click
//      behaviour: the assert at the end pins the one link; `url: none` is
//      treated as omitting the key.
//   2. `position` is optional in JSON Resume: entries without it render
//      (org line leads, no role heading) rather than panic. An entry
//      without an org skips the org line, leaving no blank gap.

#import "../lib.typ": alta

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  work: (
    (
      // Linked company: clickable, the same bold accent as the rest.
      name: "Acme Corp",
      url: "https://acme.example.com",
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
      keywords: ("Python", "Go"),
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
      // Summary and keywords, but no highlights: keywords should render on a new line.
      name: "Keywords Corp",
      position: "Software Engineer",
      startDate: "Jun 2019",
      endDate: "Dec 2021",
      summary: "Created keywords to improve the Curriculum Vitae.",
      keywords: ("Python", "Go"),
    ),
    (
      // Description-only — exporters that map JSON Resume's optional
      // `description` should land in the same slot when `summary` is
      // absent.
      // `url: none` is the same as omitting it: no link, no panic.
      name: "Grand Canal Systems",
      url: none,
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

#pagebreak()

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  work: (
    (
      name: "Acme Corp",
      position: "Engineer",
      startDate: "2022-01",
      highlights: ([Positioned entry renders as before.],),
    ),
    (
      // No `position` — org line leads the entry.
      name: "Beta Ltd",
      startDate: "2020-03",
      endDate: "2021-12",
      highlights: ([Un-positioned entry keeps its org line and bullets.],),
    ),
    (
      // No `name` — the term row follows the heading directly.
      position: "Freelance Consultant",
      startDate: "2018",
      endDate: "2020",
      highlights: ([Org-less entry has no empty org line.],),
    ),
  ),
  volunteer: (
    (
      // No `position` — same guard via the shared `_entry-section`.
      organization: "Community Library",
      startDate: "2019",
      highlights: ([Volunteer entry without a role.],),
    ),
  ),
))

// The only link besides the email: document 1's Acme Corp.
#context assert.eq(
  query(link).map(l => l.dest).filter(d => not d.starts-with("mailto:")),
  ("https://acme.example.com",),
)
