// Projects — name (optionally linked), italic description, date
// range, bulleted highlights, pill-tagged keywords. JSON Resume's
// `projects[]` schema; `entity` / `type` / `roles` are accepted but
// unrendered. Entries without a `name` are skipped to avoid an
// orphan heading.

#import "../internal/text.typ": _present, styled-link
#import "../internal/primitives.typ": term, _join_with_dividers, _tag_row
#import "../internal/dates.typ": _format_date_range
#import "../internal/state.typ": _spacing_scale_state, _body_size_state

#let _projects(entries, labels, prefs) = {
  let valid = entries.filter(p => _present(p.at("name", default: none)))
  if valid.len() == 0 { return }
  [== #labels.projects]
  _join_with_dividers(valid, project => block(breakable: false, {
    let url = project.at("url", default: none)
    [=== #styled-link(project.name, dest: url)]
    let description = project.at("description", default: none)
    if _present(description) {
      // Softer than `name()` (which is bold + accent) so the
      // description doesn't compete visually with a linked title.
      // Mirrors `name()`'s `below` so the description → term gap
      // matches the institution-line → term gap in `_experience` /
      // `_education`; literal `0.6em` would skip the density scale
      // and break that contract under non-default density.
      context block(
        below: 0.6 * _spacing_scale_state.get() * _body_size_state.get(),
        emph(description),
      )
    }
    term(_format_date_range(project, prefs, labels))
    for bullet in project.at("highlights", default: ()) [- #bullet]
    _tag_row(project.at("keywords", default: ()))
  }))
}
