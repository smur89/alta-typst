// expect: contact() icon must be "book", "calendar", "cubes", "email", "file", "flask", "folder", "laptop-code", "location", "microphone", "newspaper", "phone", "terminal", "bluesky", "github", "gitlab", "link", "linkedin", "mastodon", "medium", "orcid", "stackoverflow", "twitter", or "website", got: "fax"
#import "/lib.typ": contact

#contact("fax", "+353 1 234 5678")
