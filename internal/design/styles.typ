// The paragraph, list and heading rules for everything `alta()`
// renders, from the theme `_document` builds, and `_treat`, which
// applies a named treatment. `set text` is `_document`'s
// (`document.typ`).

// A part of the CV a user can restyle (#327): `body` labelled
// `<alta-{name}>`, for `show <alta-{name}>: set text(...)` rules before
// `alta()`. `none` stays `none`. Every part is labelled through here, so
// two rules hold everywhere:
// - The label sits on the raw value, before any styling (`upper()`,
//   a treatment): a label on styled content doesn't take the rule.
//   Style around the part, e.g. `_treat(case, _part(...))`.
// - No space before the label: one renders as a real space after the
//   part.
// Labels the template uses for its own rules (`justify`'s
// `<alta-internal-prose>`) are prefixed `alta-internal-`, so they can't
// be mistaken for a public part.
#let _part(name, body) = if body != none { [#body#label("alta-" + name)] }

// Applies a named treatment (`_conventions.treatment`, the theme's
// `section.case`); `"none"` leaves the body as it is.
// `italic` sets the style where `emph` toggles it: a treatment around a
// `_part` has to be a plain setting, or a user's `style:` rule on the
// part would be flipped (`emph` turns their "normal" italic).
#let _treatments = (
  emph: emph,
  italic: b => {
    set text(style: "italic")
    b
  },
  strong: strong,
  upper: upper,
  "none": b => b,
)
#let _treat(name, body) = _treatments.at(name)(body)

// Places an inline graphic on the surrounding text by one rule:
// glyphs stand on the baseline (`to: "baseline"`: `body` as it is, as
// a FontAwesome glyph is drawn to, #211), drawn shapes centre on the
// x-height, measured in context so they line up whatever the font,
// size or neighbours.
#let _inline(body, to: "x-height") = if to == "baseline" { body } else {
  context {
    let height = measure(body).height
    let reference = measure(text(
      top-edge: to,
      bottom-edge: "baseline",
      "x",
    )).height
    box(baseline: (height - reference) / 2, body)
  }
}

// The block a `===` / `====` heading sits in: its `subheading` role's
// spacing, kept with what follows. An entry's first lines
// (`_entry-head`) sit in the same block, so the two can't drift.
#let _subheading-block((above, below, ..), body-size, body) = block(
  above: above * body-size,
  below: below * body-size,
  sticky: true,
  body,
)

// For `show: _content-styles.with(body-size, theme, justify)`, with
// the built theme (`_theme-for`).
// Levels: 2 section title, 3 role / qualification, 4 sub-grouping
// (e.g. publication type). `justify` justifies prose only, lists and
// the paragraphs labelled `<alta-internal-prose>`, so rows of facts, names or
// pills never stretch; Typst then hyphenates it too
// (`text.hyphenate` is `auto`).
#let _content-styles(body-size, theme, justify, body) = {
  let (
    par: p,
    list: l,
    section,
    subheading,
    type: ty,
    stroke-width: sw,
    colours,
    ..,
  ) = theme
  set par(leading: p.leading, spacing: p.spacing)
  show list: set par(justify: justify)
  show <alta-internal-prose>: set par(justify: justify)
  set list(
    marker: [•],
    indent: 0pt,
    body-indent: l.body-indent * body-size,
    spacing: l.spacing,
  )
  let (above, rule-gap, below, case, tracking) = section
  // Each heading's body is a `_part` labelled inside the rule: a user's
  // rule on `heading` itself can't override what this transform sets,
  // as it runs inside the heading.
  // Matched by role (an internal label), not level: a heading's level
  // is its outline depth (`components/frame.typ`). The name is the one
  // level-1 heading, drawn as it is (`components/header.typ`).
  show <alta-internal-name>: it => it.body
  show <alta-internal-section>: it => block(sticky: true)[
    #v(above * body-size)
    #{
      set text(
        ty.headline.size * body-size,
        fill: colours.heading,
        weight: ty.headline.weight,
        tracking: tracking,
      )
      _treat(case, _part("section-title", it.body))
    }
    #v(rule-gap * body-size)
    // The stroke is `set` around the `section-rule` part, so a user's
    // `show <alta-section-rule>: set line(...)` overrides it.
    #{
      set line(stroke: sw.thick + colours.headingRule)
      _part("section-rule", line(length: 100%))
    }
    #v(below * body-size)
  ]
  let sub-heading(role, fill, part) = it => _subheading-block(
    role,
    body-size,
    {
      set text(ty.title.size * body-size, fill: fill, weight: role.weight)
      _part(part, it.body)
    },
  )
  show <alta-internal-entry>: sub-heading(
    subheading.entry,
    colours.emphasis,
    "entry-title",
  )
  // In the accent by default, so a group reads apart from the entries
  // under it.
  show <alta-internal-group>: sub-heading(
    subheading.group,
    colours.subheading,
    "group-title",
  )
  body
}
