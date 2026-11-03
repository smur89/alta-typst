// Section scaffolding: the `==` heading and its entries, with dividers
// between them, optionally clustered under `====` subheadings.

#import "../primitives.typ": divider

// Empty `entries` renders nothing, not even the heading, so callers
// filter unusable entries first and no heading is orphaned.
#let _section_frame(heading, entries, body) = if entries.len() > 0 {
  [== #heading]
  body
}

// Each entry unbreakable, with rules between neighbours only, so a
// section doesn't end on a stray rule.
#let _entry_blocks(entries, render-entry, dividers: true) = (
  entries
    .map(e => block(breakable: false, render-entry(e)))
    .join(if dividers { divider() })
)

#let _section(heading, entries, render-entry) = _section_frame(
  heading,
  entries,
  _entry_blocks(entries, render-entry),
)

// `_section` with entries clustered under `====` subheadings, one per
// `groups` key (see `_group_by`); `subheading(key, items)` gives each
// subheading's text.
#let _grouped_section(
  heading,
  groups,
  subheading,
  render-entry,
  dividers: true,
) = _section_frame(heading, groups, {
  for (key, items) in groups.pairs() {
    [==== #subheading(key, items)]
    _entry_blocks(items, render-entry, dividers: dividers)
  }
})
