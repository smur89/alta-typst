// Section scaffolding: the `==` heading and its entries, separated,
// optionally clustered under `====` subheadings.

#import "../design/theme.typ": _theme
#import "../context.typ": _body-size-state
#import "../primitives.typ": divider

// Empty `entries` renders nothing, not even the heading, so callers
// filter unusable entries first and no heading is orphaned.
#let _section-frame(heading, entries, body) = if entries.len() > 0 {
  [== #heading]
  body
}

// Each entry unbreakable, with a `separator` between neighbours only,
// so a section doesn't end on a stray rule: `"divider"` a rule,
// `"space"` the rule's spacing without the line (short, uniform
// entries, where rules would outweigh the content), `none` nothing (a
// list that spaces itself).
#let _entry-blocks(entries, render-entry, separator: "divider") = (
  entries
    .map(e => block(breakable: false, render-entry(e)))
    .join(if separator == "divider" { divider() } else if separator == "space" {
      context v(2 * _theme.divider.gap * _body-size-state.get())
    })
)

#let _section(heading, entries, render-entry, separator: "divider") = (
  _section-frame(
    heading,
    entries,
    _entry-blocks(entries, render-entry, separator: separator),
  )
)

// `_section` with entries clustered under `====` subheadings, one per
// `groups` key (see `_group-by`); `subheading(key, items)` gives each
// subheading's text.
#let _grouped-section(
  heading,
  groups,
  subheading,
  render-entry,
  separator: "divider",
) = _section-frame(heading, groups, {
  for (key, items) in groups.pairs() {
    [==== #subheading(key, items)]
    _entry-blocks(items, render-entry, separator: separator)
  }
})
