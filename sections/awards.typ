// Awards. The title links via the altacv `custom.altacv.url`
// extension; entries without a `title` are skipped.

#import "../internal/util/fields.typ": _field
#import "../internal/data/cv.typ": _altacv
#import "../internal/components/entry.typ": _entry
#import "../internal/components/frame.typ": _section

#let _awards(entries, (labels, format-date, ..)) = _section(
  labels.awards,
  entries.filter(a => _field(a, "title") != none),
  award => _entry(
    title: award.title,
    url: _altacv(award, "url"),
    org: _field(award, "awarder"),
    period: format-date(_field(award, "date")),
    summary: _field(award, "summary"),
  ),
)
