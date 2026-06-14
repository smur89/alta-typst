// Default labels — every display string the template emits. Override
// any subset via `alta(labels: (:))`; unknown keys panic
// (`internal/validation.typ#_strict_merge`).
//
// Label keys mirror JSON Resume's section keys (`work`, `certificates`,
// …) so callers think in a single vocabulary. The values are editorial:
// "Experience" reads better than "Work" as a CV heading,
// "Certifications" than "Certificates".

#let _default_labels = (
  work: "Experience",
  volunteer: "Volunteer",
  focusAreas: "Areas of Focus",
  skills: "Skills",
  languages: "Languages",
  education: "Education",
  certificates: "Certifications",
  publications: "Publications",
  awards: "Awards",
  projects: "Projects",
  interests: "Interests",
  articles: "Articles",
  present: "Present",
  lastModified: "Last updated",
  // Twelve abbreviated month names, January–December. Used by the
  // built-in `dateFormat: "long"` formatter to render ISO 8601 inputs
  // (e.g. "2024-06" → "Jun 2024"). Override to localise; the array
  // must keep length 12 (validated in alta()).
  months: ("Jan", "Feb", "Mar", "Apr", "May", "Jun",
           "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"),
  // Per-`publications[].type` icon overrides. Keys match the `type`
  // string (case-insensitive); values are utility-icon names. The
  // module ships sensible defaults for `Articles`, `Books`, `Talks`,
  // `Conference Papers`, etc. — see `_default_publication_icons` in
  // `sections/publications.typ` — and falls back to `file` for
  // unknown types. Override here to add custom types or remap
  // built-ins.
  publicationIcons: (:),
)
