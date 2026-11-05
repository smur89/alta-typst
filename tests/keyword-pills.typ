// An entry's keywords back as pills, through the `<alta-keyword>` part
// and the `separator.keywords` token: `tag()` draws each keyword as a
// skill pill does, and an empty separator leaves the pills' own gap
// between them, wrapped rows included. A project's keywords and an
// education's courses both take it.

#import "../lib.typ": alta, tag

#show <alta-keyword>: it => tag(it)

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
