// `_skills` and `_interests` share the JSON Resume `{name, keywords}`
// shape and render identically, differing only in heading.

#import "../internal/primitives.typ": _keyword_row, _section_frame

#let _name_keywords_section(groups, key, (labels, ..)) = {
  // Drop groups with no keywords first, so a section with none left
  // skips its heading rather than rendering it bare.
  let visible = groups.filter(g => g.at("keywords", default: ()).len() > 0)
  _section_frame(labels.at(key), visible, for group in visible {
    _keyword_row(group.name, group.keywords)
  })
}

#let _skills(groups, ctx) = _name_keywords_section(groups, "skills", ctx)

#let _interests(groups, ctx) = _name_keywords_section(
  groups,
  "interests",
  ctx,
)
