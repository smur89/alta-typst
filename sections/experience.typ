// JSON Resume's `work[]` and `volunteer[]` render as block lists built
// from the same parts — position heading and accent-coloured
// (optionally linked) org line, term row + location, italic preamble,
// bulleted highlights. Each section composes the parts its schema has.

#import "../internal/text.typ": _entry_summary, _present
#import "../internal/primitives.typ": (
  _entry_term, _highlights, _preamble, _section, name,
)

// `org-key` is the dict key holding the organisation name (`"name"`
// for work, `"organization"` for volunteer).
#let _entry_heading(entry, org-key) = {
  // `position` is optional in JSON Resume — without it the org line
  // leads the entry.
  let position = entry.at("position", default: none)
  if _present(position) [=== #position]
  // `link()` inherits the surrounding bold + accent from `name()`, so
  // the org stays visually identical to the unlinked case and just
  // gains click behaviour. `styled-link` would impose the italic /
  // underline treatment used for publication titles. `_present`
  // (rather than `!= none`) so an empty-string url doesn't render a
  // dead link.
  let org = entry.at(org-key, default: "")
  let url = entry.at("url", default: none)
  name[#if _present(url) { link(url, org) } else { org }]
}

#let _experience(work, labels, prefs) = _section(
  labels.work,
  work,
  entry => [
    #_entry_heading(entry, "name")
    #_entry_term(entry, "work", prefs, labels)

    // #239: drop the deprecated `description` fallback.
    #_preamble(_entry_summary(entry, fallback: "description"))
    #_highlights(entry)
  ],
)

#let _volunteer(entries, labels, prefs) = _section(
  labels.volunteer,
  entries,
  entry => [
    #_entry_heading(entry, "organization")
    #_entry_term(entry, "volunteer", prefs, labels)

    // #239: drop the deprecated `description` fallback.
    #_preamble(_entry_summary(entry, fallback: "description"))
    #_highlights(entry)
  ],
)
