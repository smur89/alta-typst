// Projects (JSON Resume `projects[]`). Entries cluster under `====`
// subheadings only when at least one has a `type`; an all-untyped list
// renders flat. Entries without a `name` are skipped.

#import "../internal/state.typ": _body_colour
#import "../internal/text.typ": (
  _entry_summary, _present, _present_str, styled-link,
)
#import "../internal/primitives.typ": (
  _group_by_type, _join_with_dividers, _preamble, _section, _tag_row, term,
)
#import "../internal/dates.typ": _format_date_range

// Returns the unwrapped body; callers supply the unbreakable block
// (`_section` when flat, an explicit `block` when grouped).
#let _render_project(project, (labels, prefs, ..)) = {
  let url = project.at("url", default: none)
  [=== #styled-link(project.name, dest: url)]
  // The client or company, mirroring `publications[].publisher`.
  let entity = project.at("entity", default: none)
  if _present(entity) {
    block(below: 0.5em, text(0.85em, fill: _body_colour, entity))
  }
  // A block, not `linebreak()`, so the gap below matches the
  // organisation-line → term spacing in experience / education.
  let preamble = _preamble(_entry_summary(project))
  if preamble != none { block(below: 0.6em, preamble) }
  // The person's `roles` as darker pills on their own line, set apart
  // from the keyword pills at the foot.
  let roles = project.at("roles", default: ())
  if roles.len() > 0 { block(below: 0.4em, _tag_row(roles, label: true)) }
  term(_format_date_range(project, prefs, labels))
  for bullet in project.at("highlights", default: ()) [- #bullet]
  _tag_row(project.at("keywords", default: ()))
}

#let _projects(entries, ctx) = {
  let (labels, ..) = ctx
  let valid = entries.filter(p => _present(p.at("name", default: none)))
  let render(p) = _render_project(p, ctx)

  // Flat unless some entry has a usable `type`, so the common untyped
  // case gets no redundant subheadings. Untyped entries in a mixed list
  // pool under `labels.otherProjects`.
  if not valid.any(p => _present_str(p.at("type", default: none))) {
    _section(labels.projects, valid, render)
  } else {
    [== #labels.projects]
    let groups = _group_by_type(valid, labels.otherProjects)
    for (group, items) in groups.pairs() [
      ==== #group

      #_join_with_dividers(items, p => block(breakable: false, render(p)))
    ]
  }
}
