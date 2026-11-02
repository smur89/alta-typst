// Awards — title (optionally linked via the altacv `url` extension,
// read from `custom.altacv.url`),
// accent awarder line, single date, optional summary paragraph.
// Entries without a `title` are skipped so a stray entry can't emit
// an orphan heading.

#import "../internal/text.typ": _altacv, _present, styled-link
#import "../internal/primitives.typ": _section, name, term
#import "../internal/dates.typ": _format_date

#let _awards(entries, (labels, prefs, ..)) = _section(
  labels.awards,
  entries.filter(a => _present(a.at("title", default: none))),
  award => {
    let url = _altacv(award, "url")
    [=== #styled-link(award.title, dest: url)]
    let awarder = award.at("awarder", default: none)
    if _present(awarder) { name[#awarder] }
    let date = award.at("date", default: none)
    if _present(date) { term(_format_date(date, prefs, labels)) }
    let summary = award.at("summary", default: none)
    if _present(summary) { par(summary) }
  },
)
