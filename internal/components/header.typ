// The page header, laid out from the slots `sections/header.typ` maps
// the CV and preferences onto: the name line, headline and contact bar,
// with an optional portrait and QR around them.

#import "../design/styles.typ": _part
#import "../context.typ": _body-size-state, _theme-state
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
  if photo-at in ("above", "below") {
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
    let (top, bottom) = if centred-photo == none {
      (header-text, none)
    } else if photo-at == "above" {
      (centred-photo, header-text)
    } else {
      (header-text, centred-photo)
    }
    with-qr(top)
    if bottom != none {
      v(photo-gap * body-size)
      bottom
    }
  } else {
    // QR goes opposite the photo even with no photo, so adding
    // one later doesn't move it. Absent ornaments are dropped rather
    // than left as empty cells, which would add a stray gutter.
    let (left-ornament, right-ornament) = if (
      photo-at == "left"
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

#let _headline(headline, theme, body-size) = if headline != none {
  block(spacing: 0pt, below: theme.header.headline-below * body-size, {
    set text(
      theme.type.title.size * body-size,
      fill: theme.colours.tagline,
      weight: theme.font-weight.bold,
    )
    _part("headline", headline)
  })
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
  let bar-icon = _glyph.with(size: size, fill: theme.colours.accent)
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
// `photo-at` places the photo `"left"` or `"right"` of the text, or
// centred `"above"` / `"below"` it.
#let _page-header(
  name: none,
  headline: none,
  contacts: (),
  text-align: left,
  uppercase: false,
  photo: none,
  photo-at: none,
  qr-url: none,
) = context {
  // Read once here and passed to the subcomponents.
  let body-size = _body-size-state.get()
  let theme = _theme-state.get()
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
      _headline(headline, theme, body-size)
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
