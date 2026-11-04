// The page header, laid out from the slots `sections/header.typ` maps
// the CV and preferences onto: the name line, headline and contact bar,
// with an optional portrait and QR around them.

#import "../design/theme.typ": _theme
#import "../context.typ": _accent-state, _body-size-state
#import "../icons.typ": icon
#import "../primitives.typ": _link-if
#import "qr.typ": _qr-render

// `photo` and `qr` are `none` when absent.
#let _header-layout(
  header-text,
  qr-size,
  body-size,
  photo: none,
  qr: none,
  photo-at: none,
) = {
  let (ornament-gutter, photo-gap, ..) = _theme.header
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

// A `title` element, so a user's `show title: set text(...)` restyles
// it (its font, say) as `show heading` does the headings, and tagged
// PDF reads it as the document's title.
#let _name-line(name, body-size, accent) = block(
  spacing: 0pt,
  below: _theme.header.name-below * body-size,
  title(text(
    _theme.type.display.size * body-size,
    fill: accent,
    weight: _theme.type.display.weight,
    name,
  )),
)

#let _headline(headline, body-size) = if headline != none {
  block(
    spacing: 0pt,
    below: _theme.header.headline-below * body-size,
    text(
      _theme.type.title.size * body-size,
      fill: _theme.colour.emphasis,
      weight: _theme.font-weight.bold,
      headline,
    ),
  )
}

// `contacts` are rows, each its own line, of `(icon, value, url)`
// records with an optional `alt`, linked where `url` is set. A `box`
// per entry, so a long row wraps between entries, never between an
// icon and its text. The bar's text styles are `set` around the
// entries and each value is labelled `<alta-contact>`, so a user's
// `show <alta-contact>: set text(...)` overrides them.
#let _contact-bar(contacts, body-size, accent) = {
  let contact-gap = _theme.header.contact-gap
  let size = _theme.header.contact-size * body-size
  let bar-icon = icon.with(size: size, fill: accent)
  set text(size, weight: _theme.font-weight.bold)
  contacts
    .map(row => row
      .map(entry => box({
        bar-icon(entry.icon, alt: entry.at("alt", default: none))
        _link-if(entry.url, [#entry.value <alta-contact>])
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
  let accent = _accent-state.get()
  // Small enough to stay clear of the contact bar, large enough to
  // scan in print. Filled with `accent` to match the other ornaments.
  let qr-size = _theme.header.qr * body-size
  _header-layout(
    align(text-align, {
      _name-line(if uppercase { upper(name) } else { name }, body-size, accent)
      _headline(headline, body-size)
      _contact-bar(contacts, body-size, accent)
    }),
    qr-size,
    body-size,
    photo: photo,
    qr: if qr-url != none { _qr-render(qr-url, qr-size, accent) },
    photo-at: photo-at,
  )
}
