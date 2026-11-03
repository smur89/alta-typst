# altacv — local build helper; CI calls these same targets.
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
#   make release-artifacts # build everything CI uploads / releases
#                    # (cv + example-full + thumbnail)
#   make test        # compile every example + fixture + the template
#                    # starter (output discarded), plus test-panics
#                    # and test-unit
#   make test-unit   # run the helper checks under tests/unit/
#   make test-panics # check every tests/panics/*.typ fails with the
#                    # message its `// expect:` line names
#   make test-template # compile-check template/cv.typ on its own
#   make check-drift DRIFT_PATHS='<pathspec>' DRIFT_FIX='<cmd>'
#                    # fail if tracked renders differ from HEAD
#   make fmt         # format every tracked .typ in place (typstyle)
#   make fmt-check   # check formatting without writing (CI gate)
#   make toolchain   # print the pinned Typst/FA/Lato versions + image
#   make clean       # remove generated PDFs and PNGs
#
# Tool overrides:
#   make TYPST=/path/to/typst    # use a non-default typst binary
#   make TYPSTYLE=/path/to/typstyle # use a non-default typstyle binary
#   make FFMPEG=/path/to/ffmpeg  # use a non-default ffmpeg binary
#   make PPI=300                 # raise preview resolution (default 150)
#   make PREVIEW_FPS=1           # adjust GIF frame rate (default 0.4)

# A failed `typst compile` can leave a partial target newer than its
# source, which the next `make` would treat as fresh. Delete it instead.
.DELETE_ON_ERROR:

TYPST     ?= typst
TYPSTYLE  ?= typstyle
FFMPEG    ?= ffmpeg
ROOT      := .
PPI       ?= 150
# Animated-preview frame rate: 0.4 → 2.5 s per frame.
PREVIEW_FPS ?= 0.4

