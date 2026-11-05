// Shared CV data for the animated multi-frame preview
// (`preview-frames.typ` → `examples/preview.webp`). Every frame of
// the animation renders the SAME fictional CV (translated in the Irish
// frames, `in-irish`) — only the preferences differ — so accent /
// layout / column-arrangement changes read as preference
// customisation rather than data differences.
//
// The CV itself is `template/cv.typ`'s — the `typst init` starter,
// which also renders `examples/cv.png` and `thumbnail.png` — so the
// README hero, the static preview and the Universe card can't drift
// apart. It's read through `/.template-src.typ`, the copy the Makefile
// generates with the `@preview/altacv` import swapped for `/lib.typ`
// (that import doesn't resolve in-repo). Importing just the `cv`
// binding evaluates the template but doesn't emit its `#alta(...)`
// page into this document.
//
// Opening `preview-frames.typ` in an editor before any `make` run
// fails on the missing file; `make .template-src.typ` generates it.
//
// `no-image` is a helper that returns the CV with `basics.image`
// suppressed, used by frames that demonstrate the image-less header
// (most real-world CVs don't include a photo — ATS systems and
// anti-bias hiring practices both discourage it — so the animation
// alternates between with-photo and without-photo frames to reflect
// what most users actually ship). `in-irish` returns it with its
// prose in Irish, for the frames rendered in Irish.

#import "/.template-src.typ": cv

// Returns the CV with `basics.image` suppressed — i.e. the header
// renders without a portrait. Override-to-`none` rather than
// `.remove()` so the helper is idempotent (calling it twice doesn't
// panic on a missing key) and reads as an expression rather than a
// statement sequence.
#let no-image(cv) = cv + (basics: cv.basics + (image: none))

// The CV's prose in Irish, for the frames rendered in Irish, so the
// content reads in the same language as the headings. Dates, links and
// names (products, certificates, technologies) stay as they are, and
// so do the language fluencies, which the template maps to rating
// dots.
#let _ga = (
  basics: (
    label: "Innealtóir Bogearraí Sinsearach",
    summary: [
      Innealtóir cúlchórais le hocht mbliana taithí ag dearadh córas
      dáilte atá bunaithe ar imeachtaí. Speisialtóireacht i ríomhchlárú
      feidhmiúil, in inbhreathnaitheacht agus i dtaithí forbróirí.
    ],
    location: "Tamhlacht, Baile Átha Cliath",
  ),
  objective: [
    Foireann ardáin a threorú a thógann córais iontaofa atá bunaithe ar
    imeachtaí.
  ],
  custom: (
    altacv: (focusAreas: ([Córais dháilte agus ríomhchlárú feidhmiúil.],)),
  ),
  work: (
    (
      position: "Innealtóir Bogearraí Sinsearach",
      location: "Baile Átha Cliath, Éire",
      summary: [Ceannaire na foirne ardáin. Freagrach as an gcóras foinsithe imeachtaí.],
      highlights: (
        [Monailit do chustaiméirí a aistriú go seirbhísí atá bunaithe ar imeachtaí, rud a laghdaigh an mhoill p99 faoi leath.],
        [Ardán foinsithe imeachtaí a chur i bhfeidhm atá in úsáid anois ag ceithre fhoireann táirge.],
      ),
    ),
    (
      position: "Innealtóir Bogearraí",
      location: "Cianobair",
      highlights: (
        [An chéad leagan de tháirge SaaS a sheoladh le foireann beirte.],
        [An píblíne CI/CD a thógáil a lig don fhoireann innealtóireachta fás ó 3 go 15.],
      ),
    ),
  ),
  skills: ((name: "Teangacha"), (name: "Bonneagar")),
  languages: ((language: "Béarla"), (language: "Gaeilge")),
  education: (
    (
      institution: "Institiúid Teicneolaíochta Thamhlachta",
      studyType: "M.Sc. sa Ríomheolaíocht",
    ),
  ),
  awards: ((title: "An Páipéar is Fearr — Rian na gCóras Dáilte"),),
  publications: (
    (name: "Foinsiú Imeachtaí i gCleachtas", publisher: "Blag Pearsanta"),
  ),
  projects: (
    (
      name: "foinse oscailte: kafka-idempotent",
      summary: "Leabharlann bheag Scala do thomhaltóirí idempotent.",
      highlights: (
        [Is air atá an páipéar EuroSys thuas, a bhuaigh duais, bunaithe.],
      ),
    ),
  ),
  volunteer: (
    (
      position: "Meantóir",
      highlights: (
        [Seisiúin mheantóireachta gach seachtain do dhaoine óga 10–14 bliana d'aois atá ag foghlaim códú.],
      ),
    ),
  ),
  interests: (
    (name: "Ceol", keywords: ("Traidisiúnta", "Snagcheol")),
    (name: "Spórt", keywords: ("Iománaíocht", "Dreapadóireacht")),
  ),
)

// `cv` with its prose in Irish (`_ga`): dictionaries merged, entry
// lists merged entry by entry, in order. An entry `_ga` doesn't
// translate stays in English rather than dropping out.
#let in-irish(cv) = (
  cv
    + _ga
      .pairs()
      .map(((key, ga)) => (
        key,
        if type(ga) == array {
          cv
            .at(key)
            .enumerate()
            .map(((i, entry)) => entry + ga.at(i, default: (:)))
        } else if type(ga) == dictionary {
          cv.at(key, default: (:)) + ga
        } else { ga },
      ))
      .to-dict()
)
