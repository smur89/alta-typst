// Shared CV data for the animated multi-frame preview
// (`preview-frames.typ` → `examples/preview.gif`). Every frame of
// the GIF renders the SAME fictional CV — only the preferences
// differ — so accent / layout / column-arrangement changes read as
// preference customisation rather than data differences.
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
// anti-bias hiring practices both discourage it — so the GIF
// alternates between with-photo and without-photo frames to reflect
// what most users actually ship).

#import "/.template-src.typ": cv

// Returns the CV with `basics.image` suppressed — i.e. the header
// renders without a portrait. Override-to-`none` rather than
// `.remove()` so the helper is idempotent (calling it twice doesn't
// panic on a missing key) and reads as an expression rather than a
// statement sequence.
#let no-image(cv) = cv + (basics: cv.basics + (image: none))
