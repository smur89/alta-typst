// Demonstration of the altacv template. Renders a fictional CV
// covering the sections users hit most often, with the high-signal
// surfaces (work, skills, languages, education, certificates, awards,
// publications) shaped to fit on page 1 — that page is the README
// preview image. Lower-priority sections (projects, volunteer,
// interests) sit on page 2 so they're still exercised by the build
// but don't crowd the preview.
//
// Dates use the `years-ago` / `year-only` / `date-ago` helpers below,
// anchored to a static `today` constant. Bump `today` annually to
// rebase every relative date in one place — the CV always reads as
// "current" without rewriting the example.
//
// Build locally with:
//   typst compile --root .. example.typ example.pdf

#import "../lib.typ": alta

// Static anchor — bump annually so the example dates stay roughly
// current. Every relative-date helper below derives from this so we
// only have to edit one place.
#let today = datetime(year: 2026, month: 6, day: 14)
#let years-ago(n) = (today - duration(days: 365 * n)).display("[year]-[month]")
#let year-only(n) = (today - duration(days: 365 * n)).display("[year]")
#let date-ago(n) = (today - duration(days: 365 * n)).display("[year]-[month]-[day]")

#let cv = (
  basics: (
    name: "Seán Ó Murchú",
    label: "Senior Software Engineer",
    summary: [
      Backend engineer with eight years of experience designing
      distributed, event-driven systems. Specialises in functional
      programming, observability, and developer experience.
    ],
    email: "sean@example.com",
    phone: "+353 1 555 0100",
    location: "Tallaght, Dublin",
    url: "https://seanomurchu.dev",
    image: read("avatar-placeholder.svg", encoding: none),
    profiles: (
      (network: "GitHub", username: "seanomurchu", url: "https://github.com/seanomurchu"),
    ),
  ),

  focusAreas: (
    [Distributed systems and functional programming.],
  ),

  work: (
    (
      name: "Acme Corp",
      url: "https://acme.example.com",
      position: "Senior Software Engineer",
      location: "Dublin, Ireland",
      startDate: years-ago(4),
      // endDate omitted → renders as "Present"
      summary: [Platform team lead. Owns the event-sourcing stack.],
      highlights: (
        [Migrated a customer-facing monolith to event-driven services, halving p99 latency.],
        [Rolled out an event-sourcing platform now used by four product teams.],
      ),
    ),
    (
      name: "Liffey Labs",
      position: "Software Engineer",
      location: "Remote",
      startDate: years-ago(7),
      endDate: years-ago(4),
      highlights: (
        [Shipped the first version of a SaaS product alongside a two-person team.],
        [Built the CI/CD pipeline that scaled the engineering org from 3 to 15.],
      ),
    ),
    (
      name: "Grand Canal Systems",
      position: "Software Engineer",
      location: "Dublin, Ireland",
      startDate: years-ago(9),
      endDate: years-ago(7),
      highlights: (
        [Led the migration of services from VMs to Kubernetes.],
      ),
    ),
  ),

  skills: (
    (name: "Languages", keywords: ("Scala", "Haskell", "Go")),
    (name: "Infra",     keywords: ("Kafka", "AWS", "Kubernetes")),
  ),

  languages: (
    (language: "English", fluency: "Native"),
    (language: "Irish",   fluency: "Professional Working"),
  ),

  education: (
    (
      institution: "Tallaght Institute of Technology",
      url: "https://example.edu/tit",
      studyType: "M.Sc. in Computer Science",
      startDate: year-only(9),
      endDate: year-only(7),
    ),
  ),

  certificates: (
    (
      name: "Certified Kubernetes Administrator",
      issuer: "CNCF",
      date: years-ago(3),
      url: "https://www.cncf.io/training/certification/cka/",
    ),
    (
      name: "Certified Kubernetes Application Developer",
      issuer: "CNCF",
      date: years-ago(2),
      url: "https://www.cncf.io/training/certification/ckad/",
    ),
  ),

  awards: (
    (
      title: "Best Paper — Distributed Systems Track",
      awarder: "EuroSys",
      date: years-ago(2),
      url: "https://example.com/eurosys",
    ),
  ),

  publications: (
    (
      name: "Event Sourcing in Practice",
      publisher: "Personal Blog",
      releaseDate: date-ago(2),
      url: "https://example.com/posts/event-sourcing",
    ),
  ),

  // The sections below sit on page 2 of the rendered PDF; they're
  // here so the example build exercises every section renderer, but
  // they're outside the page-1 preview that ships with the README.

  projects: (
    (
      name: "open-source: kafka-idempotent",
      url: "https://example.com/projects/kafka-idempotent",
      description: "Small Scala library for idempotent consumers.",
      startDate: years-ago(3),
      keywords: ("Scala", "Kafka", "OSS"),
      highlights: (
        [Underpins the awarded EuroSys paper above.],
      ),
    ),
  ),

  volunteer: (
    (
      organization: "CoderDojo Dublin",
      position: "Mentor",
      startDate: years-ago(6),
      highlights: (
        [Weekly mentoring sessions for 10–14 year-olds learning to code.],
      ),
    ),
  ),

  interests: (
    (name: "Music", keywords: ("Trad", "Jazz")),
    (name: "Sport", keywords: ("Hurling", "Climbing")),
  ),
)

#alta(cv)
