// expect: preferences.project-icons.Library must be "book", "calendar", "cubes", "email", "file", "flask", "folder", "laptop-code", "location", "microphone", "newspaper", "phone", "terminal", "bluesky", "github", "gitlab", "link", "linkedin", "mastodon", "medium", "orcid", "stackoverflow", "twitter", or "website", got: "books"
#import "/lib.typ": alta

#alta(
  (basics: (name: "Jane Doe")),
  preferences: (project-icons: (Library: "books")),
)
