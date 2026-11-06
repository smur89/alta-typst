// expect: theme.treatment.link must be a function of the content (e.g. emph, strong, upper), got: "bold"
#import "/lib.typ": altacv

#show: altacv.with(theme: (treatment: (link: "bold")))
