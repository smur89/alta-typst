// Demonstration of the cover-letter companion entrypoint. Reuses the
// same `cv` dict as examples/example.typ so a real caller can keep a
// single data file for both documents. Only `basics` is consumed by
// `cover-letter` — the rest of the dict is ignored, so the same
// `cv` works untouched.
//
// Build locally with:
//   typst compile --root .. cover_letter.typ cover_letter.pdf

#import "../lib.typ": cover-letter

#let cv = (
  basics: (
    name: "Seán Ó Murchú",
    label: "Senior Software Engineer",
    email: "sean@example.com",
    phone: "+353 1 555 0100",
    location: "Tallaght, Dublin",
    image: read("avatar-placeholder.svg", encoding: none),
    profiles: (
      (network: "LinkedIn", username: "seanomurchu",     url: "https://linkedin.com/in/seanomurchu"),
      (network: "GitHub",   username: "seanomurchu",     url: "https://github.com/seanomurchu"),
      (network: "Website",  username: "seanomurchu.dev", url: "https://seanomurchu.dev"),
    ),
  ),
)

#cover-letter(
  cv,
  recipient: [
    Hiring Manager \
    Acme Corp \
    1 Acme Plaza \
    Dublin 2, Ireland
  ],
  date: "12 June 2026",
  salutation: [Dear Hiring Manager,],
  [
    I am writing to express my interest in the Senior Backend Engineer
    role at Acme Corp. The team's focus on event-driven systems and
    developer experience lines up closely with the work I have spent
    the last eight years doing — and the kind of work I would like to
    keep doing.

    At my current role I led the migration of a customer-facing
    monolith into a set of event-driven microservices, halving p99
    latency, and rolled out an event-sourcing platform now used by
    four product teams. The combination of distributed-systems depth
    and a deliberate investment in tooling and CI/CD is what I would
    bring to Acme.

    I would welcome the chance to discuss how my background could fit
    the team's plans. Thank you for considering my application.
  ],
)
