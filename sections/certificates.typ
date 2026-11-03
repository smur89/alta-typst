// Certificates: a compact entry, with date, issuer and credential ID
// on one term row so several certs stay short. Entries without a
// `name` are skipped.

#import "../internal/util/dates.typ": _format-date-span
#import "../internal/util/fields.typ": _field
#import "../internal/components/entry.typ": _entry
#import "../internal/components/frame.typ": _section

// No `open-end`: a cert without `expiryDate` doesn't expire, so it
// never reads "Present".
#let _certificates(certs, (labels, format-date, ..)) = _section(
  labels.certificates,
  certs.filter(c => _field(c, "name") != none),
  cert => _entry(
    title: cert.name,
    url: _field(cert, "url"),
    compact: true,
    org: _field(cert, "issuer"),
    details: (_field(cert, "credentialId"),),
    period: _format-date-span(
      _field(cert, "date"),
      _field(cert, "expiryDate"),
      format-date,
    ),
    summary: _field(cert, "summary"),
  ),
)
