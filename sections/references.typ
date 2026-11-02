// References — referee `name` as a level-3 heading with the
// `reference` quote in italic beneath, joined by the standard divider
// rule. An entry with JSON Resume's `availableOnRequest: true` shows
// `labels.referencesAvailableOnRequest` in place of its quote; when
// every entry is on request, the section is that one line, with no
// names. Entries with neither a quote nor the flag are skipped (no
// orphan heading); entries lacking `name` render anonymously.

#import "../internal/text.typ": _present
#import "../internal/primitives.typ": _section

#let _references(entries, labels, prefs) = {
  // Only a real boolean counts, so a stray `"yes"` doesn't hide a quote.
  let on-request(r) = r.at("availableOnRequest", default: false) == true
  let valid = entries.filter(r => (
    on-request(r) or _present(r.at("reference", default: none))
  ))
  let on-request-line = {
    [== #labels.references]
    emph(labels.referencesAvailableOnRequest)
  }
  // The preference fallback is opt-in so an empty `references` block
  // stays silent by default — matching every other section's no-data
  // behaviour.
  if valid.len() > 0 and valid.all(on-request) {
    on-request-line
  } else if valid.len() > 0 {
    _section(labels.references, valid, entry => {
      let name = entry.at("name", default: none)
      if _present(name) [=== #name]
      emph(if on-request(entry) { labels.referencesAvailableOnRequest } else {
        entry.reference
      })
    })
  } else if prefs.referencesAvailableOnRequest {
    on-request-line
  }
}
