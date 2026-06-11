// Smallest possible CV — only `basics`. Every other top-level key
// is omitted so the template must skip those sections without
// emitting orphan headings.

#import "../lib.typ": alta

#alta((
  basics: (
    name: "Jane Doe",
    label: "Software Engineer",
    email: "jane@example.com",
  ),
))
