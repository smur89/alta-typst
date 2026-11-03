// `work[]` and `volunteer[]` render identically, differing only in
// section label and organisation key, so both use `_entry-section`.

#import "../internal/util/dates.typ": _format-date-range
#import "../internal/util/fields.typ": _field
#import "../internal/util/location.typ": _format-location
#import "../internal/components/entry.typ": _entry
#import "../internal/components/frame.typ": _section

// `key` (`"work"` / `"volunteer"`) names the label; `org-key` holds
// the organisation name. `position` is optional; without it the org
// line leads.
#let _entry-section(entries, key, org-key, (labels, prefs, ..)) = _section(
  labels.at(key),
  entries,
  entry => _entry(
    title: _field(entry, "position"),
    org: _field(entry, org-key),
    org-url: _field(entry, "url"),
    period: _format-date-range(entry, prefs, labels),
    location: _format-location(entry.at("location", default: none)),
    summary: _field(entry, "summary"),
    highlights: entry.at("highlights", default: ()),
  ),
)

#let _experience(work, ctx) = _entry-section(work, "work", "name", ctx)

#let _volunteer(entries, ctx) = _entry-section(
  entries,
  "volunteer",
  "organization",
  ctx,
)
