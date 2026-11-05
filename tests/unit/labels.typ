// Unit checks for how the labels resolve, through `_merge-options`,
// the sequence `alta()` runs: the document's language picks a bundled
// translation over the English, the caller's labels go over both, and
// the deprecated `labels.lang` wins over the document's language.

#import "/internal/data/options.typ": _merge-options

#let labels(overrides: (:), ..lang) = (
  _merge-options(overrides, (:), ..lang).labels
)

// English by default.
#assert.eq(labels().work, "Experience")
#assert.eq(labels().lang, "en")

// A bundled translation, with the English for any key it leaves out.
#let ga = labels(lang: "ga")
#assert.eq(ga.work, "Taithí Oibre")
#assert.eq(ga.months.first(), "Ean")
#assert.eq(ga.lang, "ga")
#assert.eq(ga.publication-types.book, "Books")

// A language with no translation keeps the English labels, and its
// own code.
#assert.eq(labels(lang: "de").work, "Experience")
#assert.eq(labels(lang: "de").lang, "de")

// The caller's labels go over the translation.
#let ga-work = labels(lang: "ga", overrides: (work: "Obair"))
#assert.eq(ga-work.work, "Obair")
#assert.eq(ga-work.skills, "Scileanna")

// The deprecated `labels.lang` wins over the document's language, and
// picks the translation (#239).
#assert.eq(labels(lang: "de", overrides: (lang: "ga")).work, "Taithí Oibre")
#assert.eq(labels(lang: "ga", overrides: (lang: "en")).work, "Experience")
