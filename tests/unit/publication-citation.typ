// `publication(citation: ..)`: the volume, issue and pages after the
// source, in the theme's `citation` style, as `alta()` sets them; a
// `none` part drops out with its punctuation.

#import "/lib.typ": altacv, publication, themes

#let seen = state("seen", ())
#let count(it) = {
  seen.update(xs => xs + (it.text,))
  it
}
#show "ACM, 12[3]: 45—60": count
#show "ACM 12(3), 45–60": count
#show "ACM 12, 45–60": count

#[
  #show: altacv
  = Publications
  #publication(
    title: "A",
    source: "ACM",
    citation: (volume: "12", issue: "3", pages: "45-60"),
  )[]
  #publication(
    title: "B",
    source: "ACM",
    citation: (volume: "12", issue: none, pages: "45-60"),
  )[]
]
#[
  #show: altacv.with(
    theme: themes.teal
      + (
        citation: (
          issue: ("[", "]"),
          pages: ": ",
          source: ", ",
          page-range: "—",
        ),
      ),
  )
  = Publications
  #publication(
    title: "C",
    source: "ACM",
    citation: (volume: "12", issue: "3", pages: "45--60"),
  )[]
]
#context assert.eq(seen.final(), (
  "ACM 12(3), 45–60",
  "ACM 12, 45–60",
  "ACM, 12[3]: 45—60",
))
