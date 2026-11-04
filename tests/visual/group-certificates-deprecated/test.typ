// The deprecated `preferences.groupCertificates: false` has no effect:
// the CV renders as it does without it (ref.typ).

#import "/lib.typ": alta
#import "/tests/fixtures/certificates.typ": cv

#alta(cv, preferences: (groupCertificates: false))
