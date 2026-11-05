// `preferences.profileIcons`: networks the icon set doesn't ship
// (Kaggle, ResearchGate) drawn with the FontAwesome glyph mapped to
// them, keys matched case-insensitively; a built-in network (GitLab)
// redrawn with another glyph; and an unmapped built-in (LinkedIn)
// keeping its own.

#import "/lib.typ": alta

#alta(
  (
    basics: (
      name: "Jane Doe",
      email: "jane@example.com",
      profiles: (
        (network: "Kaggle", username: "janedoe"),
        (network: "ResearchGate", username: "Jane-Doe"),
        (network: "GitLab", username: "janedoe"),
        (network: "LinkedIn", username: "janedoe"),
      ),
    ),
  ),
  preferences: (
    profileIcons: (
      Kaggle: "kaggle",
      researchgate: "researchgate",
      gitlab: "square-gitlab",
    ),
  ),
)
