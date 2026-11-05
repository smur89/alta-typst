// The page header, laid out from the slots `sections/header.typ` maps
// the CV and preferences onto: the name line, headline, objective and
// contact bar, with an optional portrait and QR around them.

#import "../design/styles.typ": _part
#import "../context.typ": _theme
#import "../icons.typ": _glyph
#import "../primitives.typ": _link-if
#import "qr.typ": _qr-render

// `photo` and `qr` are `none` when absent.
#let _header-layout(
  header-text,
  qr-size,
  theme,
  body-size,
  photo: none,
  qr: none,
  photo-at: none,
) = {
  let (ornament-gutter, photo-gap, ..) = theme.header
  // Full-width `block` centres the photo against the page (a bare
  // `align(center, box)` centres against the inline position). The
  // `qr-size` spacer balances the QR so the content stays centred
  // page-wise. Only the top row gets the QR grid, so the QR stays at
  // the header's top corner whichever way the stack runs. The row gap
  // is an explicit `v(...)` because block spacing inside a grid cell
  // is consumed by the cell.
  if photo-at in (top, bottom) {
    let centred-photo = if photo != none {
      block(width: 100%, align(center, photo))
    }
    let with-qr(content) = if qr == none {
      content
    } else {
      grid(
        columns: (auto, 1fr, auto),
        align: top,
        column-gutter: ornament-gutter,
        qr, content, box(width: qr-size),
      )
    }
    let (first, second) = if centred-photo == none {
      (header-text, none)
    } else if photo-at == top {
      (centred-photo, header-text)
    } else {
      (header-text, centred-photo)
    }
    with-qr(first)
    if second != none {
      v(photo-gap * body-size)
      second
    }
  } else {
    // QR goes opposite the photo even with no photo, so adding
    // one later doesn't move it. Absent ornaments are dropped rather
    // than left as empty cells, which would add a stray gutter.
    let (left-ornament, right-ornament) = if (
      photo-at == left
    ) {
      (photo, qr)
    } else {
      (qr, photo)
    }
    let cells = (
      (left-ornament, auto),
      (header-text, 1fr),
      (right-ornament, auto),
    ).filter(((cell, _)) => cell != none)
    if cells.len() == 1 {
      header-text
    } else {
      grid(
        columns: cells.map(((_, col)) => col),
        align: top,
        column-gutter: ornament-gutter,
        ..cells.map(((cell, _)) => cell),
      )
    }
  }
}

// The CV's one level-1 heading, so tagged PDF and the bookmarks nest
// the sections under the person, and a user's
// `show heading.where(level: 1)` rule restyles it (its font, say) as
// `heading.where(level: 2)` does the sections. Its styles are `set`
// around `name`, which arrives labelled (`_page-header`).
#let _name-line(name, theme, body-size) = block(
  spacing: 0pt,
  below: theme.header.name-below * body-size,
  [#heading(level: 1, {
    set text(
      theme.type.display.size * body-size,
      fill: theme.colours.name,
      weight: theme.type.display.weight,
    )
    name
  })<alta-internal-name>],
)

// A line of the header's text, `below` apart from the next.
#let _header-line(below, body) = block(spacing: 0pt, below: below, body)

// The headline, then the objective (a forward-looking goal) close
// under it, so the two read as one unit: who, then what next. The
// objective is set apart as a summary's preamble is
// (`treatment.preamble`, italic by default). It is `<alta-objective>`
// inside `<alta-summary>`, the part it was until it moved into the
// header, so a rule on either reaches it.
#let _headline(headline, objective, theme, body-size) = {
  let (headline-below, objective-gap, ..) = theme.header
  if headline != none {
    _header-line(
      if objective != none { objective-gap } else { headline-below }
        * body-size,
      {
        set text(
          theme.type.title.size * body-size,
          fill: theme.colours.tagline,
          weight: theme.font-weight.bold,
        )
        _part("headline", headline)
      },
    )
  }
  if objective != none {
    _header-line(headline-below * body-size, (theme.treatment.preamble)(
      // `#[]` gives the outer label an element of its own.
      _part("summary", [#_part("objective", objective)#[]]),
    ))
  }
}

// `contacts` are rows, each its own line, of `(glyph, value, url)`
// records with an optional `alt`, linked where `url` is set. `glyph`
// is a FontAwesome name, Solid or a brand mark (`_glyph`'s default
// `solid: true` draws either). A `box` per entry, so a long row wraps
// between entries, never between an icon and its text. The bar's text
// styles are `set` around the entries, each a `_part`.
#let _contact-bar(contacts, theme, body-size) = {
  let contact-gap = theme.header.contact-gap
  let size = theme.header.contact-size * body-size
  // The gap after the icon is the body's, not the bar's smaller text's.
  let bar-icon = _glyph.with(
    size: size,
    fill: theme.colours.accent,
    gap: theme.icon.gap * body-size,
  )
  set text(size, weight: theme.font-weight.bold)
  contacts
    .map(row => row
      .map(entry => box({
        bar-icon(entry.glyph, alt: entry.at("alt", default: none))
        _link-if(entry.url, _part("contact", entry.value))
      }))
      .join(h(contact-gap * body-size)))
    .join(linebreak())
  // Inherits `par.spacing`, so the gap tracks the rest of the document.
  parbreak()
}

// `photo` (a built portrait) and `qr-url` are `none` when absent;
// `photo-at` is the side of the text the photo takes: `left` or
// `right`, or centred at the `top` or `bottom`.
#let _page-header(
  name: none,
  headline: none,
  objective: none,
  contacts: (),
  text-align: left,
  uppercase: false,
  photo: none,
  photo-at: none,
  qr-url: none,
) = context {
  let body-size = text.size
  let theme = _theme()
  // Small enough to stay clear of the contact bar, large enough to
  // scan in print. Filled with `accent` to match the other ornaments.
  let qr-size = theme.header.qr * body-size
  _header-layout(
    align(text-align, {
      let name = _part("name", name)
      _name-line(
        if uppercase { upper(name) } else { name },
        theme,
        body-size,
      )
      _headline(headline, objective, theme, body-size)
      _contact-bar(contacts, theme, body-size)
    }),
    qr-size,
    theme,
    body-size,
    photo: photo,
    qr: if qr-url != none {
      _qr-render(qr-url, qr-size, theme.colours.accent)
    },
    photo-at: photo-at,
  )
}
