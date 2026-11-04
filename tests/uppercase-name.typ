// `uppercaseName: false` with mixed-case Turkish input. The dotted /
// dotless i is the canonical case where Unicode default upper-casing
// loses information, so this fixture pins the opt-out path. The
// default `true` is exercised by every other fixture.

#import "../lib.typ": alta

#alta(
  (
    basics: (
      name: "İrem İşçi",
      label: "Mixed-case header rendered verbatim",
      email: "irem@example.com",
    ),
    work: (
      (
        name: "Boğaziçi Yazılım",
        position: "Yazılım Mühendisi",
        startDate: "Oca 2022",
        highlights: ([Rendered the lower-case dotted-i correctly.],),
      ),
    ),
  ),
  preferences: (
    uppercaseName: false,
  ),
)
