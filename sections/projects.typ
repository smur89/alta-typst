// Projects (JSON Resume `projects[]`). Entries cluster under `====`
// subheadings only when at least one has a `type`; an all-untyped list
// renders flat. Entries without a `name` are skipped.

#import "../internal/util/fields.typ": _field, _string-at
#import "../internal/util/values.typ": _group-by
#import "../internal/data/cv.typ": _entry-period
#import "../internal/components/entry.typ": _entry
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

// Drives the `====` subheadings in projects. A
// missing or non-string `type` pools under `fallback` rather than
// crashing as a dict key.
#let _group-by-type(items, fallback) = _group-by(items, item => {
  let raw = _string-at(item, "type")
  if raw != none { raw } else { fallback }
})

#let _projects(entries, ctx) = {
  let (labels, ..) = ctx
  let valid = entries.filter(p => _field(p, "name") != none)
  let render(p) = _render-project(p, ctx)

  // Flat unless some entry has a usable `type`, so the common untyped
  // case gets no redundant subheadings. Untyped entries in a mixed list
  // pool under `labels.otherProjects`.
  if not valid.any(p => _string-at(p, "type") != none) {
    _section(labels.projects, valid, render)
  } else {
    _grouped-section(
      labels.projects,
      _group-by-type(valid, labels.otherProjects),
      (group, _) => group,
      render,
    )
  }
}
