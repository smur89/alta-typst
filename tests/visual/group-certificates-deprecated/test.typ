// The deprecated `preferences.groupCertificates: false` has no effect:
// the CV renders as it does without it (ref.typ).

#import "/lib.typ": alta
#import "../certificates-metadata/test.typ": cv

#alta(cv, preferences: (groupCertificates: false))
