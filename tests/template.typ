// The template form: `#show: altacv.with(..)`, then the user's own
// rules, which win over the template's, then the CV and more content.
// The page is US letter, the text 11pt Libertinus Serif in Irish (the
// headings and months come from the Irish labels), section titles in
// red, and a page footer from `cv-footer()`, on two pages: the CV,
// then a page of the user's own content.

#import "../lib.typ": alta, altacv, cv-footer, themes

#show: altacv.with(theme: themes.navy)
#set page(paper: "us-letter", footer: cv-footer())
#set text(11pt, lang: "ga", font: "Libertinus Serif")
#show heading.where(level: 1): set text(fill: rgb("#b03a2e"))

#alta(
  (
    basics: (name: "Caoimhe Ní Bhriain", label: "Innealtóir Bogearraí"),
    work: (
      (
        name: "Acme Teo.",
        position: "Innealtóir Sinsearach",
        startDate: "2022-03",
      ),
    ),
    skills: ((name: "Teangacha", keywords: ("Scala", "Go")),),
  ),
  preferences: (column-ratio: 0.6),
)

#pagebreak()
Litir chumhdaigh: content of the user's own, after the CV.
