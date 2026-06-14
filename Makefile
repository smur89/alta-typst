# altacv — local build helper. Mirrors the compile sweep CI runs on
# every PR, and centralises the preview-image regeneration recipe so
# CONTRIBUTING.md doesn't drift from `.github/workflows/build.yml`.
#
# Usage:
#   make             # build every example PDF + the README preview image
#                    # + a rendered PDF per fixture under examples/tests/
#   make example     # build examples/example.pdf + examples/preview.png
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
#   make PREVIEW_FPS=1           # adjust GIF frame rate (default 0.67)

TYPST     ?= typst
FFMPEG    ?= ffmpeg
ROOT      := .
PPI       ?= 150
# Seconds-per-frame for the animated README preview. `ffmpeg`'s
# `-framerate` is the inverse — 0.67 → ~1.5s/frame.
PREVIEW_FPS ?= 0.67

# Underscore-prefixed sources (e.g. examples/_dates.typ) are shared
# helpers `#import`-ed by the real examples — not standalone documents
# — so they're excluded from the PDF/PNG sweep.
EXAMPLES  := $(filter-out examples/_%.typ,$(wildcard examples/*.typ))
TESTS     := $(wildcard tests/*.typ)
PDFS      := $(EXAMPLES:.typ=.pdf)
PNGS      := $(EXAMPLES:.typ=.png)
TEST_PDFS := $(patsubst tests/%.typ,examples/tests/%.pdf,$(TESTS))

.PHONY: all example preview-gif pdfs previews test-pdfs test check clean help

all: pdfs examples/preview.png test-pdfs

preview-gif: examples/preview.gif

example: examples/example.pdf examples/preview.png

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

# Pattern rule: every examples/X.typ produces examples/X.png (page 1).
# Typst's PNG export needs a `{p}` placeholder; we render to a numbered
# temp file, move page 1 to the unsuffixed name, and drop the rest.
examples/%.png: examples/%.typ
	$(TYPST) compile --root $(ROOT) --format png --ppi $(PPI) $< 'examples/$*-{p}.png'
	mv 'examples/$*-1.png' $@
	rm -f 'examples/$*-'*.png

# README / Typst Universe preview image. Pinned to example.typ's page
# one so the stable filename always reflects the canonical example.
# Listed explicitly so `make` rebuilds it even when no examples/*.typ
# changed (e.g. after a lib.typ tweak).
examples/preview.png: examples/example.typ lib.typ
	$(TYPST) compile --root $(ROOT) --format png --ppi $(PPI) $< 'examples/preview-{p}.png'
	mv examples/preview-1.png $@
	rm -f examples/preview-*.png

# Animated README hero — one frame per preference variation defined
# in examples/preview-frames.typ. The frames file emits one page per
# variation; Typst renders the pages to dotfile PNGs (hidden from
# `ls`), and ffmpeg stitches them with `palettegen` + `paletteuse`
# for higher-quality colour quantisation than a default GIF.
#
# Local-only target — committed alongside `preview.png`; CI does not
# regenerate the GIF on every push (ffmpeg install + 18-page typst
# compile is too slow for the lint job).
examples/preview.gif: examples/preview-frames.typ lib.typ
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

# Alias for `make test` — matches the conceptual "CI lint" target name.
check: test

# Removes every generated artifact, including `examples/preview.png`.
# That file is tracked in git for stable README image hosting, but
# it's regenerated from `examples/example.typ` — run `make example`
# (or `git checkout examples/preview.png`) after `make clean` to put
# it back.
clean:
	rm -f $(PDFS) $(PNGS) $(TEST_PDFS) examples/preview.png examples/preview-*.png examples/preview.gif examples/.preview-gif-frame-*.png

help:
	@echo "Targets:"
	@echo "  all          Build every example PDF, the README preview,"
	@echo "               and the per-fixture PDFs (default)"
	@echo "  example      Build examples/example.pdf + examples/preview.png"
	@echo "  preview-gif  Build the animated README hero (needs ffmpeg)"
	@echo "  pdfs         Build PDFs for every examples/*.typ"
	@echo "  previews     Build page-1 PNGs for every examples/*.typ"
	@echo "  test-pdfs    Render every tests/*.typ to examples/tests/*.pdf"
	@echo "  test         Compile every example + fixture, discarding output"
	@echo "  check        Alias for test (matches the CI lint shape)"
	@echo "  clean        Remove generated PDFs and PNGs"
	@echo ""
	@echo "Overrides: TYPST=path/to/typst, FFMPEG=path/to/ffmpeg,"
	@echo "           PPI=300, PREVIEW_FPS=1"
