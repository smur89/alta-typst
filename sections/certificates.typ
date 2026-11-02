// Certificates: an awards-style entry with date, issuer and credential
// ID on one term row. Entries without a `name` are skipped.

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
    // One term row keeps several certs compact. No `open-end`: a cert
    // without `expiryDate` doesn't expire, so it never reads "Present".
    // Parts take natural widths (no location column to align with), so
    // the details wrap whole rather than squeezing.
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
