// `uppercaseName: false` renders the name as supplied. Useful for
// scripts where uppercase is a different glyph set (Turkish dotless-i,
// many South / East Asian scripts), or when the loud uppercase look
// isn't wanted. The default (`true`) is exercised by every other
// fixture.

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
