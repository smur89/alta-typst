// References. `availableOnRequest: true` shows
// `labels.referencesAvailableOnRequest` instead of a quote; when every
// entry is on request the section is that one line, with no names.
// Entries with neither quote nor flag are skipped; nameless ones
// render anonymously.

#import "../internal/text.typ": _present
#import "../internal/primitives.typ": _section

#let _references(entries, (labels, ..)) = {
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
      emph(if on-request(entry) { labels.referencesAvailableOnRequest } else {
        entry.reference
      })
    })
  }
}
