# altacv — local build helper. Mirrors the compile sweep CI runs on
# every PR, and centralises the preview-image regeneration recipe so
# CONTRIBUTING.md doesn't drift from `.github/workflows/build.yml`.
#
# Usage:
#   make             # build every example PDF, the cv preview, and a
#                    # rendered PDF per fixture under examples/tests/
#   make cv          # build examples/cv.pdf + examples/cv.png from
#                    # template/cv.typ (the canonical demo)
#   make example-full # build examples/example_full.pdf + per-page PNGs
#                    # used as the static README gallery
#   make thumbnail   # build thumbnail.png from template/cv.typ
#                    # (Universe package-card image — 180 PPI;
#                    # override with THUMB_PPI=...)
#   make preview-gif # build the animated README hero (needs ffmpeg)
#   make pdfs        # build PDFs for every examples/*.typ
#   make previews    # build a page-1 PNG for every examples/*.typ
#   make test-pdfs   # render every tests/*.typ fixture into
#                    # examples/tests/*.pdf (tracked in git)
#   make test        # compile every example + fixture (output discarded)
#   make clean       # remove generated PDFs and PNGs
#
# Tool overrides:
#   make TYPST=/path/to/typst    # use a non-default typst binary
#   make FFMPEG=/path/to/ffmpeg  # use a non-default ffmpeg binary
#   make PPI=300                 # raise preview resolution (default 150)
#   make PREVIEW_FPS=1           # adjust GIF frame rate (default 0.4)

# Delete the target of any recipe that exits non-zero. Without this,
# a `typst compile` that writes partial output before failing leaves
# the target on disk with mtime newer than the source, so the next
# `make` thinks it's fresh and skips the rebuild — shipping a corrupt
# artifact. With this, make removes partial files so the next run
# re-fires the recipe.
.DELETE_ON_ERROR:

TYPST     ?= typst
FFMPEG    ?= ffmpeg
ROOT      := .
PPI       ?= 150
# Animated-preview frame rate. `ffmpeg`'s `-framerate` is the
# inverse of seconds-per-frame, so 0.4 → 2.5s/frame — long enough
# for the eye to register each frame's layout change without
# dragging.
PREVIEW_FPS ?= 0.4

