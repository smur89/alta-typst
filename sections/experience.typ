// `work[]` and `volunteer[]` render identically, differing only in
// section label and organisation key, so both use `_entry_section`.

#import "../internal/text.typ": _field, _present
#import "../internal/primitives.typ": (
  _entry_term, _org_line, _preamble, _section,
)

// `key` (`"work"` / `"volunteer"`) names the label and the field in
// panic messages; `org-key` holds the organisation name.
#let _entry_section(entries, key, org-key, (labels, prefs, ..)) = _section(
  labels.at(key),
  entries,
  entry => [
    // `position` is optional; without it the org line leads.
    #let position = entry.at("position", default: none)
    #if _present(position) [=== #position]
    #_org_line(
      entry.at(org-key, default: none),
      url: entry.at("url", default: none),
    )
    #_entry_term(entry, key, prefs, labels)

    #_preamble(_field(entry, "summary"))
    #for bullet in entry.at("highlights", default: ()) [- #bullet]
  ],
)

#let _experience(work, ctx) = _entry_section(work, "work", "name", ctx)

#let _volunteer(entries, ctx) = _entry_section(
  entries,
  "volunteer",
  "organization",
  ctx,
)
