// `preferences.printFullUrls` with every channel unlinked: the GitHub
// profile prints `github.com/janedoe` in place of its username; the
// email, phone and location keep their values.

#import "/lib.typ": alta
#import "/tests/visual/link-contact-info/test.typ": cv

#alta(cv, preferences: (linkContactInfo: false, printFullUrls: true))
