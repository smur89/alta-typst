// `_skills` and `_interests` share the JSON Resume `{name, keywords}`
// shape, differing in heading and in weight: skills as pills, the
// keywords a reader looks for; interests as plain text.

#import "../internal/util/fields.typ": _field
#import "../internal/data/cv.typ": _skill-levels, _term-rating
#import "../internal/components/frame.typ": _section-frame
#import "../internal/components/keywords.typ": _keyword-rows, _label-rows
#import "../internal/components/ratings.typ": _rating-dots

// A group's `level` after its label, per `skill-level-display`: dots
// where it has a rating (`auto`, `"rating"`), else its text.
#let _level-mark(group, prefs) = {
  let value = if prefs.skill-level-display != "text" {
    _term-rating(group, "level", _skill-levels, prefs.max-rating)
  }
  if value != none { _rating-dots(value, prefs.max-rating) } else {
    _field(group, "level")
  }
}

#let _skills(groups, (labels, prefs, ..)) = _section-frame(
  labels.skills,
  groups,
  _keyword-rows(groups.map(g => g + (mark: _level-mark(g, prefs)))),
)

#let _interests(groups, (labels, ..)) = _section-frame(
  labels.interests,
  groups,
  _label-rows(groups),
)
