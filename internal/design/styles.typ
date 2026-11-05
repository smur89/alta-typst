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

// For `show: _base-styles.with(theme)`, with the built theme
// (`_theme-for`): the paragraph and list rules every page renders
// under, the template's and standalone `alta()`'s.
#let _base-styles(theme, body) = {
  let (par: p, list: l, ..) = theme
  set par(leading: p.leading, spacing: p.spacing)
  set list(
    marker: [•],
    indent: 0pt,
    body-indent: l.body-indent * 1em,
    spacing: l.spacing,
  )
  body
}

// For `show: _label-headings.with(theme)`: standalone `alta()`'s
// heading rules (`_standalone`), matched by internal label at today's
// levels (2 section title, 3 role / qualification, 4 sub-grouping,
// e.g. publication type), and removed with it in the next major
// (#239); the template's are `_level-headings`.
#let _label-headings(theme, body) = {
  let (
    section,
    subheading,
    type: ty,
    stroke-width: sw,
    colours,
    ..,
  ) = theme
  let (above, rule-gap, below, case, tracking) = section
  // Colour, weight and tracking are show-set rules, so a later rule on
  // `heading` overrides them; the size sits on the title's `_part`, from
  // the body size read in context (`tests/unit/headings.typ`).
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

// For `show: _level-headings.with(theme)`, the template's heading
// scheme (#373): the name is the `title` element, sections are level
// 1, groups level 2, an entry one level below its section or group.
// Every look is a show-set rule, so a user's rule after the template
// overrides it exactly; a size is the theme's over Typst's own (title
// 1.7em, level 1 1.4em, level 2 1.2em, deeper 1em:
// `tests/unit/headings.typ`), and spacing is in `em` of the heading,
// as Typst's own is. Transforms only add structure: the rule under a
// section title, the sticky blocks.
#let _level-headings(theme, body) = {
  let (
    section,
    subheading,
    type: ty,
    stroke-width: sw,
    colours,
    header,
    ..,
  ) = theme
  let (above, rule-gap, below, case, tracking) = section
  show title: set text(
    size: ty.display.size / 1.7 * 1em,
    fill: colours.name,
    weight: ty.display.weight,
  )
  // The name arrives labelled (`components/header.typ`).
  show title: it => block(
    spacing: 0pt,
    below: header.name-below / ty.display.size * 1em,
    it.body,
  )
  show heading.where(level: 1): set text(
    size: ty.headline.size / 1.4 * 1em,
    fill: colours.heading,
    weight: ty.headline.weight,
    tracking: tracking,
  )
  // In `em` of the section title: the theme's spacing over the body's.
  let em(v) = v / ty.headline.size * 1em
  // Typst sets a heading `above` what precedes it, and the rule below
  // the title too, as the rule's block inherits it: 1.8× the body at
  // level 1, 1.44× at level 2 (`tests/unit/headings.typ`). Standalone's
  // sections are level 2, so level 2's puts a section where standalone
  // does.
  show heading.where(level: 1): set block(above: em(1.44))
  show heading.where(level: 1): it => block(sticky: true, {
    v(em(above))
    case(_part("section-title", it.body))
    v(em(rule-gap))
    {
      set line(stroke: sw.thick + colours.heading-rule)
      _part("section-rule", line(length: 100%))
    }
    v(em(below))
  })
  // Level 2 is a group or an entry under a section, told apart by the
  // entry's label. Level 3 is only ever an entry under a group, so an
  // unlabelled `===` the user writes keeps Typst's own style.
  let entry-3 = selector(heading.where(level: 3)).and(<alta-internal-entry>)
  show heading.where(level: 2): set text(size: ty.title.size / 1.2 * 1em)
  show entry-3: set text(size: ty.title.size * 1em)
  show heading.where(level: 2): set text(
    fill: colours.subheading,
    weight: subheading.group.weight,
  )
  show <alta-internal-entry>: set text(
    fill: colours.emphasis,
    weight: subheading.entry.weight,
  )
  show heading.where(level: 2).or(heading.where(level: 3)): it => {
    let entry = it.at("label", default: none) == <alta-internal-entry>
    if it.level == 3 and not entry { return it }
    let (role, part) = if entry { (subheading.entry, "entry-title") } else {
      (subheading.group, "group-title")
    }
    _subheading-block(role, 1em / ty.title.size, _part(part, it.body))
  }
  body
}

// For `show: _justify.with(on)`: justify and hyphenate prose only,
// lists and the paragraphs labelled `<alta-internal-prose>`, so rows of
// facts, names or pills never stretch. Applied by `alta()`: `justify`
// is a CV preference, not the template's.
#let _justify(on, body) = {
  show list: set par(justify: on)
  show <alta-internal-prose>: set par(justify: on)
  body
}
