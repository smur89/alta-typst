// The page header and the intro beneath it, laid out from the slots
// `sections/header.typ` maps the CV and preferences onto: name,
// pronouns, headline and contact bar, an optional portrait and QR,
// then the objective and summary.

#import "../state.typ": _accent_state, _body_size_state
#import "../theme.typ": _theme
#import "../icons.typ": icon
#import "../qr.typ": _qr_render
#import "../text.typ": _join_present, _link_if
#import "../primitives.typ": _preamble

// `photo` and `qr` are `none` when absent.
#let _header_layout(
  header-text,
  photo,
  qr,
  qr-size,
  body-size,
  photo-at,
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

// `contacts` are `(icon, value, url)` records with an optional `alt`,
// linked where `url` is set. `photo` (a built portrait) and `qr-url`
// are `none` when absent; `photo-at` places the photo `"left"` or
// `"right"` of the text, or centred `"above"` / `"below"` it.
// `pronouns` sit outside the uppercasing: they aren't part of the name.
#let _page_header(
  name: none,
  pronouns: none,
  headline: none,
  contacts: (),
  text-align: left,
  uppercase: false,
  photo: none,
  photo-at: none,
  qr-url: none,
) = context {
  let body-size = _body_size_state.get()
  let accent = _accent_state.get()
  let (size, colour, ..) = _theme
  let (
    name-weight,
    headline-weight,
    contact-weight,
    name-below,
    pronouns-gap,
    headline: headline-size,
    headline-below,
    contact-icon,
    contact-gap,
    qr: qr-scale,
    ..,
  ) = _theme.header
  let bar-icon = icon.with(size: contact-icon * body-size, fill: accent)
  let header-text = align(text-align, {
    block(
      spacing: 0pt,
      below: name-below * body-size,
      {
        text(
          size.name * body-size,
          fill: accent,
          weight: name-weight,
          if uppercase { upper(name) } else { name },
        )
        // The `box` keeps "(they/them)" whole when a long name wraps.
        if pronouns != none {
          h(pronouns-gap * body-size)
          box(text(body-size, fill: colour.body, [(#pronouns)]))
        }
      },
    )

    if headline != none {
      block(
        spacing: 0pt,
        below: headline-below * body-size,
        text(
          headline-size * body-size,
          fill: colour.emphasis,
          weight: headline-weight,
          headline,
        ),
      )
    }

    set text(size.meta * body-size, weight: contact-weight)
    // `box` per entry so the bar wraps between entries, never between
    // an icon and its text.
    contacts
      .map(entry => box({
        bar-icon(entry.icon, alt: entry.at("alt", default: none))
        let value = [#entry.value]
        _link_if(entry.url, value)
      }))
      .join(h(contact-gap * body-size))
    // Inherits `par.spacing`, so the gap tracks the rest of the document.
    parbreak()
  })
  // Small enough to stay clear of the contact bar, large enough to
  // scan in print. Filled with `accent` to match the other ornaments.
  let qr-size = qr-scale * body-size
  _header_layout(
    header-text,
    photo,
    if qr-url != none { _qr_render(qr-url, qr-size, accent) },
    qr-size,
    body-size,
    photo-at,
  )
}

// The objective (a forward-looking goal), then the summary
// (background); either alone keeps the summary's spacing. The
// objective is set off like a pull quote so it reads apart from the
// summary without being louder than it, in colour or in a
// black-and-white print.
#let _intro_block(objective: none, summary: none) = {
  if objective != none or summary != none {
    context {
      let body-size = _body_size_state.get()
      let (above, rule, inset, gap, below) = _theme.intro
      v(above * body-size)
      _join_present(
        (
          if objective != none {
            block(
              stroke: (left: rule + _accent_state.get()),
              inset: (left: inset.left * body-size, y: inset.y * body-size),
              _preamble(objective),
            )
          },
          if summary != none { par(summary) },
        ),
        v(gap * body-size),
      )
      v(below * body-size)
    }
  }
}
