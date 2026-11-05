// An entry's keywords as pills: `tag()` on each `<alta-keyword>`, an
// empty `separator.keywords`, and `<alta-keywords>` set to skill-row
// spacing for wrapped rows. A project's keywords and an education's
// courses both take it.

#import "/lib.typ": alta, tag

#show <alta-keyword>: it => tag(it)
#show <alta-keywords>: set par(leading: 0.8em, spacing: 0.8em)

#alta(
  (
    basics: (name: "Jane Doe"),
    projects: (
      (
        name: "Event pipeline",
        entity: "Acme Corp",
        startDate: "2023-01",
        summary: "Streaming ingestion for the analytics platform.",
        keywords: (
          "Scala",
          "Kafka",
          "Kubernetes",
          "Terraform",
          "Prometheus",
          "Grafana",
          "PostgreSQL",
          "Redis",
          "gRPC",
          "OpenTelemetry",
          "Argo CD",
        ),
      ),
    ),
    education: (
      (
        institution: "Trinity College Dublin",
        studyType: "B.A.",
        area: "Computer Science",
        startDate: "2012",
        endDate: "2016",
        courses: ("Distributed Systems", "Compilers"),
      ),
    ),
  ),
  preferences: (theme: (separator: (keywords: ""))),
)
