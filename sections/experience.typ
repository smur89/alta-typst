// JSON Resume's `work[]` and `volunteer[]` render as the same block
// list — position heading, accent-coloured (optionally linked) org
// line, optional term row + location, optional italic preamble,
// bulleted highlights. They differ only in their section label and in
// the dict key naming the organisation (`work` uses `name`,
// `volunteer` uses `organization`), and `volunteer[]`
// cannot have a `keywords` section

#import "../internal/text.typ": _entry_summary, _present
#import "../internal/primitives.typ": _entry_term, _preamble, _section, _tag_row, name

// Renders an entry's optional position heading and organization line.
// A non-empty `url` makes the organization line clickable.
#let _entry_heading(entry, org-key) = {
  // `position` is optional in JSON Resume — without it the org
  // line leads the entry.
  let position = entry.at("position", default: none)
  if _present(position) [=== #position]
  let org = entry.at(org-key, default: "")
  let url = entry.at("url", default: none)
  // `link()` inherits the surrounding bold + accent from `name()`,
  // so the org stays visually identical to the unlinked case and
  // just gains click behaviour. `styled-link` would impose the
  // italic / underline treatment used for publication titles.
  // `_present` (rather than `!= none`) so an empty-string url
  // doesn't render a dead link.
  name(if _present(url) { link(url, org) } else { org })
}

// Renders the entry's `highlights` as a bulleted list.
// When no `highlights` are provided default to an empty list.
#let _highlights(entry) = [
  #for bullet in entry.at("highlights", default: ()) [- #bullet]
]

// Renders the entry's `keywords` as a row of pill tags.
// Omits when no `keywords` are provided.
#let _keywords(entry) = {
  let keywords = entry.at("keywords", default: ())
  if keywords.len() > 0 {
    block(_tag_row(keywords))
  }
}

// `work[]` — organisation held under `name`.
#let _experience(work, labels, prefs) = _section(
  labels.work,
  work,
  entry => [
    #_entry_heading(entry, "name")
    #_entry_term(entry, "work", prefs, labels)
    #_preamble(_entry_summary(entry, fallback: "description"))
    #_highlights(entry)
    #_keywords(entry)
  ],
)

// `volunteer[]` — organisation held under `organization` and does not allow `keywords`;
// otherwise identical to `work[]`.
#let _volunteer(entries, labels, prefs) = _section(
  labels.volunteer,
  entries,
  entry => [
    #_entry_heading(entry, "organization")
    #_entry_term(entry, "volunteer", prefs, labels)
    #_preamble(_entry_summary(entry, fallback: "description"))
    #_highlights(entry)
  ],
)
