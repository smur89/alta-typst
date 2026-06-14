// Awards — title (optionally linked), accent awarder line, single
// date, optional summary paragraph. Follows JSON Resume's `awards[]`
// shape plus an altacv `url` extension that wraps the title in an
// accent-coloured link.

#import "../internal/text.typ": _present, _titled_link
#import "../internal/primitives.typ": name, term, _join_with_dividers
#import "../internal/dates.typ": _format_date

// Follows JSON Resume's `awards[]` shape, plus an `url` extension that
// wraps the title in an accent-coloured link (same treatment as
// `projects[].url`). Entries without a `title` are skipped so a stray
// entry can't emit an orphan heading.
#let _awards(entries, labels, prefs) = {
  let valid = entries.filter(a => _present(a.at("title", default: none)))
  if valid.len() == 0 { return }
  [== #labels.awards]
  _join_with_dividers(valid, award => block(breakable: false, {
    let url = award.at("url", default: none)
    [=== #_titled_link(award.title, url)]
    let awarder = award.at("awarder", default: none)
    if _present(awarder) { name[#awarder] }
    let date = award.at("date", default: none)
    if _present(date) { term(_format_date(date, prefs, labels)) }
    let summary = award.at("summary", default: none)
    if _present(summary) { par(summary) }
  }))
}
