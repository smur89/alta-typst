// `work[].url` renders the company name as a link. Mirrors the
// projects[].url pattern but preserves the bold-accent treatment of
// the `name()` helper (no italic / underline), so a linked and
// unlinked company line look visually identical apart from click
// behaviour.

#import "../lib.typ": alta

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  work: (
    (
      // Linked company — clickable, but renders with the same bold
      // accent as the unlinked entry below.
      name: "Acme Corp",
      url: "https://acme.example.com",
      position: "Senior Software Engineer",
      location: "Dublin, Ireland",
      startDate: "Jan 2022",
      highlights: (
        [Led the migration of a monolith to event-driven services.],
      ),
    ),
    (
      // No URL — verifies the unlinked path still renders.
      name: "Liffey Labs",
      position: "Software Engineer",
      startDate: "Jun 2019",
      endDate: "Dec 2021",
      highlights: ([Shipped the first version of a SaaS product.],),
    ),
    (
      // Explicit `url: none` — should be treated identically to
      // omitting the key (no link wrapping, no panic).
      name: "Grand Canal Systems",
      url: none,
      position: "Software Engineer",
      startDate: "Aug 2017",
      endDate: "May 2019",
      highlights: ([Built internal tooling adopted by the org.],),
    ),
  ),
))
