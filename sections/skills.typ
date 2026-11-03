// `_skills` and `_interests` share the JSON Resume `{name, keywords}`
// shape and render identically, differing only in heading.

#import "../internal/state.typ": _body_size_state
#import "../internal/primitives.typ": _keyword_row
#import "../internal/components/frame.typ": _section_frame

#let _name_keywords_section(groups, key, (labels, ..)) = {
  // Drop groups with no keywords first, so a section with none left
  // skips its heading rather than rendering it bare.
  let visible = groups.filter(g => g.at("keywords", default: ()).len() > 0)
  _section_frame(labels.at(key), visible, context {
    let body-size = _body_size_state.get()
    for group in visible { _keyword_row(body-size, group.name, group.keywords) }
  })
}

#let _skills(groups, ctx) = _name_keywords_section(groups, "skills", ctx)

#let _interests(groups, ctx) = _name_keywords_section(
  groups,
  "interests",
  ctx,
)
