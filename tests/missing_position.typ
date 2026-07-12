// JSON Resume marks every `work[]` / `volunteer[]` field optional, so
// entries without a `position` must render (org line + highlights,
// no role heading) rather than panicking on the missing key. One
// positioned entry per section keeps the contrast visible.

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
