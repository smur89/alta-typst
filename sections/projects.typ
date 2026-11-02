// Projects — name (optionally linked), optional `entity` subtitle,
// italic summary, date range, bulleted highlights, `roles` pills,
// keyword pills. JSON Resume's `projects[]` schema. When at least one
// entry carries a `type`, entries cluster under `====` subheadings
// (mirroring `publications[].type`); an all-untyped list renders flat.
// Entries without a `name` are skipped to avoid an orphan heading.

#import "../internal/state.typ": _body_colour
#import "../internal/text.typ": (
  _entry_summary, _present, _present_str, styled-link,
)
#import "../internal/primitives.typ": (
  _group_by_type, _highlights, _join_with_dividers, _preamble, _section,
  _tag_row, term,
)
#import "../internal/dates.typ": _format_date_range

// One project entry block — shared by the flat and grouped layouts.
// Returns the unwrapped body; callers supply the unbreakable block
// (`_section` on the flat path, an explicit `block` when grouped).
#let _render_project(project, labels, prefs) = {
  let url = project.at("url", default: none)
  [=== #styled-link(project.name, dest: url)]
  // Small body-colour subtitle under the title — the company / client
  // the project belonged to, distinct from the project name. Mirrors
  // `publications[].publisher`.
  let entity = project.at("entity", default: none)
  if _present(entity) {
    block(below: 0.5em, text(0.85em, fill: _body_colour, entity))
  }
  // JSON Resume 1.6.0 prefers `summary`; `description` is its
  // deprecated alias. Wrapped in a block so the gap to the roles /
  // term row below matches the institution-line → term spacing in
  // `_experience` / `_education`; a bare `linebreak()` here leaves no
  // paragraph spacing.
  // #239: drop the deprecated `description` fallback.
  let preamble = _preamble(_entry_summary(project, fallback: "description"))
  if preamble != none { block(below: 0.6em, preamble) }
  // `roles` — the person's role(s) on the project — render as a row of
  // darker (label-variant) pills just below the summary and above
  // the date row, set apart from the lighter keyword pills at the foot
  // of the entry. The block puts them on their own line.
  let roles = project.at("roles", default: ())
  if roles.len() > 0 { block(below: 0.4em, _tag_row(roles, label: true)) }
  term(_format_date_range(project, prefs, labels))
  _highlights(project)
  _tag_row(project.at("keywords", default: ()))
}

#let _projects(entries, labels, prefs) = {
  let valid = entries.filter(p => _present(p.at("name", default: none)))
  let render(p) = _render_project(p, labels, prefs)

  // `type` is an optional JSON Resume field. Cluster by it only when at
  // least one entry carries a usable (non-empty string) value —
  // otherwise render flat, so the common (untyped) case stays free of
  // redundant subheadings and matches the pre-grouping output. Untyped
  // entries in a mixed list pool under `labels.otherProjects`.
  if not valid.any(p => _present_str(p.at("type", default: none))) {
    _section(labels.projects, valid, render)
  } else {
    [== #labels.projects]
    // Groups render in first-occurrence order, matching the
    // publications clustering.
    let groups = _group_by_type(valid, labels.otherProjects)
    for (group, items) in groups.pairs() [
      ==== #group

      #_join_with_dividers(items, p => block(breakable: false, render(p)))
    ]
  }
}
