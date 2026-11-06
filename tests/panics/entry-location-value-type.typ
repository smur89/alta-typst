// expect: education[].location.region must be a string or content, got: ("Munster",)
#import "/lib.typ": alta

#let cv = (basics: (name: "Jane Doe"))
#alta(
  cv + (education: ((institution: "UCC", location: (region: ("Munster",))),)),
)
