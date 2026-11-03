// References. `availableOnRequest: true` shows
// `labels.referencesAvailableOnRequest` instead of a quote; when every
// entry is on request the section is that one line, with no names.
// Entries with neither quote nor flag are skipped; nameless ones
// render anonymously. Contact details stay out, as JSON Resume
// intends.

#import "../internal/util/dates.typ": _format-date
#import "../internal/util/fields.typ": _field, _string-at
#import "../internal/data/cv.typ": _on-request, _reference-usable
#import "../internal/primitives.typ": _fact-line, _preamble
#import "../internal/components/entry.typ": _entry
#import "../internal/components/frame.typ": _section, _section-frame

// Who, then when, each part optional: "Manager, Pied Piper · 2024".
#let _attribution(entry, prefs, labels) = {
  let date = _string-at(entry, "date")
  _fact-line(
    ("relationship", "organization").map(k => _string-at(entry, k)),
    (if date != none { _format-date(date, prefs, labels) },),
  )
}

#let _references(entries, (labels, prefs, ..)) = {
  let valid = entries.filter(_reference-usable)
  // `all` holds on an empty list, which `_section-frame` then renders
  // as nothing.
  if valid.all(_on-request) {
    _section-frame(labels.references, valid, _preamble(
      labels.referencesAvailableOnRequest,
    ))
  } else {
    _section(labels.references, valid, entry => _entry(
      title: _field(entry, "name"),
      subtitle: _attribution(entry, prefs, labels),
      summary: if _on-request(entry) {
        labels.referencesAvailableOnRequest
      } else {
        entry.reference
      },
    ))
  }
}
