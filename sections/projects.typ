// Projects (JSON Resume `projects[]`). Entries cluster under `====`
// subheadings only when at least one has a `type`; an all-untyped list
// renders flat. Entries without a `name` are skipped.

#import "../internal/util/fields.typ": _field, _string-at
#import "../internal/util/values.typ": _group-by
#import "../internal/data/cv.typ": _entry-period
#import "../internal/components/entry.typ": _entry
#import "../internal/primitives.typ": _icon-heading
#import "../internal/components/frame.typ": _grouped-section, _section

// The client or company (`entity`) mirrors `publications[].publisher`.
#let _render-project(project, (labels, format-date, ..)) = _entry(
  title: project.name,
  url: _field(project, "url"),
  subtitle: _field(project, "entity"),
  roles: project.at("roles", default: ()),
  period: _entry-period(project, format-date, labels.present),
  summary: _field(project, "summary"),
  highlights: project.at("highlights", default: ()),
  tags: project.at("keywords", default: ()),
)

// Drives the `====` subheadings in projects. An untyped entry, or one
// whose `type` isn't a string, pools under `fallback`.
#let _group-by-type(items, fallback) = _group-by(items, item => {
  let raw = _string-at(item, "type")
  if raw != none { raw } else { fallback }
})

#let _projects(entries, ctx) = {
  let (labels, prefs, ..) = ctx
  let render(p) = _render-project(p, ctx)

  // Flat unless some entry has a usable `type`, so the common untyped
  // case gets no redundant subheadings. Untyped entries in a mixed list
  // pool under `labels.otherProjects`.
  if not entries.any(p => _string-at(p, "type") != none) {
    _section(labels.projects, entries, render)
  } else {
    _grouped-section(
      labels.projects,
      _group-by-type(entries, labels.otherProjects),
      // `projectIcons` is lowercase-keyed (`_canonical-preferences`); a
      // group it doesn't map leads with no icon.
      (group, _) => {
        let icon-name = prefs.projectIcons.at(lower(group), default: none)
        if icon-name == none { group } else { _icon-heading(icon-name, group) }
      },
      render,
    )
  }
}
