// Awards. The title links via the altacv `custom.altacv.url`
// extension; entries without a `title` are skipped.

#import "../internal/text.typ": _altacv, _present, styled-link
#import "../internal/primitives.typ": _org_line, _section, term
#import "../internal/dates.typ": _format_date

#let _awards(entries, (labels, prefs, ..)) = _section(
  labels.awards,
  entries.filter(a => _present(a.at("title", default: none))),
  award => {
    let url = _altacv(award, "url")
    [=== #styled-link(award.title, dest: url)]
    _org_line(award.at("awarder", default: none))
    let date = award.at("date", default: none)
    if _present(date) { term(_format_date(date, prefs, labels)) }
    let summary = award.at("summary", default: none)
    if _present(summary) { par(summary) }
  },
)
