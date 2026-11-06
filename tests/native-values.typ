// Typst's own values where an option once took a name in a string:
// treatments as functions (the publication title in capitals, the
// owner among its authors underlined, a summary bold), the photo
// centred `bottom` with the text `center`, and `datetime` dates, a
// full date showing its day, beside a year-month string.

#import "../lib.typ": alta, altacv, cv-updated-footer

#show: altacv.with(
  theme: (treatment: (link: upper, owner: underline, preamble: strong)),
)
#set page(footer: cv-updated-footer())

#alta(
  (
    basics: (
      name: "Jane Doe",
      label: "Staff Engineer",
      image: path("../assets/avatar-placeholder.svg"),
    ),
    work: (
      (
        name: "Acme Corp",
        position: "Staff Engineer",
        startDate: datetime(year: 2022, month: 3, day: 14),
        endDate: datetime(year: 2024, month: 11, day: 30),
        summary: [Platform team lead.],
      ),
      (
        name: "Liffey Labs",
        position: "Engineer",
        startDate: "2019-06",
        endDate: "2022-02",
      ),
    ),
    publications: (
      (
        name: "Event Sourcing in Practice",
        publisher: "ACM Queue",
        releaseDate: datetime(year: 2024, month: 6, day: 15),
        url: "https://example.com/es",
        authors: ("Jane Doe", "A. N. Other"),
      ),
    ),
    meta: (lastModified: datetime(year: 2026, month: 6, day: 12)),
  ),
  preferences: (
    photo-position: bottom,
    header-text-align: center,
  ),
)
