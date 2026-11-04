// `work[]` and `volunteer[]` render identically, differing only in
// section label and organisation key, so both use `_entry-section`.

#import "../internal/util/fields.typ": _field
#import "../internal/data/cv.typ": _entry-period, _location-parts
#import "../internal/components/entry.typ": _entry
#import "../internal/components/frame.typ": _section

// `key` (`"work"` / `"volunteer"`) names the label; `org-key` holds
// the organisation name. `position` is optional; without it the org
// line leads.
#let _entry-section(
  entries,
  key,
  org-key,
  (labels, format-date, ..),
) = _section(
  labels.at(key),
  entries,
  entry => _entry(
    title: _field(entry, "position"),
    org: _field(entry, org-key),
    org-url: _field(entry, "url"),
    period: _entry-period(entry, format-date, labels.present),
    location: _location-parts(entry),
    summary: _field(entry, "summary"),
    highlights: entry.at("highlights", default: ()),
  ),
)

#let _work(entries, ctx) = _entry-section(entries, "work", "name", ctx)

#let _volunteer(entries, ctx) = _entry-section(
  entries,
  "volunteer",
  "organization",
  ctx,
)
