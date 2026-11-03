// `_skills` and `_interests` share the JSON Resume `{name, keywords}`
// shape, differing in heading and in weight: skills as pills, the
// keywords a reader looks for; interests as plain text.

#import "../internal/components/frame.typ": _section-frame
#import "../internal/components/keywords.typ": _keyword-rows, _label-rows

#let _skills(groups, (labels, ..)) = _section-frame(
  labels.skills,
  groups,
  _keyword-rows(groups),
)

#let _interests(groups, (labels, ..)) = _section-frame(
  labels.interests,
  groups,
  _label-rows(groups),
)
