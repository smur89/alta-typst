// References. `availableOnRequest: true` shows
// `labels.referencesAvailableOnRequest` instead of a quote; when every
// entry is on request the section is that one line, with no names.
// Entries with neither quote nor flag are skipped; nameless ones
// render anonymously. Contact details stay out, as JSON Resume
// intends.

#import "../internal/util/dates.typ": _format_date
#import "../internal/util/fields.typ": _field, _string_at
#import "../internal/data/cv.typ": _on_request, _reference_usable
#import "../internal/primitives.typ": _fact_line, _preamble
#import "../internal/components/entry.typ": _entry
#import "../internal/components/frame.typ": _section, _section_frame

// Who, then when, each part optional: "Manager, Pied Piper · 2024".
#let _attribution(entry, prefs, labels) = {
  let date = _string_at(entry, "date")
  _fact_line(
    ("relationship", "organization").map(k => _string_at(entry, k)),
    (if date != none { _format_date(date, prefs, labels) },),
  )
}

#let _references(entries, (labels, prefs, ..)) = {
  let valid = entries.filter(_reference_usable)
  // `all` holds on an empty list, which `_section_frame` then renders
  // as nothing.
  if valid.all(_on_request) {
    _section_frame(labels.references, valid, _preamble(
      labels.referencesAvailableOnRequest,
    ))
  } else {
    _section(labels.references, valid, entry => _entry(
      title: _field(entry, "name"),
      subtitle: _attribution(entry, prefs, labels),
      summary: if _on_request(entry) {
        labels.referencesAvailableOnRequest
      } else {
        entry.reference
      },
    ))
  }
}
