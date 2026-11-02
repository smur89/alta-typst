// JSON Resume's `work[]` and `volunteer[]` render as the same block
// list — position heading, accent-coloured (optionally linked) org
// line, optional term row + location, optional italic preamble,
// bulleted highlights. They differ only in their section label and in
// the dict key naming the organisation (`work` uses `name`,
// `volunteer` uses `organization`), so both delegate to the shared
// `_entry_section` renderer below.

#import "../internal/text.typ": _entry_summary, _present
#import "../internal/primitives.typ": _entry_term, _preamble, _section, name

// Shared renderer for the `work[]` / `volunteer[]` block lists.
// `key` is the JSON Resume section key (`"work"` / `"volunteer"`),
// which also names the section label and the field in panic messages;
// `org-key` is the dict key holding the organisation name (`"name"`
// for work, `"organization"` for volunteer).
#let _entry_section(entries, key, org-key, labels, prefs) = _section(
  labels.at(key),
  entries,
  entry => [
    // `position` is optional in JSON Resume — without it the org
    // line leads the entry.
    #let position = entry.at("position", default: none)
    #if _present(position) [=== #position]
    // `link()` inherits the surrounding bold + accent from `name()`,
    // so the org stays visually identical to the unlinked case and
    // just gains click behaviour. `styled-link` would impose the
    // italic / underline treatment used for publication titles.
    // `_present` (rather than `!= none`) so an empty-string url
    // doesn't render a dead link.
    #let org = entry.at(org-key, default: "")
    #let url = entry.at("url", default: none)
    #name[#if _present(url) { link(url, org) } else { org }]
    #_entry_term(entry, key, prefs, labels)

    #_preamble(_entry_summary(entry))
    #for bullet in entry.at("highlights", default: ()) [- #bullet]
  ],
)

// `work[]` — organisation held under `name`.
#let _experience(work, (labels, prefs, ..)) = _entry_section(
  work,
  "work",
  "name",
  labels,
  prefs,
)

// `volunteer[]` — organisation held under `organization`; otherwise
// identical to `work[]` (same summary preamble and linked-org
// behaviour).
#let _volunteer(entries, (labels, prefs, ..)) = _entry_section(
  entries,
  "volunteer",
  "organization",
  labels,
  prefs,
)
