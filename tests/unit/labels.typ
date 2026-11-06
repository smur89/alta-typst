// Unit checks for how the labels resolve, through `_merge-options`,
// the sequence `alta()` runs: the document's language picks a bundled
// translation over the English, the caller's labels go over both, and
// the deprecated `labels.lang` wins over the document's language.
// Inside the template, the template's labels (`altacv.with(labels:
// ..)`, its layers) sit between the translation and the caller's.

#import "/internal/data/options.typ": _merge-options
#import "/internal/data/canonical.typ": _label-tables
#import "/internal/data/defaults.typ": _default-labels, _translations
#import "/internal/data/validation.typ": _strict-merge, _validate-labels

// The bundled translations ship checked, as `alta()` checks only a
// caller's labels: each sets only labels the English has, of their
// kinds, and every template keeps its placeholders.
#_validate-labels(_default-labels)
#for (code, translation) in _translations {
  _validate-labels(_strict-merge(
    _default-labels,
    translation + (lang: code),
    "labels",
    tables: _label-tables,
  ))
}

#let labels(overrides: (:), ..options) = (
  _merge-options(overrides, (:), ..options).labels
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

// The template's labels over the translation, the caller's over the
// template's; an inner template's over an outer's.
#let layered = labels(
  lang: "ga",
  template: ((present: "Jetzt", work: "Arbeit"), (work: "Job")),
  overrides: (present: "Now"),
)
#assert.eq(layered.present, "Now")
#assert.eq(layered.work, "Job")
#assert.eq(layered.skills, "Scileanna")
// A template's `publication-types` entry merges entry by entry, as a
// caller's does.
#let types = labels(
  template: ((publication-types: (Talk: "Vorträge")),),
  overrides: (publication-types: (book: "Bücher")),
).publication-types
#assert.eq(
  (types.talk, types.book, types.article),
  (
    "Vorträge",
    "Bücher",
    "Articles",
  ),
)
