// Unit checks for internal/data/validation.typ.

#import "/internal/data/defaults.typ": _default-preferences
#import "/internal/data/validation.typ": _check-preference, _preference-rules

// Every preference has its check, and every check a preference, in the
// defaults' order, so a new one can't skip validation.
#assert.eq(_preference-rules.keys(), _default-preferences.keys())

// The defaults pass their own rules, as `_merge-options` checks only
// what a caller sets.
#for (key, v) in _default-preferences { _check-preference(key, v) }