# Swaps the template's `@preview/altacv:<version>` import for the
# in-tree `/lib.typ`; `[^"]*` matches any version release-please writes.
LOCAL_IMPORT_SED := s|@preview/altacv:[^"]*|/lib.typ|

# template/cv.typ imports `@preview/altacv`, which doesn't resolve in
# this repo, so recipes compile this import-swapped copy instead and
# the template ships verbatim. At the repo root so `/lib.typ` resolves
# under `--root $(ROOT)`. One shared file target, so `make -j` doesn't
# race on per-recipe temp copies. Gitignored.
TEMPLATE_SRC  := .template-src.typ

# Render page 1 of a document straight to a PNG:
#   $(call render-page1,<src>,<ppi>,<out>)
render-page1 = $(TYPST) compile --root $(ROOT) --format png --ppi $(2) --pages 1 $(1) $(3)

# `_`-prefixed examples are shared helpers, not documents. example_full
# (gallery needs every page) and preview-frames (page 1 has no
# consumer) skip the page-1 PNG sweep.
EXAMPLES      := $(filter-out examples/_%.typ,$(wildcard examples/*.typ))
EXAMPLES_PNG  := $(filter-out examples/example_full.typ examples/preview-frames.typ,$(EXAMPLES))
TESTS         := $(wildcard tests/*.typ)
PANIC_TESTS   := $(wildcard tests/panics/*.typ)
# `assert`-based checks of the side-effect-free helpers; underscore files are
# shared helpers, not tests.
UNIT_TESTS    := $(filter-out tests/unit/_%.typ,$(wildcard tests/unit/*.typ))
PDFS          := $(EXAMPLES:.typ=.pdf)
PNGS          := $(EXAMPLES_PNG:.typ=.png)
TEST_PDFS     := $(patsubst tests/%.typ,examples/tests/%.pdf,$(TESTS))
# Everything `lib.typ` reads at compile time. Every render depends on
# it, so a renderer edit can't leave stale outputs to be committed.
LIB_SOURCES   := lib.typ $(wildcard internal/*.typ internal/*/*.typ) \
  $(wildcard internal/*/*.toml) \
  $(wildcard sections/*.typ) $(wildcard assets/*)

# Files that ship to typst/packages: shared by the release tarball and
# the PR-time package-check stager so the two can't drift.
PACKAGE_FILES := \
  typst.toml lib.typ internal sections assets template \
  thumbnail.png LICENSE README.md CONTRIBUTING.md \
  examples/preview.gif \
  examples/cv.png \
  examples/example_full.pdf \
  examples/example_full-1.png examples/example_full-2.png \
  examples/labels-ga.toml

.PHONY: all cv example-full thumbnail release-artifacts preview-gif pdfs previews test-pdfs test test-panics test-unit test-template check-drift fmt fmt-check check clean help docker-pdfs docker-preview-images docker-shell toolchain stage-package-dir package-tarball

# The pinned toolchain (versions: see Dockerfile). `make toolchain`
# prints it for CI and for setting up a matching local install.
dockerfile-value = $(shell sed -nE 's|^$(1)||p' Dockerfile)
TYPST_VERSION    := $(call dockerfile-value,FROM ghcr\.io/typst/typst:)
FA_VERSION       := $(call dockerfile-value,ARG FA_VERSION=)
LATO_APK_VERSION := $(call dockerfile-value,ARG LATO_APK_VERSION=)

# Pinned CI image, tagged with every render-critical version so a bump
# yields a new immutable tag. Built and published by
# .github/workflows/image.yml.
DOCKER_IMAGE ?= ghcr.io/smur89/alta-typst-ci:typst-$(TYPST_VERSION)-fa-$(FA_VERSION)-lato-$(LATO_APK_VERSION)

# `--platform linux/amd64` keeps output byte-identical to CI on any
# host (Apple Silicon emulates: slow but reproducible).
#
# The image bakes no @preview cache and `-u` leaves HOME unwritable
# ("Permission denied" on first download), so the cache lives in the
# bind mount (`.typst-cache/`, gitignored) and persists across runs.
DOCKER_RUN = docker run --rm --platform linux/amd64 -v "$(CURDIR):/work" -w /work \
  -e TYPST_PACKAGE_CACHE_PATH=/work/.typst-cache

all: pdfs cv test-pdfs thumbnail

preview-gif: examples/preview.gif

# The canonical demo: template/cv.typ as PDF (reviewer/release
# artifact) + page-1 PNG (tracked README preview).
cv: examples/cv.pdf examples/cv.png

# The per-page PNGs are side-effects of the PDF recipe (see the
# example_full.pdf rule for why they aren't targets).
example-full: examples/example_full.pdf

# Universe package-card thumbnail. typst/packages requires a page of
# the *template* as initialised, long edge ≥ 1080 px, ≤ 3 MiB. 180 PPI
# gives a ~2105 px long edge, well under package-check's 1 MiB
# "large file" hint; the card displays far fewer pixels anyway.
THUMB_PPI  ?= 180

thumbnail: thumbnail.png

thumbnail.png: $(TEMPLATE_SRC) $(LIB_SOURCES)
	$(call render-page1,$<,$(THUMB_PPI),$@)

# Everything CI publishes (reviewer artifacts, package-check staging,
# release assets) — one name so the three jobs can't drift.
release-artifacts: cv example-full thumbnail

$(TEMPLATE_SRC): template/cv.typ
	sed '$(LOCAL_IMPORT_SED)' $< > $@

pdfs: $(PDFS)

previews: $(PNGS)

# One tracked PDF per fixture, so reviewers can browse renders without
# rebuilding. `--creation-timestamp 0` pins CreationDate so rebuilds
# are byte-identical — otherwise the CI drift check always fails.
test-pdfs: $(TEST_PDFS)

examples/tests:
	mkdir -p $@

examples/tests/%.pdf: tests/%.typ $(LIB_SOURCES) | examples/tests
	$(TYPST) compile --creation-timestamp 0 --root $(ROOT) $< $@

# Coarse but self-maintaining: any fixture-data edit rebuilds every test PDF.
$(TEST_PDFS): $(wildcard tests/fixtures/*)

examples/%.pdf: examples/%.typ $(LIB_SOURCES)
	$(TYPST) compile --root $(ROOT) $< $@

# preview-frames.typ reads its CV via examples/_cv.typ from
# `$(TEMPLATE_SRC)`. Recipe-less: adds prereqs, the pattern rule
# above still supplies the recipe.
PREVIEW_FRAMES_DEPS := examples/_cv.typ $(TEMPLATE_SRC)
examples/preview-frames.pdf: $(PREVIEW_FRAMES_DEPS)

# The per-page PNGs aren't listed as targets: pre-4.3 GNU Make parses
# `A B C: deps` as N independent rules, which race under `make -j`.
# The `rm` stops a page-count shrink leaving an orphan PNG behind.
examples/example_full.pdf: examples/example_full.typ examples/_dates.typ $(LIB_SOURCES)
	rm -f examples/example_full-*.png
	$(TYPST) compile --creation-timestamp 0 --root $(ROOT) --format pdf $< $@
	$(TYPST) compile --root $(ROOT) --format png --ppi $(PPI) $< 'examples/example_full-{p}.png'

examples/%.png: examples/%.typ $(LIB_SOURCES)
	$(call render-page1,$<,$(PPI),$@)

examples/cv.pdf: $(TEMPLATE_SRC) $(LIB_SOURCES)
	$(TYPST) compile --root $(ROOT) $< $@

examples/cv.png: $(TEMPLATE_SRC) $(LIB_SOURCES)
	$(call render-page1,$<,$(PPI),$@)

# Animated README hero: one page per variation in preview-frames.typ,
# stitched with `palettegen` + `paletteuse` for better colour than a
# default GIF. Local-only and committed; CI never regenerates it.
# Prereqs must cover every file preview-frames.typ transitively reads.
examples/preview.gif: examples/preview-frames.typ $(PREVIEW_FRAMES_DEPS) examples/labels-ga.toml $(LIB_SOURCES)
	$(TYPST) compile --root $(ROOT) --format png --ppi $(PPI) $< 'examples/.preview-gif-frame-{p}.png'
	$(FFMPEG) -framerate $(PREVIEW_FPS) -i 'examples/.preview-gif-frame-%d.png' \
	  -vf "split[s0][s1];[s0]palettegen=stats_mode=diff[p];[s1][p]paletteuse=dither=sierra2_4a" \
	  -loop 0 -y $@
	rm -f examples/.preview-gif-frame-*.png

# Compile each listed file to /dev/null, carrying on past failures so
# one run reports every broken file:
#   $(call compile-check,<files>)
# On GitHub Actions it adds log groups and `::error file=` annotations.
# `$(TEMPLATE_SRC)` is reported as template/cv.typ, the file people edit.
define compile-check
@status=0; \
for f in $(1); do \
  name=$$f; [ "$$f" = "$(TEMPLATE_SRC)" ] && name=template/cv.typ; \
  if [ -n "$$GITHUB_ACTIONS" ]; then printf '::group::%s\n' "$$name"; \
  else printf '  %s\n' "$$name"; fi; \
  if ! $(TYPST) compile --root $(ROOT) --format pdf "$$f" /dev/null; then \
    if [ -n "$$GITHUB_ACTIONS" ]; then \
      printf '::error file=%s::compile failed\n' "$$name"; \
    fi; \
    status=1; \
  fi; \
  if [ -n "$$GITHUB_ACTIONS" ]; then printf '::endgroup::\n'; fi; \
done; \
exit $$status
endef

# Compile every example, every fixture, and the `typst init` starter
# (via `$(TEMPLATE_SRC)`, since template/cv.typ's `@preview/altacv`
# import won't resolve locally — a broken starter trips here before
# release). The prerequisite also covers preview-frames.typ, which
# reads its CV from `$(TEMPLATE_SRC)` through examples/_cv.typ. This
# is the CI lint job's compile step, so a green `make test` locally
# means it will pass too.
test: $(TEMPLATE_SRC) test-panics test-unit
	$(call compile-check,$(EXAMPLES) $(TESTS) $(TEMPLATE_SRC))

# Just the helper checks under tests/unit/ — a failed `assert` fails
# the compile. `make test` already covers them.
test-unit:
	$(call compile-check,$(UNIT_TESTS))

# Every tests/panics/*.typ must FAIL to compile, and its error output
# must contain the text after the file's leading `// expect: ` line —
# so each validator's message is pinned, and a check that stops firing
# (or starts failing for a different reason) breaks the build.
test-panics:
	@status=0; \
	for f in $(PANIC_TESTS); do \
	  expect=$$(sed -n '1s|^// expect: ||p' "$$f"); \
	  if [ -z "$$expect" ]; then \
	    printf '%s: missing leading `// expect: <message>` line\n' "$$f" >&2; status=1; continue; \
	  fi; \
	  msg=; \
	  if out=$$($(TYPST) compile --root $(ROOT) --format pdf "$$f" /dev/null 2>&1); then \
	    msg="compiled, expected a failure containing: $$expect"; \
	  elif ! printf '%s' "$$out" | grep -qF -- "$$expect"; then \
	    msg="failed without: $$expect"; \
	  fi; \
	  if [ -n "$$msg" ]; then \
	    status=1; printf '%s: %s\n%s\n' "$$f" "$$msg" "$$out" >&2; \
	    if [ -n "$$GITHUB_ACTIONS" ]; then printf '::error file=%s::%s\n' "$$f" "$$msg"; fi; \
	  fi; \
	done; \
	exit $$status

# Just the template starter — a quick check after editing
# template/cv.typ. `make test` already covers it.
test-template: $(TEMPLATE_SRC)
	$(call compile-check,$(TEMPLATE_SRC))

# Fail if any tracked render under DRIFT_PATHS differs from HEAD. The
# CI drift gates run this right after regenerating with `make -B` (see
# `docker-preview-images` below for why `-B`).
#
#   make check-drift DRIFT_PATHS='examples/tests/*.pdf' DRIFT_FIX='make test-pdfs'
#
# Entries are single-quoted so git expands the pathspec (a shell glob
# misses deleted files). `git status` also catches untracked files,
# which `git diff --quiet` misses; `--untracked-files=all` lists files
# inside new directories so they match the pathspec.
check-drift:
	@test -n "$(DRIFT_PATHS)" || { echo "check-drift: DRIFT_PATHS='<pathspec>' required" >&2; exit 2; }
	@drift=$$(git status --porcelain --untracked-files=all -- $(foreach p,$(DRIFT_PATHS),'$(p)')); \
	if [ -n "$$drift" ]; then \
	  msg="$(DRIFT_PATHS) out of date — run '$(DRIFT_FIX)' locally and commit the result"; \
	  if [ -n "$$GITHUB_ACTIONS" ]; then printf '::error::%s\n' "$$msg"; \
	  else printf 'check-drift: %s\n' "$$msg" >&2; fi; \
	  printf '%s\n' "$$drift"; \
	  exit 1; \
	fi

# `git ls-files`, not a directory walk, so the sweep never touches the
# third-party @preview sources in `.typst-cache/`. Use the typstyle
# version CI pins (TYPSTYLE_VERSION in build.yml).
fmt:
	$(TYPSTYLE) --inplace $(shell git ls-files '*.typ')

fmt-check:
	$(TYPSTYLE) --check $(shell git ls-files '*.typ')

# Every CI lint gate (lint + typstyle jobs) in one local command.
check: test fmt-check

# Stage the PACKAGE_FILES set into PKG_DIR for the PR-time
# package-check job, so a missing file is caught at review time.
#
#   make stage-package-dir PKG_DIR=/tmp/.../altacv/0.0.0
#
# `pipefail` so a failing tar producer isn't masked by the consumer's
# clean exit; invoked via bash, not .SHELLFLAGS, for Make < 3.82.
stage-package-dir:
	@test -n "$(PKG_DIR)" || { echo "stage-package-dir: PKG_DIR=/path required" >&2; exit 2; }
	@mkdir -p "$(PKG_DIR)"
	@bash -eo pipefail -c 'tar cf - $(PACKAGE_FILES) | tar xf - -C "$(PKG_DIR)"'

# Same file set, gzipped: the release asset submitted to typst/packages.
#
#   make package-tarball PACKAGE_TARBALL=$(PACKAGE_NAME)-$(VERSION).tar.gz
package-tarball:
	@test -n "$(PACKAGE_TARBALL)" || { echo "package-tarball: PACKAGE_TARBALL=/path.tar.gz required" >&2; exit 2; }
	tar czf "$(PACKAGE_TARBALL)" $(PACKAGE_FILES)

# Also removes tracked renders (examples/cv.png, thumbnail.png, the
# fixture PDFs, …); `git checkout` restores them.
clean:
	rm -f $(PDFS) $(PNGS) $(TEST_PDFS) examples/cv.pdf examples/cv.png examples/preview.gif examples/.preview-gif-frame-*.png examples/example_full-*.png thumbnail.png $(TEMPLATE_SRC)

help:
	@printf '%s\n' 'Targets: all (default) | cv | example-full | thumbnail | preview-gif' \
	  '         release-artifacts (cv + example-full + thumbnail)' \
	  '         pdfs | previews | test-pdfs | test | test-panics | test-unit | test-template | clean' \
	  '         fmt | fmt-check | check (test + fmt-check)' \
	  '         check-drift DRIFT_PATHS=<pathspec> DRIFT_FIX=<cmd>' \
	  '         docker-pdfs | docker-preview-images | docker-shell | toolchain' \
	  'Per-target detail: see the header comment in this Makefile.' \
	  'Overrides: TYPST=path/to/typst TYPSTYLE=path/to/typstyle FFMPEG=path/to/ffmpeg' \
	  '           PPI=300 PREVIEW_FPS=1 DOCKER_IMAGE=ghcr.io/.../...:tag'

# Regenerate every committed PDF/PNG fixture inside the pinned CI
# image. Use before committing any change that affects rendering
# (icon glyphs, lib.typ, sections/*.typ, font setup) — the CI's
# "examples/tests/*.pdf in sync" guard fails otherwise. `-B` because
# a merge or checkout gives tracked outputs fresh mtimes, so make
# would skip them and the stale bytes surface later as CI drift.
# `-u` keeps outputs owned by the host user rather than root on Linux.
docker-pdfs:
	$(DOCKER_RUN) -u "$(shell id -u):$(shell id -g)" $(DOCKER_IMAGE) make -B all

# Just the two tracked preview PNGs. Raster output is
# environment-sensitive (unlike the fixture PDFs), so the pinned image
# is their only canonical source; the `preview-images-in-sync` CI gate
# runs this same target. `-B` for the same mtime reason as above.
docker-preview-images:
	$(DOCKER_RUN) -u "$(shell id -u):$(shell id -g)" $(DOCKER_IMAGE) make -B cv thumbnail

# Interactive shell in the CI image. Runs as root (no `-u`) so you can
# `apk add` debugging tools.
docker-shell:
	$(DOCKER_RUN) -it --entrypoint bash $(DOCKER_IMAGE)

# `key=value` lines for `$GITHUB_OUTPUT`. Fails if the Dockerfile no
# longer matches the patterns above, rather than tagging `typst--fa-…`.
toolchain:
	@test -n "$(TYPST_VERSION)" -a -n "$(FA_VERSION)" -a -n "$(LATO_APK_VERSION)" \
	  || { echo 'Could not read the Typst, FA or Lato version from the Dockerfile' >&2; exit 1; }
	@printf '%s\n' typst=$(TYPST_VERSION) fa=$(FA_VERSION) lato=$(LATO_APK_VERSION) image=$(DOCKER_IMAGE)
