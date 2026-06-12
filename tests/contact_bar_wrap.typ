// Many contact-bar entries forced onto multiple lines. Each entry is
// rendered as an atomic inline box so the icon and its display text
// can never be split by a line break — line breaks land on the
// inter-entry separators only. Visually, every wrapped line still
// starts with an icon, never with a bare username / email orphaned
// from its icon on the previous line.

#import "../lib.typ": alta

#alta((
  basics: (
    name: "Wraps Mc Wrap",
    label: "Demo of contact-bar wrap atomicity",
    email: "wraps.mc.wrap@example.com",
    phone: "+353 1 555 0100",
    location: "Tallaght, Dublin",
    profiles: (
      (network: "LinkedIn",      username: "wrapsmcwrap-linkedin",     url: "https://linkedin.com/in/wrapsmcwrap"),
      (network: "GitHub",        username: "wrapsmcwrap-github",        url: "https://github.com/wrapsmcwrap"),
      (network: "GitLab",        username: "wrapsmcwrap-gitlab",        url: "https://gitlab.com/wrapsmcwrap"),
      (network: "Bluesky",       username: "@wrapsmcwrap.bsky.social",  url: "https://bsky.app/profile/wrapsmcwrap"),
      (network: "Mastodon",      username: "@wrapsmcwrap@fosstodon.org", url: "https://fosstodon.org/@wrapsmcwrap"),
      (network: "Medium",        username: "@wrapsmcwrap-medium",       url: "https://medium.com/@wrapsmcwrap"),
      (network: "Stackoverflow", username: "wrapsmcwrap-stackoverflow", url: "https://stackoverflow.com/u/1"),
      (network: "X",             username: "@wrapsmcwrap-x",            url: "https://x.com/wrapsmcwrap"),
      (network: "Website",       username: "wrapsmcwrap.dev",           url: "https://wrapsmcwrap.dev"),
      (network: "Link",          username: "talk recording",            url: "https://example.com/talk"),
    ),
  ),
))
