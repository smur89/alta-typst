// Unit checks for internal/data/validation.typ.

#import "/internal/data/defaults.typ": _default-preferences
#import "/internal/data/validation.typ": _preference-rules

// Every preference is checked, by a rule or by name here, so a new one
// can't skip validation; the rules keep the defaults' order.
#let checked-elsewhere = (
  "publication-icons",
  "project-icons",
  "profile-icons",
  "font",
  "colours",
  "link-contact-info",
  "group-certificates",
  "show-pronouns",
)
#assert.eq(
  _preference-rules.keys(),
  _default-preferences.keys().filter(k => k not in checked-elsewhere),
)
