// preferences.linkContactInfo: false. Contact bar should render the
// email, phone, location, and profile values as plain text — icons
// stay, the `link()` wrapping does not.

#import "../lib.typ": alta

#alta(
  (
    basics: (
      name: "Jane Doe",
      label: "Software Engineer",
      email: "jane@example.com",
      phone: "+353 1 555 0100",
      location: "Dublin, Ireland",
      profiles: (
        (network: "GitHub", username: "janedoe", url: "https://github.com/janedoe"),
      ),
    ),
  ),
  preferences: (
    linkContactInfo: false,
  ),
)
