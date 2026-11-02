// References. `availableOnRequest: true` shows
// `labels.referencesAvailableOnRequest` instead of a quote; when every
// entry is on request the section is that one line, with no names.
// Entries with neither quote nor flag are skipped; nameless ones
// render anonymously. Contact details stay out, as JSON Resume
// intends.

#import "../internal/text.typ": _present, _string_at
#import "../internal/primitives.typ": _section, _subtitle
#import "../internal/dates.typ": _format_date

// "Manager, Pied Piper · 2024": who, then when, each part optional.
// `none` when all are absent.
#let _attribution(entry, prefs, labels) = {
  let date = _string_at(entry, "date")
  (
    ("relationship", "organization")
      .map(k => _string_at(entry, k))
      .filter(p => p != none)
      .join(", "),
    if date != none { _format_date(date, prefs, labels) },
  )
    .filter(p => p != none)
    .join(" · ")
}

#let _references(entries, (labels, prefs, ..)) = {
  // Only a real boolean counts, so a stray `"yes"` doesn't hide a quote.
  let on-request(r) = r.at("availableOnRequest", default: false) == true
  let valid = entries.filter(r => (
    on-request(r) or _present(r.at("reference", default: none))
  ))
  // `all` holds on an empty list, so this branch also covers "no
  // usable entries", which renders nothing.
  if valid.all(on-request) {
    if valid != () {
      [== #labels.references]
      emph(labels.referencesAvailableOnRequest)
    }
  } else {
    _section(labels.references, valid, entry => {
      let name = entry.at("name", default: none)
      if _present(name) [=== #name]
      _subtitle(_attribution(entry, prefs, labels))
      emph(if on-request(entry) { labels.referencesAvailableOnRequest } else {
        entry.reference
      })
    })
  }
}
