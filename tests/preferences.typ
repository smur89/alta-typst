// Preference overrides: custom accent + ungrouped certificates +
// localised labels. Exercises _strict_merge for both `labels` and
// `preferences`. Labels are translated to Gaeilge (Irish) to
// demonstrate the localisation path with a non-English language.

#import "../lib.typ": alta

#alta(
  (
    basics: (name: "Oisín Mac Cárthaigh", email: "oisin@example.com"),
    work: (
      (
        name: "Forge Liffey",
        position: "Innealtóir",
        startDate: "Eanáir 2022",
        highlights: ([Rinne obair.],),
      ),
    ),
    certificates: (
      (name: "AWS SA Pro",  issuer: "Amazon Web Services"),
      (name: "AWS DevOps",  issuer: "Amazon Web Services"),
      (name: "CKA",         issuer: "CNCF"),
    ),
  ),
  preferences: (
    accent: rgb("#1976D2"),
    groupCertificates: false,
  ),
  labels: (
    work:         "Taithí Oibre",
    focusAreas:   "Réimsí Spéise",
    skills:       "Scileanna",
    languages:    "Teangacha",
    education:    "Oideachas",
    certificates: "Teastais",
    publications: "Foilseacháin",
    articles:     "Ailt",
    present:      "I láthair",
  ),
)
