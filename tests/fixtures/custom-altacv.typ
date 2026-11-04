// Every non-spec field under `custom.altacv`: custom-altacv's first
// document and custom-altacv-deprecated's reference.

#let basics = (name: "Jane Doe", email: "jane@example.com")

#let namespaced = (
  basics: basics,
  custom: (
    altacv: (
      focusAreas: (
        [Distributed systems and event-driven architecture.],
        [Developer experience and tooling.],
      ),
    ),
  ),
  languages: (
    (language: "English", fluency: "Native", custom: (altacv: (rating: 5))),
    (language: "German", fluency: "Fluent", custom: (altacv: (rating: 3.5))),
    // No fluency at all: the custom rating alone satisfies the check.
    (language: "French", custom: (altacv: (rating: 2))),
  ),
  awards: (
    (
      title: "Best Paper Award",
      awarder: "ScalaConf",
      custom: (altacv: (url: "https://example.com/best-paper")),
    ),
  ),
)
