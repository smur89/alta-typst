// Non-ASCII content in name, location, and other fields. Exercises
// _url_encode's multi-byte UTF-8 path (Zürich) and verifies that
// accented + non-Latin characters survive the contact-bar / header
// emission unchanged.

#import "../lib.typ": alta

#alta((
  basics: (
    name: "Renée Bäumler",
    label: "Software-Ingenieurin",
    summary: [Backend-Entwicklerin mit Fokus auf verteilte Systeme.],
    email: "renee@example.com",
    phone: "+41 44 555 0100",
    location: "Zürich, Schweiz",
    profiles: (
      (network: "GitHub", username: "renée", url: "https://github.com/renee"),
      (network: "X",      username: "renée", url: "https://x.com/renee"),
    ),
  ),
  work: (
    (
      name: "Müller & Söhne AG",
      position: "Senior Engineer",
      location: "Zürich, Schweiz",
      startDate: "Jan 2022",
      highlights: ([Entwarf ein ereignisgesteuertes System mit Kafka.],),
    ),
  ),
  languages: (
    (language: "Deutsch",    fluency: "Native"),
    (language: "Français",   rating: 4),
    (language: "Português",  rating: 2.5),
  ),
))
