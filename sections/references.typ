// JSON Resume's `references[]` — a referee's `name` (rendered as a
// level-3 heading, matching awards / projects) with their `reference`
// quote in italic beneath, joined by the standard divider rule.
//
// Entries missing the `reference` quote are silently skipped (no
// orphan heading); entries with no `name` render the quote anonymously
// so the data still surfaces. When the resulting list is empty and
// `preferences.referencesAvailableOnRequest` is `true`, the section
// renders the conventional fallback line under the heading rather
// than being suppressed.

#import "../internal/text.typ": _present
#import "../internal/primitives.typ": _join_with_dividers

#let _references(entries, labels, prefs) = {
  let valid = entries.filter(r => _present(r.at("reference", default: none)))
  // Three-way decision: render entries, render the fallback line, or
  // suppress the section entirely. The fallback is opt-in so an empty
  // `references` block stays silent by default — matching every other
  // section's no-data behaviour.
  if valid.len() == 0 and not prefs.referencesAvailableOnRequest { return }
  [== #labels.references]
  if valid.len() == 0 {
    emph(labels.referencesAvailableOnRequest)
  } else {
    _join_with_dividers(valid, entry => block(breakable: false, {
      let name = entry.at("name", default: none)
      if _present(name) [=== #name]
      emph[#entry.reference]
    }))
  }
}