# The sed expression that swaps `#import "@preview/altacv:<version>"`
# for an in-tree `#import "/lib.typ"` so we can compile template/cv.typ
# locally without resolving the package against typst.app. Three
# recipes use this — keep them in lockstep via this single source of
# truth. The `[^"]*` wildcard tolerates whatever version-string
# release-please writes.
LOCAL_IMPORT_SED := s|@preview/altacv:[^"]*|/lib.typ|

# Underscore-prefixed sources (e.g. examples/_dates.typ) are shared
# helpers `#import`-ed by the real examples — not standalone documents
# — so they're excluded from the PDF/PNG sweep.
#
# `example_full.typ` and `preview-frames.typ` are in the PDF sweep but
# excluded from the PNG sweep — the standard `examples/%.png` rule
# keeps only page 1, which isn't useful for example_full (gallery
# needs every page) or preview-frames (page 1 alone has no consumer).
# example_full has a dedicated rule below that emits per-page PNGs.
EXAMPLES      := $(filter-out examples/_%.typ,$(wildcard examples/*.typ))
EXAMPLES_PNG  := $(filter-out examples/example_full.typ examples/preview-frames.typ,$(EXAMPLES))
TESTS         := $(wildcard tests/*.typ)
PDFS          := $(EXAMPLES:.typ=.pdf)
PNGS          := $(EXAMPLES_PNG:.typ=.png)
TEST_PDFS     := $(patsubst tests/%.typ,examples/tests/%.pdf,$(TESTS))

.PHONY: all cv example-full thumbnail preview-gif pdfs previews test-pdfs test test-template check clean help

all: pdfs cv test-pdfs thumbnail

preview-gif: examples/preview.gif

# The canonical demo: template/cv.typ rendered as PDF + page-1 PNG.
# Used both as a workflow artifact (PR-reviewer download) and as the
# tracked README preview image. See the `examples/cv.pdf` rule below
# for why it sed-swaps the package import.
cv: examples/cv.pdf examples/cv.png

# Multi-page gallery — single PDF target whose recipe emits all
# outputs (PDF + per-page PNGs) in one invocation. The PNGs are
# produced as side-effects of the recipe; they appear stale only if
# someone deletes one manually without bumping a source mtime, which
# is rare enough to skip from the dep graph. Listing PNGs as
# additional rule targets would be parsed as N independent rules by
# pre-4.3 GNU Make and race under `make -j` — see commit history.
example-full: examples/example_full.pdf

# Universe package-card thumbnail. Per the typst/packages submission
# rules, the thumbnail must depict one of the pages of the *template*
# as initialised (not an example), longer edge ≥ 1080 px, ≤ 3 MiB.
# We render at 180 PPI (long edge ≈ 2105 px, file ≈ 0.8 MiB) — well
# above the minimum and comfortably under the typst-package-check
# linter's 1 MiB "large file" suggestion. The Universe card itself
# displays at a small fraction of these pixels, so the extra
# resolution from the typst docs' "usually" 250 PPI default is wasted.
#
# template/cv.typ uses `#import "@preview/altacv:<version>"` so it
# works after `typst init` on a user's machine, but that path doesn't
# resolve in this repo. The recipe swaps the import (via the shared
# `$(LOCAL_IMPORT_SED)` expression) to the local `lib.typ`, renders
# page 1, and cleans up the temp source — keeping template/cv.typ
# untouched on disk so it ships verbatim.
THUMB_PPI  ?= 180

thumbnail: thumbnail.png

thumbnail.png: template/cv.typ lib.typ
	sed '$(LOCAL_IMPORT_SED)' template/cv.typ > .thumbnail-src.typ
	$(TYPST) compile --root $(ROOT) --format png --ppi $(THUMB_PPI) .thumbnail-src.typ '.thumbnail-{p}.png'
	mv .thumbnail-1.png $@
	rm -f .thumbnail-src.typ .thumbnail-*.png

pdfs: $(PDFS)

previews: $(PNGS)

# Renders every fixture to its own PDF under examples/tests/ as a
# visible reference for each permutation of the template's output.
# The PDFs are tracked in git so reviewers can browse the rendered
# fixtures without a local rebuild.
#
# `--creation-timestamp 0` pins the PDF's CreationDate metadata so
# repeated builds of the same source produce byte-identical output.
# Without this, every rebuild changes the PDF (timestamp drift),
# which would defeat the CI drift check in `.github/workflows/build.yml`.
test-pdfs: $(TEST_PDFS)

examples/tests:
	mkdir -p $@

examples/tests/%.pdf: tests/%.typ | examples/tests
	$(TYPST) compile --creation-timestamp 0 --root $(ROOT) $< $@

# Pattern rule: every examples/X.typ produces examples/X.pdf.
examples/%.pdf: examples/%.typ
	$(TYPST) compile --root $(ROOT) $< $@

# Explicit rule for example_full: a single canonical target (the PDF)
# whose recipe also writes the per-page PNG gallery. The PNGs are
# side-effects — they don't appear as additional rule targets because
# pre-4.3 GNU Make would parse `A B C: deps` as N independent rules
# and race under `make -j`. `.DELETE_ON_ERROR:` (top of file) deletes
# partial outputs if either compile fails. `rm -f examples/example_full-*.png`
# pre-cleans stale page PNGs so a shrink (e.g. 3-page content trimmed
# to 2) doesn't leave an orphan example_full-3.png.
examples/example_full.pdf: examples/example_full.typ examples/_dates.typ icons/avatar-placeholder.svg lib.typ
	rm -f examples/example_full-*.png
	$(TYPST) compile --creation-timestamp 0 --root $(ROOT) --format pdf $< $@
	$(TYPST) compile --root $(ROOT) --format png --ppi $(PPI) $< 'examples/example_full-{p}.png'

# Pattern rule: every examples/X.typ produces examples/X.png (page 1).
# Typst's PNG export needs a `{p}` placeholder; we render to a numbered
# temp file, move page 1 to the unsuffixed name, and drop the rest.
examples/%.png: examples/%.typ
	$(TYPST) compile --root $(ROOT) --format png --ppi $(PPI) $< 'examples/$*-{p}.png'
	mv 'examples/$*-1.png' $@
	rm -f 'examples/$*-'*.png

# The canonical demo, derived from template/cv.typ. Each rule uses
# the shared `$(LOCAL_IMPORT_SED)` swap to compile inside the repo
# without the package installed. The PDF is gitignored (workflow /
# release artifact); the PNG is tracked because the README references
# it via raw.githubusercontent without a local rebuild. Each rule
# uses its own temp source file (`.cv-pdf-src.typ` / `.cv-png-src.typ`)
# so a parallel `make -j2 cv` doesn't race on a shared `.cv-src.typ`.
examples/cv.pdf: template/cv.typ lib.typ
	sed '$(LOCAL_IMPORT_SED)' template/cv.typ > .cv-pdf-src.typ
	$(TYPST) compile --root $(ROOT) .cv-pdf-src.typ $@
	rm -f .cv-pdf-src.typ

examples/cv.png: template/cv.typ lib.typ
	sed '$(LOCAL_IMPORT_SED)' template/cv.typ > .cv-png-src.typ
	$(TYPST) compile --root $(ROOT) --format png --ppi $(PPI) .cv-png-src.typ 'examples/cv-{p}.png'
	mv examples/cv-1.png $@
	rm -f .cv-png-src.typ examples/cv-*.png

# Animated README hero — one frame per preference variation defined
# in examples/preview-frames.typ. The frames file emits one page per
# variation; Typst renders the pages to dotfile PNGs (hidden from
# `ls`), and ffmpeg stitches them with `palettegen` + `paletteuse`
# for higher-quality colour quantisation than a default GIF.
#
# Local-only target — committed alongside `cv.png`; CI does not
# regenerate the GIF on every push (ffmpeg install + multi-page typst
# compile is too slow for the lint job).
#
# Prerequisites include every file `preview-frames.typ` reads —
# transitive `#import`/`read()` targets — so editing any of them
# triggers a fresh GIF on the next `make preview-gif`.
examples/preview.gif: examples/preview-frames.typ examples/_cv.typ examples/_dates.typ examples/labels-ga.toml icons/avatar-placeholder.svg lib.typ
	$(TYPST) compile --root $(ROOT) --format png --ppi $(PPI) $< 'examples/.preview-gif-frame-{p}.png'
	$(FFMPEG) -framerate $(PREVIEW_FPS) -i 'examples/.preview-gif-frame-%d.png' \
	  -vf "split[s0][s1];[s0]palettegen=stats_mode=diff[p];[s1][p]paletteuse=dither=sierra2_4a" \
	  -loop 0 -y $@
	rm -f examples/.preview-gif-frame-*.png

# Compile every example + fixture; output goes to /dev/null. Same
# shape as the CI lint job, so a green `make test` locally means the
# CI lint step will also pass. When `GITHUB_ACTIONS` is set (i.e. the
# recipe is running on a GitHub Actions runner) the recipe also emits
# `::group::` / `::endgroup::` markers for collapsible per-file log
# sections and `::error file=<path>::` annotations for failing files,
# preserving the PR-file-view annotations the lint step previously
# emitted inline.
test:
	@status=0; \
	for f in $(EXAMPLES) $(TESTS); do \
	  if [ -n "$$GITHUB_ACTIONS" ]; then printf '::group::%s\n' "$$f"; \
	  else printf '  %s\n' "$$f"; fi; \
	  if ! $(TYPST) compile --root $(ROOT) --format pdf "$$f" /dev/null; then \
	    if [ -n "$$GITHUB_ACTIONS" ]; then \
	      printf '::error file=%s::compile failed\n' "$$f"; \
	    fi; \
	    status=1; \
	  fi; \
	  if [ -n "$$GITHUB_ACTIONS" ]; then printf '::endgroup::\n'; fi; \
	done; \
	exit $$status

# Compile-check `template/cv.typ` via the same sed-swap the
# thumbnail / cv.pdf rules use. The standard `make test` sweep
# can't reach template/cv.typ because its `@preview/altacv` import
# won't resolve locally; this target plugs that hole so a broken
# `typst init` starter trips before release.
test-template:
	@if [ -n "$$GITHUB_ACTIONS" ]; then printf '::group::%s\n' template/cv.typ; \
	else printf '  %s\n' template/cv.typ; fi
	@sed '$(LOCAL_IMPORT_SED)' template/cv.typ > .test-template-src.typ
	@$(TYPST) compile --root $(ROOT) --format pdf .test-template-src.typ /dev/null; status=$$?; \
	rm -f .test-template-src.typ; \
	if [ -n "$$GITHUB_ACTIONS" ]; then printf '::endgroup::\n'; fi; \
	exit $$status

# Alias for `make test` — matches the conceptual "CI lint" target name.
# Composes with `test-template` so a broken starter fails the lint.
check: test test-template

# Removes every generated artifact, including `examples/cv.png`. That
# file is tracked in git for stable README image hosting, but it's
# regenerated from `template/cv.typ` — run `make cv` (or
# `git checkout examples/cv.png`) after `make clean` to put it back.
clean:
	rm -f $(PDFS) $(PNGS) $(TEST_PDFS) examples/cv.pdf examples/cv.png examples/cv-*.png examples/preview.gif examples/.preview-gif-frame-*.png examples/example_full-*.png thumbnail.png .thumbnail-src.typ .thumbnail-*.png .cv-pdf-src.typ .cv-png-src.typ .test-template-src.typ

help:
	@printf '%s\n' 'Targets: all (default) | cv | example-full | thumbnail | preview-gif' \
	  '         pdfs | previews | test-pdfs | test (alias: check) | clean' \
	  'Per-target detail: see the header comment in this Makefile.' \
	  'Overrides: TYPST=path/to/typst FFMPEG=path/to/ffmpeg PPI=300 PREVIEW_FPS=1'
