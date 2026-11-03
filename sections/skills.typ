// `_skills` and `_interests` share the JSON Resume `{name, keywords}`
// shape and render identically, differing only in heading.

#import "../internal/components/frame.typ": _section-frame
#import "../internal/components/keywords.typ": _keyword-rows

#let _name-keywords-section(groups, key, (labels, ..)) = {
  // Drop groups with no keywords first, so a section with none left
  // skips its heading rather than rendering it bare.
  let visible = groups.filter(g => g.at("keywords", default: ()).len() > 0)
  _section-frame(labels.at(key), visible, _keyword-rows(visible))
}

#let _skills(groups, ctx) = _name-keywords-section(groups, "skills", ctx)

#let _interests(groups, ctx) = _name-keywords-section(
  groups,
  "interests",
  ctx,
)
