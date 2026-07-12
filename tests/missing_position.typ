// `position` is optional in JSON Resume — entries without it must
// render (org line leads, no role heading) rather than panic.

#import "../lib.typ": alta

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
  ),
  volunteer: (
    (
      // No `position` — same guard via the shared `_entry_section`.
      organization: "Community Library",
      startDate: "2019",
      highlights: ([Volunteer entry without a role.],),
    ),
  ),
))
