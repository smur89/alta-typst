// Exercises every variant of the date-range formatter:
// - both dates present (range with en-dash)
// - missing endDate (renders as "Present")
// - missing startDate (no leading dash)
// - both dates missing (no term emitted)

#import "../lib.typ": alta

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  work: (
    (
      name: "Both Dates Ltd",
      position: "Engineer",
      startDate: "Jan 2020",
      endDate: "Dec 2021",
      highlights: ([Did things.],),
    ),
    (
      name: "Still Here Inc",
      position: "Engineer",
      startDate: "Jan 2022",
      // endDate omitted → "Present"
      highlights: ([Doing things.],),
    ),
    (
      name: "End Only Corp",
      position: "Engineer",
      endDate: "Mar 2019",
      highlights: ([Past role.],),
    ),
    (
      name: "Undated Co",
      position: "Engineer",
      highlights: ([No dates at all.],),
    ),
  ),
))
