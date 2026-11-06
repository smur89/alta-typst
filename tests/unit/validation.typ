// Unit checks for internal/data/validation.typ.

#import "/internal/data/defaults.typ": _default-preferences
#import "/internal/data/validation.typ": _preference-rules

// Every preference has its check, and every check a preference, in the
// defaults' order, so a new one can't skip validation.
#assert.eq(_preference-rules.keys(), _default-preferences.keys())
