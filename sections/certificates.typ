// Certificates — pill-row rendering with optional issuer grouping.
// Multi-issuer clusters get a labelled-divider header; singleton
// issuers pool into a trailing unlabelled group.

#import "../internal/state.typ": _body_size_state
#import "../internal/text.typ": _present
#import "../internal/primitives.typ": _group_by, _labelled_divider, divider, tag
#import "../internal/icons.typ": icon
#import "../internal/dates.typ": _format_date_span

// Normalises a cert into the (name, date, expiryDate, url, issuer)
// record the renderer consumes; `none` when there's no usable name.
// Optional fields collapse to `none` when empty so downstream
// nil-checks don't render orphans; "no issuer" (missing / `none` /
// "") normalises to "" because Typst dict keys can't be `none`.
#let _normalise_cert(cert) = {
  let name = cert.at("name", default: "")
  if not _present(name) { return none }
  let optional(key) = {
    let value = cert.at(key, default: none)
    if _present(value) { value }
  }
  let issuer = cert.at("issuer", default: "")
  (
    name: name,
    date: optional("date"),
    expiryDate: optional("expiryDate"),
    url: optional("url"),
    issuer: if issuer == none { "" } else { issuer },
  )
}

// Buckets by issuer in insertion order; multi-issuer clusters survive
// as their own group keyed by the shared issuer, singletons pool into
// a trailing heterogeneous group with no issuer label.
//
// Returns an array of `(issuer, items)` records. `items` carries full
// `_normalise_cert` records so the renderer can emit inline dates and
// link wrapping without re-reading the source.
// `issuer` is `none` for the trailing singleton group (its certs come
// from different issuers, so no single label fits) or for clusters
// whose `issuer` field is missing / empty.
#let _build_cert_groups(certs) = {
  let by-issuer = _group_by(
    certs.map(_normalise_cert).filter(c => c != none),
    c => c.issuer,
  )
  let groups = ()
  let singletons = ()
  for (issuer, items) in by-issuer.pairs() {
    if items.len() > 1 {
      groups.push((
        issuer: if issuer == "" { none } else { issuer },
        items: items,
      ))
    } else {
      singletons.push(items.first())
    }
  }
  if singletons.len() > 0 { groups.push((issuer: none, items: singletons)) }
  groups
}

// Builds a pill body containing the cert name and, when dated, a
// middot separator + small calendar icon + period — all in the pill's
// own text rendering. The icon and period are wrapped in a box so they
// never break across lines; only the middot's surrounding space is a
// valid break point if the pill has to wrap. The period is `date`, or
// `date – expiryDate` for a cert that expires, routed through
// `_format_date_span` so it honours `preferences.dateFormat` the same
// way the work / education / awards / publications dates do. No
// `open-end`: a cert without `expiryDate` doesn't expire, so the end
// is left off rather than read as "Present".
#let _cert_tag(item, prefs, labels) = context {
  let body-size = _body_size_state.get()
  let period = _format_date_span(item.date, item.expiryDate, prefs, labels)
  let body = if period != none {
    let cal = icon("calendar", size: 0.75 * body-size, shift: 0.1 * body-size)
    let bullet = h(0.35 * body-size) + [·] + h(0.35 * body-size)
    [#item.name#bullet#box[#cal#period]]
  } else {
    [#item.name]
  }
  let pill = tag(body)
  if item.url != none { link(item.url, pill) } else { pill }
}

#let _certificates(certs, labels, prefs) = {
  if certs.len() == 0 { return }
  // Decide whether to emit the heading *after* filtering — otherwise
  // a list of certs whose `name` is empty would still render a bare
  // "Certifications" heading with nothing under it.
  //
  // Each group is `(issuer, items)` where `items` carries full
  // `_normalise_cert` records. In flat (non-grouped) mode each cert
  // becomes its own one-element "group" with no issuer label so the
  // row flows as a single uniformly-pilled strip.
  let groups = if prefs.groupCertificates {
    _build_cert_groups(certs)
  } else {
    let items = certs.map(_normalise_cert).filter(c => c != none)
    if items.len() > 0 { ((issuer: none, items: items),) } else { () }
  }
  if groups.len() == 0 { return }
  [== #labels.certificates]
  // Each group's issuer (when present) leads its row as a labelled
  // dashed divider — replacing the plain inter-group divider with one
  // that names the issuer. Groups without an issuer (the pooled
  // singletons cluster, or every group in flat mode) get the plain
  // divider; the first group is preceded by no divider regardless so
  // the section starts flush against the heading.
  for (i, g) in groups.enumerate() {
    if g.issuer != none { _labelled_divider(g.issuer) } else if i > 0 {
      divider()
    }
    block(breakable: false, {
      for item in g.items { _cert_tag(item, prefs, labels) }
    })
  }
}
