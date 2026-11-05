// The paragraph, list and heading rules for everything `alta()`
// renders, from the theme `_document` builds. `set text` is
// `_document`'s (`document.typ`).

// A part of the CV a user can restyle (#327): `body` labelled
// `<alta-{name}>`, for `show <alta-{name}>: set text(...)` rules before
// `alta()`. `none` stays `none`. Every part is labelled through here, so
// two rules hold everywhere:
// - The label sits on the raw value, before any styling (`upper()`,
//   a treatment): a label on styled content doesn't take the rule.
//   Style around the part, e.g. `case(_part(...))`.
// - No space before the label: one renders as a real space after the
//   part.
// Labels the template uses for its own rules (`justify`'s
// `<alta-internal-prose>`) are prefixed `alta-internal-`, so they can't
// be mistaken for a public part.
#let _part(name, body) = if body != none { [#body#label("alta-" + name)] }

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

// For `show: _content-styles.with(theme, justify)`, with the built
// theme (`_theme-for`).
// Levels: 2 section title, 3 role / qualification, 4 sub-grouping
// (e.g. publication type). `justify` justifies prose only, lists and
// the paragraphs labelled `<alta-internal-prose>`, so rows of facts, names or
// pills never stretch; Typst then hyphenates it too
// (`text.hyphenate` is `auto`).
#let _content-styles(theme, justify, body) = {
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
    body-indent: l.body-indent * 1em,
    spacing: l.spacing,
  )
  let (above, rule-gap, below, case, tracking) = section
  // A heading's colour, weight and tracking are show-set rules on it,
  // so a later rule on `heading` overrides them; its size is set
  // inside, on its `_part`, which a rule on the part reaches. Inside a
  // heading the body size is read in context, dividing out Typst's
  // own heading size (`tests/unit/headings.typ` guards it), so a rule
  // setting a heading's size scales its title and spacing together; a
  // rule on `<alta-section-title>` sets the title's size alone.
  // Matched by role (an internal label), not level: a heading's level
  // is its outline depth (`components/frame.typ`). The name is the one
  // level-1 heading, drawn as it is (`components/header.typ`).
  show <alta-internal-name>: it => it.body
  show <alta-internal-section>: set text(
    fill: colours.heading,
    weight: ty.headline.weight,
    tracking: tracking,
  )
  show <alta-internal-section>: it => block(sticky: true, context {
    // Typst sets a level-2 heading's text at 1.2em of the body's.
    let body-size = text.size / 1.2
    v(above * body-size)
    {
      set text(ty.headline.size * body-size)
      case(_part("section-title", it.body))
    }
    v(rule-gap * body-size)
    // The stroke is `set` around the `section-rule` part, so a user's
    // `show <alta-section-rule>: set line(...)` overrides it.
    {
      set line(stroke: sw.thick + colours.heading-rule)
      _part("section-rule", line(length: 100%))
    }
    v(below * body-size)
  })
  // Typst keeps level 3 and deeper at the body's size.
  let sub-heading(role, part) = it => context _subheading-block(
    role,
    text.size,
    {
      set text(ty.title.size * text.size)
      _part(part, it.body)
    },
  )
  show <alta-internal-entry>: set text(
    fill: colours.emphasis,
    weight: subheading.entry.weight,
  )
  show <alta-internal-entry>: sub-heading(subheading.entry, "entry-title")
  // In the accent by default, so a group reads apart from the entries
  // under it.
  show <alta-internal-group>: set text(
    fill: colours.subheading,
    weight: subheading.group.weight,
  )
  show <alta-internal-group>: sub-heading(subheading.group, "group-title")
  body
}
