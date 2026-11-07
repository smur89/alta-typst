// How the labels resolve, read through `adapter.labels()`, which
// merges them as `alta()` does: the document's language picks a
// bundled translation over the English, the caller's labels go over
// both, and the deprecated `labels.lang` wins over the document's
// language. Inside the template, the template's labels
// (`altacv.with(labels: ..)`, its layers) sit between the translation
// and the caller's.

#import "/lib.typ": adapter, altacv
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

// English by default.
#context {
  assert.eq(adapter.labels().work, "Experience")
  assert.eq(adapter.labels().lang, "en")
}

// A bundled translation, with the English for any key it leaves out;
// the caller's labels over it.
#[
  #set text(lang: "ga")
  #context {
    let ga = adapter.labels()
    assert.eq(ga.work, "Taithí Oibre")
    assert.eq(ga.months.first(), "Ean")
    assert.eq(ga.lang, "ga")
    assert.eq(ga.publication-types.book, "Books")
    let ga-work = adapter.labels(overrides: (work: "Obair"))
    assert.eq(ga-work.work, "Obair")
    assert.eq(ga-work.skills, "Scileanna")
    // The deprecated `labels.lang` wins over the document's language,
    // and picks the translation (#239).
    assert.eq(adapter.labels(overrides: (lang: "en")).work, "Experience")
  }
]

// A language with no translation keeps the English labels, and its
// own code; `labels.lang` still picks one.
#[
  #set text(lang: "de")
  #context {
    assert.eq(adapter.labels().work, "Experience")
    assert.eq(adapter.labels().lang, "de")
    assert.eq(adapter.labels(overrides: (lang: "ga")).work, "Taithí Oibre")
  }
]

// The template's labels over the translation, the caller's over the
// template's; an inner template's over an outer's. A template's
// `publication-types` entry merges entry by entry, as a caller's does.
#[
  #set text(lang: "ga")
  #show: altacv.with(labels: (
    present: "Jetzt",
    work: "Arbeit",
    publication-types: (Talk: "Vorträge"),
  ))
  #show: altacv.with(labels: (work: "Job"))
  #context {
    let layered = adapter.labels(overrides: (
      present: "Now",
      publication-types: (book: "Bücher"),
    ))
    assert.eq(layered.present, "Now")
    assert.eq(layered.work, "Job")
    assert.eq(layered.skills, "Scileanna")
    let types = layered.publication-types
    assert.eq(
      (types.talk, types.book, types.article),
      ("Vorträge", "Bücher", "Ailt"),
    )
  }
]
