// References — referee `name` as a level-3 heading with the
// `reference` quote in italic beneath, joined by the standard divider
// rule. An entry with JSON Resume's `availableOnRequest: true` shows
// `labels.referencesAvailableOnRequest` in place of its quote; when
// every entry is on request, the section is that one line, with no
// names. Entries with neither a quote nor the flag are skipped (no
// orphan heading); entries lacking `name` render anonymously.

#import "../internal/text.typ": _present
#import "../internal/primitives.typ": _section

#let _references(entries, (labels, prefs, ..)) = {
  // Only a real boolean counts, so a stray `"yes"` doesn't hide a quote.
  let on-request(r) = r.at("availableOnRequest", default: false) == true
  let valid = entries.filter(r => (
    on-request(r) or _present(r.at("reference", default: none))
  ))
  // `all` holds on an empty list, so this branch also covers "no
  // usable entries", which renders nothing unless the deprecated
  // preference asks for the line (#239: drop the `or` clause).
  if valid.all(on-request) {
    if valid != () or prefs.referencesAvailableOnRequest {
      [== #labels.references]
      emph(labels.referencesAvailableOnRequest)
    }
  } else {
    _section(labels.references, valid, entry => {
      let name = entry.at("name", default: none)
      if _present(name) [=== #name]
      emph(if on-request(entry) { labels.referencesAvailableOnRequest } else {
        entry.reference
      })
    })
  }
}
