// JSON Resume 1.7.0 `references[].availableOnRequest`: "show 'available
// on request' rather than publishing the reference". Three documents:
//
//   1. Mixed — a quoted reference, a named referee on request (name +
//      `labels.referencesAvailableOnRequest` in place of the quote), an
//      entry with both a quote and the flag (the flag wins, the quote
//      stays private), and a non-boolean flag (ignored, so the
//      quote-less entry is skipped as before).
//   2. Every entry on request — one line under the heading, no names,
//      the same output as `preferences.referencesAvailableOnRequest`.
//   3. Every entry on request with a translated label.

#import "/lib.typ": alta

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  references: (
    (
      name: "Dr Ada Lovelace",
      reference: "A calm, methodical engineer. Recommended without reservation.",
    ),
    (name: "Grace Hopper", availableOnRequest: true),
    (
      name: "Alan Turing",
      reference: "This quote stays private.",
      availableOnRequest: true,
    ),
    // Not a boolean: ignored, and with no quote the entry is skipped.
    (name: "Not Shown", availableOnRequest: "yes"),
  ),
))

#pagebreak()

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  references: (
    (name: "Grace Hopper", availableOnRequest: true),
    (name: "Alan Turing", availableOnRequest: true),
  ),
))

#pagebreak()

#alta(
  (
    basics: (name: "Jane Doe", email: "jane@example.com"),
    references: ((name: "Grace Hopper", availableOnRequest: true),),
  ),
  labels: (referencesAvailableOnRequest: "Referenzen auf Anfrage."),
)
