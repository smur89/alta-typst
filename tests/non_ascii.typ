// Non-ASCII content in name, location, and other fields. Exercises
// _url_encode's multi-byte UTF-8 path (fadas in Gaeilge — á é í ó ú)
// and verifies that accented characters survive the contact-bar /
// header emission unchanged.

#import "../lib.typ": alta

#alta((
  basics: (
    name: "Caoimhe Ní Bhriain",
    label: "Innealtóir Bogearraí Sinsearach",
    summary: [Innealtóir bogearraí le taithí ar chórais dáilte.],
    email: "caoimhe@example.com",
    phone: "+353 1 555 0100",
    location: "Dún Laoghaire, Éire",
    profiles: (
      (network: "GitHub", username: "caoimhe", url: "https://github.com/caoimhe"),
      (network: "X",      username: "caoimhe", url: "https://x.com/caoimhe"),
    ),
  ),
  work: (
    (
      name: "Áras Bogearraí Teo.",
      position: "Príomh-innealtóir",
      location: "Baile Átha Cliath, Éire",
      startDate: "Eanáir 2022",
      highlights: ([Dhear córas Kafka don eagraíocht.],),
    ),
  ),
  languages: (
    (language: "Gaeilge",  fluency: "Native"),
    (language: "Béarla",   fluency: "Native"),
    (language: "Français", rating: 3),
    (language: "Español",  rating: 2.5),
  ),
))
