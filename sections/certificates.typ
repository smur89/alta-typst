// Certificates — an awards-style entry, one line shorter: name
// (linked when `url` is set), then a single term row with the issue
// date (or `date – expiryDate`), the issuer and the credential ID,
// then an optional summary paragraph. Entries without a `name` are
// skipped so a stray entry can't emit an orphan heading.

#import "../internal/text.typ": _entry_summary, _present, styled-link
#import "../internal/primitives.typ": (
  _accent_strong, _section, _term_part, _term_row,
)
#import "../internal/dates.typ": _format_date_span

#let _certificates(certs, (labels, prefs, ..)) = _section(
  labels.certificates,
  certs.filter(c => _present(c.at("name", default: none))),
  cert => {
    [=== #styled-link(cert.name, dest: cert.at("url", default: none))]
    // One term row keeps a section of several certs compact: the
    // period, then the issuer (bold accent, as `name()` sets it) and
    // the bare ID. No `open-end`: a cert without `expiryDate` doesn't
    // expire, so the period is never read as "Present". The parts take
    // their natural widths (no location column to line up with), and
    // the details move to the next line whole rather than squeezing it.
    let issuer = cert.at("issuer", default: none)
    let id = cert.at("credentialId", default: none)
    let period = _format_date_span(
      cert.at("date", default: none),
      cert.at("expiryDate", default: none),
      prefs,
      labels,
    )
    let details = (
      if _present(issuer) { _accent_strong(issuer) },
      if _present(id) { id },
    )
      .filter(d => d != none)
      .join[ · ]
    if period != none or details != none {
      _term_row({
        _term_part("calendar", period, width: auto)
        if period != none and details != none { h(1em) }
        if details != none { box(details) }
      })
    }
    let summary = _entry_summary(cert)
    if summary != none { par(summary) }
  },
)
