// Certificates — an awards-style entry, one line shorter: name
// (linked when `url` is set), then a single term row with the issue
// date (or `date – expiryDate`), the issuer and the credential ID,
// then an optional summary paragraph. Entries without a `name` are
// skipped so a stray entry can't emit an orphan heading.

#import "../internal/state.typ": _accent_state
#import "../internal/text.typ": _entry_summary, _present, styled-link
#import "../internal/primitives.typ": _section, term
#import "../internal/dates.typ": _format_date_span

#let _certificates(certs, labels, prefs) = _section(
  labels.certificates,
  certs.filter(c => _present(c.at("name", default: none))),
  cert => {
    [=== #styled-link(cert.name, dest: cert.at("url", default: none))]
    // The issuer shares the term row (bold accent, like `name()`) so a
    // section of several certs stays compact; the ID follows it bare.
    // No `open-end`: a cert without `expiryDate` doesn't expire, so
    // the period is never read as "Present".
    let issuer = cert.at("issuer", default: none)
    let id = cert.at("credentialId", default: none)
    let detail = (
      if _present(issuer) {
        context text(weight: "bold", fill: _accent_state.get(), issuer)
      },
      if _present(id) { id },
    ).filter(d => d != none)
    term(
      _format_date_span(
        cert.at("date", default: none),
        cert.at("expiryDate", default: none),
        prefs,
        labels,
      ),
      detail: if detail.len() > 0 { detail.join[ · ] },
    )
    let summary = _entry_summary(cert)
    if summary != none { par(summary) }
  },
)
