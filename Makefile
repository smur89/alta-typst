# altacv — local build helper. Mirrors the compile sweep CI runs on
# every PR, and centralises the preview-image regeneration recipe so
# CONTRIBUTING.md doesn't drift from `.github/workflows/build.yml`.
#
# Usage:
#   make            # build every example PDF + the README preview image
#   make example    # build examples/example.pdf + examples/preview.png
#   make pdfs       # build PDFs for every examples/*.typ
#   make previews   # build a page-1 PNG for every examples/*.typ
#   make test       # compile every example + fixture (output discarded)
#   make clean      # remove generated PDFs and PNGs
#
# Tool overrides:
#   make TYPST=/path/to/typst   # use a non-default typst binary
#   make PPI=300                # raise preview resolution (default 150)

TYPST     ?= typst
ROOT      := .
PPI       ?= 150

EXAMPLES  := $(wildcard examples/*.typ)
TESTS     := $(wildcard tests/*.typ)
PDFS      := $(EXAMPLES:.typ=.pdf)
PNGS      := $(EXAMPLES:.typ=.png)

.PHONY: all example pdfs previews test check clean help

all: pdfs examples/preview.png

example: examples/example.pdf examples/preview.png

pdfs: $(PDFS)

previews: $(PNGS)

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

# Compile every example + fixture; output goes to /dev/null. Same
# shape as the CI lint job, so a green `make test` locally means the
# CI lint step will also pass.
test:
	@status=0; \
	for f in $(EXAMPLES) $(TESTS); do \
	  printf '  %s\n' "$$f"; \
	  if ! $(TYPST) compile --root $(ROOT) --format pdf "$$f" /dev/null; then \
	    status=1; \
	  fi; \
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
	rm -f $(PDFS) $(PNGS) examples/preview.png examples/preview-*.png

help:
	@echo "Targets:"
	@echo "  all       Build every example PDF and the README preview (default)"
	@echo "  example   Build examples/example.pdf + examples/preview.png"
	@echo "  pdfs      Build PDFs for every examples/*.typ"
	@echo "  previews  Build page-1 PNGs for every examples/*.typ"
	@echo "  test      Compile every example + fixture, discarding output"
	@echo "  check     Alias for test (matches the CI lint shape)"
	@echo "  clean     Remove generated PDFs and PNGs"
	@echo ""
	@echo "Overrides: TYPST=path/to/typst, PPI=300"
