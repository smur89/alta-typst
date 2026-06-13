// JSON Resume `volunteer` section. Same shape as `work[]` but uses
// `organization` in place of `name`. Fixture covers: full entry,
// ongoing entry (omitted endDate → "Present"), no-location entry,
// no-dates entry, no-highlights entry, and empty-section short-circuit.

#import "../lib.typ": alta

#alta((
  basics: (name: "Jane Doe", email: "jane@example.com"),
  volunteer: (
    (
      organization: "Open Source Foundation",
      position: "Maintainer",
      location: "Remote",
      startDate: "Jan 2021",
      endDate: "Dec 2023",
      summary: "Triage and review for a community library.",
      highlights: (
        [Triaged 200+ issues and reviewed 80+ pull requests.],
        [Mentored two new maintainers through the onboarding process.],
      ),
    ),
    (
      // Ongoing — endDate omitted, should render as "Present".
      organization: "Local Coding Club",
      position: "Volunteer Instructor",
      startDate: "Sep 2022",
      highlights: (
        [Ran weekly coding workshops for secondary-school students.],
      ),
    ),
    (
      // No location, no dates — only position + organization + highlights.
      organization: "Charity Hack",
      position: "Mentor",
      highlights: ([Mentored two teams over a weekend hackathon.],),
    ),
    (
      // No highlights — should render heading + org + dates only.
      organization: "Community Library",
      position: "Trustee",
      startDate: "2019",
      endDate: "2020",
    ),
  ),
))
