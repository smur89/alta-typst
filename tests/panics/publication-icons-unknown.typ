// expect: preferences.publication-icons.talk must be "book", "calendar", "cubes", "email", "file", "flask", "folder", "laptop-code", "location", "microphone", "newspaper", "phone", "terminal", "bluesky", "github", "gitlab", "link", "linkedin", "mastodon", "medium", "orcid", "stackoverflow", "twitter", or "website", got: "podium"
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(cv, preferences: (publication-icons: (talk: "podium")))
