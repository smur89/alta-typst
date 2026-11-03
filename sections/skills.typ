// `_skills` and `_interests` share the JSON Resume `{name, keywords}`
// shape and render identically, differing only in heading.

#import "../internal/components/frame.typ": _section-frame
#import "../internal/components/keywords.typ": _keyword-rows

#let _name-keywords-section(groups, key, (labels, ..)) = _section-frame(
  labels.at(key),
  groups,
  _keyword-rows(groups),
)

#let _skills(groups, ctx) = _name-keywords-section(groups, "skills", ctx)

#let _interests(groups, ctx) = _name-keywords-section(
  groups,
  "interests",
  ctx,
)
