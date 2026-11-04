// Certificates with every mix of date and url: certificates-metadata's
// and group-certificates-deprecated's CV.

#let cv = (
  basics: (name: "Jane Doe", email: "jane@example.com"),
  certificates: (
    // Full entry — pill is linked, date row follows.
    (
      name: "Certified Kubernetes Administrator",
      issuer: "CNCF",
      date: "Aug 2023",
      url: "https://example.com/cka",
    ),
    // Same issuer as the entry above. Mixes a dated + linked cert
    // with one that has neither, exercising each optional part.
    (
      name: "Certified Kubernetes Application Developer",
      issuer: "CNCF",
    ),
    // Url-only — link wraps the pill, no date line.
    (
      name: "AWS Solutions Architect — Associate",
      issuer: "AWS",
      url: "https://example.com/aws-saa",
    ),
    // Date-only — plain pill plus the calendar-icon date line.
    (
      name: "Terraform Associate",
      issuer: "HashiCorp",
      date: "May 2022",
    ),
  ),
)
