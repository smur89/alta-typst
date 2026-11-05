// The labels follow the document's language: `set text(lang: "ga")`
// before `alta()` renders the headings, months and "I láthair" in
// Irish from the package's own translation, with no `labels`. A
// caller's label goes over it (`skills`), and an untranslated key
// stays English (`publicationTypes.book`, "Books").

#import "../lib.typ": alta

#set text(lang: "ga")
#alta(
  (
    basics: (name: "Caoimhe Ní Bhriain", label: "Innealtóir Bogearraí"),
    work: (
      (
        name: "Acme Teo.",
        position: "Innealtóir Sinsearach",
        startDate: "2022-03",
      ),
      (
        name: "Liffey Labs",
        position: "Innealtóir",
        startDate: "2019-06",
        endDate: "2022-02",
      ),
    ),
    skills: ((name: "Teangacha ríomhchlárúcháin", keywords: ("Scala", "Go")),),
    publications: (
      (name: "Foinsiú Imeachtaí", type: "article", releaseDate: "2024-06"),
      (name: "Córais Dháilte", type: "book", releaseDate: "2023-01"),
    ),
  ),
  labels: (skills: "Inniúlachtaí"),
)
