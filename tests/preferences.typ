// Preference overrides: ungrouped certificates +
// localised labels. Exercises _strict-merge for both `labels` and
// `preferences`. Labels are translated to Gaeilge (Irish) to
// demonstrate the localisation path with a non-English language.
// Also sets the deprecated `group-certificates: false` and
// `show-pronouns: true`, which have no effect: `basics.pronouns` is
// ignored, as JSON Resume dropped it (https://github.com/jsonresume/jsonresume.org/pull/629).

#import "../lib.typ": alta

#alta(
  (
    basics: (
      name: "Oisín Mac Cárthaigh",
      pronouns: "he/him",
      email: "oisin@example.com",
    ),
    work: (
      (
        name: "Forge Liffey",
        position: "Innealtóir",
        startDate: "Eanáir 2022",
        highlights: ([Rinne obair.],),
      ),
    ),
    certificates: (
      (name: "AWS SA Pro", issuer: "Amazon Web Services"),
      (name: "AWS DevOps", issuer: "Amazon Web Services"),
      (name: "CKA", issuer: "CNCF"),
    ),
  ),
  preferences: (
    group-certificates: false,
    show-pronouns: true,
  ),
  labels: (
    work: "Taithí Oibre",
    focus-areas: "Réimsí Spéise",
    skills: "Scileanna",
    languages: "Teangacha",
    education: "Oideachas",
    certificates: "Teastais",
    publications: "Foilseacháin",
    articles: "Ailt",
    present: "I láthair",
  ),
)
