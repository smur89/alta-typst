// Certificates: a compact entry, with date, issuer and credential ID
// on one term row so several certs stay short.

#import "../internal/util/dates.typ": _format-date-span
#import "../internal/util/fields.typ": _field
#import "../internal/components/entry.typ": _entry
#import "../internal/primitives.typ": _divider-space
#import "../internal/components/frame.typ": _section

// No `open-end`: a cert without `expiryDate` doesn't expire, so it
// never reads "Present".
#let _certificates(certs, (labels, format-date, ..)) = _section(
  labels.certificates,
  certs,
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
  // Short, uniform rows: the spacing without the rule.
  separator: _divider-space(),
)
