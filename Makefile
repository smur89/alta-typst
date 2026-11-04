# altacv — local build helper; CI calls these same targets.
#
# `make help` lists the targets and the variables you can override,
# from the `## ` note on each rule and `?=` default.

# A failed `typst compile` can leave a partial target newer than its
# source, which the next `make` would treat as fresh. Delete it instead.
.DELETE_ON_ERROR:

TYPST     ?= typst ## the typst binary
# When set, Typst searches only these directories (plus the fonts it
# bundles), never the system's, so a render doesn't depend on what else
# the machine has installed: a font both bundled and installed (DejaVu
# Sans Mono on CI's runner) would otherwise resolve differently per
# machine. The pinned image (`docker-pdfs`) and CI set it; host runs
# leave it empty and use system fonts.
FONT_PATHS ?= ## colon-separated font directories; when set, the only fonts besides Typst's own
TYPSTYLE  ?= typstyle ## the typstyle binary
FFMPEG    ?= ffmpeg ## the ffmpeg binary
ROOT      := .
ifneq ($(strip $(FONT_PATHS)),)
export TYPST_IGNORE_SYSTEM_FONTS := true
export TYPST_FONT_PATHS := $(FONT_PATHS)
endif
PPI       ?= 150 ## preview PNG resolution
# Animated-preview frame rate: 0.4 → 2.5 s per frame.
PREVIEW_FPS ?= 0.4 ## GIF frame rate

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

# `_`-prefixed examples are shared helpers, not documents. example-full
# (gallery needs every page) and preview-frames (page 1 has no
# consumer) skip the page-1 PNG sweep.
EXAMPLES      := $(filter-out examples/_%.typ,$(wildcard examples/*.typ))
EXAMPLES_PNG  := $(filter-out examples/example-full.typ examples/preview-frames.typ,$(EXAMPLES))
TESTS         := $(wildcard tests/*.typ)
PANIC_TESTS   := $(wildcard tests/panics/*.typ)
# `assert`-based checks of the side-effect-free helpers; underscore files are
# shared helpers, not tests.
UNIT_TESTS    := $(filter-out tests/unit/_%.typ,$(wildcard tests/unit/*.typ))
# example-full.typ renders to the published name the README and the
# release link to.
EXAMPLE_FULL_PDF := examples/example_full.pdf
PDFS          := $(filter-out examples/example-full.pdf,$(EXAMPLES:.typ=.pdf)) $(EXAMPLE_FULL_PDF)
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
  $(EXAMPLE_FULL_PDF) \
  examples/example_full-1.png examples/example_full-2.png \
  examples/labels-ga.toml

.PHONY: all cv example-full thumbnail release-artifacts preview-gif pdfs previews test-pdfs test test-compile test-fixtures test-panics test-unit test-template check-drift fmt fmt-check check clean help docker-pdfs docker-preview-images docker-shell stage-package-dir package-tarball

# Pinned CI image. Built and published by .github/workflows/image.yml;
# bump the tag here when bumping Typst / FontAwesome / Lato versions
# in the Dockerfile (image.yml derives the same tag and pushes it).
DOCKER_IMAGE ?= ghcr.io/smur89/alta-typst-ci:typst-0.15.1-fa-7.0.0-lato-2.015-r0 ## the pinned CI image

# `--platform linux/amd64` keeps output byte-identical to CI on any
# host (Apple Silicon emulates: slow but reproducible).
#
# The image bakes no @preview cache and `-u` leaves HOME unwritable
# ("Permission denied" on first download), so the cache lives in the
# bind mount (`.typst-cache/`, gitignored) and persists across runs.
DOCKER_RUN = docker run --rm --platform linux/amd64 -v "$(CURDIR):/work" -w /work \
  -e TYPST_PACKAGE_CACHE_PATH=/work/.typst-cache \
  -e FONT_PATHS=/usr/share/fonts/lato:/usr/share/fonts/fontawesome

all: pdfs cv test-pdfs thumbnail ## build every example PDF, the cv preview and every fixture PDF

preview-gif: examples/preview.gif ## build the animated README hero (needs ffmpeg)

# The canonical demo: template/cv.typ as PDF (reviewer/release
# artifact) + page-1 PNG (tracked README preview).
cv: examples/cv.pdf examples/cv.png ## build examples/cv.pdf + cv.png from template/cv.typ

# The per-page PNGs are side-effects of the PDF recipe (see the
# example_full.pdf rule for why they aren't targets).
example-full: $(EXAMPLE_FULL_PDF) ## build examples/example_full.pdf + per-page gallery PNGs

# Universe package-card thumbnail. typst/packages requires a page of
# the *template* as initialised, long edge ≥ 1080 px, ≤ 3 MiB. 180 PPI
# gives a ~2105 px long edge, well under package-check's 1 MiB
# "large file" hint; the card displays far fewer pixels anyway.
THUMB_PPI  ?= 180 ## thumbnail resolution

thumbnail: thumbnail.png ## build thumbnail.png, the Universe package card

thumbnail.png: $(TEMPLATE_SRC) $(LIB_SOURCES)
	$(call render-page1,$<,$(THUMB_PPI),$@)

# Everything CI publishes (reviewer artifacts, package-check staging,
# release assets) — one name so the three jobs can't drift.
release-artifacts: cv example-full thumbnail ## build everything CI uploads and releases

$(TEMPLATE_SRC): template/cv.typ
	sed '$(LOCAL_IMPORT_SED)' $< > $@

pdfs: $(PDFS) ## build a PDF for every examples/*.typ

previews: $(PNGS) ## build a page-1 PNG for every examples/*.typ

# One tracked PDF per fixture, so reviewers can browse renders without
# rebuilding. `--creation-timestamp 0` pins CreationDate so rebuilds
# are byte-identical — otherwise the CI drift check always fails.
test-pdfs: $(TEST_PDFS) ## render every tests/*.typ fixture into examples/tests/*.pdf

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
$(EXAMPLE_FULL_PDF): examples/example-full.typ examples/_dates.typ $(LIB_SOURCES)
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
# As PDF/A-2b, which backs the README's PDF/A section; the output is
# discarded, so the committed renders are unaffected.
define compile-check
@status=0; \
for f in $(1); do \
  name=$$f; [ "$$f" = "$(TEMPLATE_SRC)" ] && name=template/cv.typ; \
  if [ -n "$$GITHUB_ACTIONS" ]; then printf '::group::%s\n' "$$name"; \
  else printf '  %s\n' "$$name"; fi; \
  if ! $(TYPST) compile --root $(ROOT) --format pdf --pdf-standard a-2b "$$f" /dev/null; then \
    if [ -n "$$GITHUB_ACTIONS" ]; then \
      printf '::error file=%s::compile failed\n' "$$name"; \
    fi; \
    status=1; \
  fi; \
  if [ -n "$$GITHUB_ACTIONS" ]; then printf '::endgroup::\n'; fi; \
done; \
exit $$status
endef

# Every check CI's lint job runs, so a green `make test` locally means
# it will pass too. CI renders the fixtures with `test-pdfs` instead of
# `test-fixtures`, which would compile them a second time.
test: test-compile test-fixtures test-panics test-unit ## compile examples, fixtures and template; run panic and unit checks

# The examples and the `typst init` starter (via `$(TEMPLATE_SRC)`, as
# template/cv.typ's `@preview/altacv` import won't resolve locally — a
# broken starter trips here before release). The prerequisite also
# covers preview-frames.typ, which reads its CV from `$(TEMPLATE_SRC)`
# through examples/_cv.typ.
test-compile: $(TEMPLATE_SRC) ## compile every example and the template
	$(call compile-check,$(EXAMPLES) $(TEMPLATE_SRC))

test-fixtures: ## compile every tests/*.typ fixture, output discarded
	$(call compile-check,$(TESTS))

# A failed `assert` fails the compile.
test-unit: ## run the helper checks under tests/unit/
	$(call compile-check,$(UNIT_TESTS))

# Every tests/panics/*.typ must FAIL to compile, and its error output
# must contain the text after the file's leading `// expect: ` line —
# so each validator's message is pinned, and a check that stops firing
# (or starts failing for a different reason) breaks the build.
test-panics: ## check each tests/panics/*.typ fails with its `// expect:` text
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

# A quick check after editing template/cv.typ; `test-compile` covers it.
test-template: $(TEMPLATE_SRC) ## compile-check template/cv.typ on its own
	$(call compile-check,$(TEMPLATE_SRC))

# Fail if any tracked render under DRIFT_PATHS differs from HEAD. The
# CI drift gates run this right after regenerating with `make -B` (see
# `docker-preview-images` below for why `-B`).
#
#   make check-drift DRIFT_PATHS='examples/tests/*.pdf' DRIFT_FIX='make docker-pdfs'
#
# Entries are single-quoted so git expands the pathspec (a shell glob
# misses deleted files). `git status` also catches untracked files,
# which `git diff --quiet` misses; `--untracked-files=all` lists files
# inside new directories so they match the pathspec.
check-drift: ## fail if tracked renders differ (DRIFT_PATHS=, DRIFT_FIX=)
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
fmt: ## format every tracked .typ in place (typstyle)
	$(TYPSTYLE) --inplace $(shell git ls-files '*.typ')

fmt-check: ## check formatting without writing (the CI gate)
	$(TYPSTYLE) --check $(shell git ls-files '*.typ')

check: test fmt-check ## test + fmt-check: the local equivalent of CI's lint and typstyle

# Stage the PACKAGE_FILES set into PKG_DIR for the PR-time
# package-check job, so a missing file is caught at review time.
#
#   make stage-package-dir PKG_DIR=/tmp/.../altacv/0.0.0
#
# `pipefail` so a failing tar producer isn't masked by the consumer's
# clean exit; invoked via bash, not .SHELLFLAGS, for Make < 3.82.
stage-package-dir: ## stage the files that ship to typst/packages
	@test -n "$(PKG_DIR)" || { echo "stage-package-dir: PKG_DIR=/path required" >&2; exit 2; }
	@mkdir -p "$(PKG_DIR)"
	@bash -eo pipefail -c 'tar cf - $(PACKAGE_FILES) | tar xf - -C "$(PKG_DIR)"'

# Same file set, gzipped: the release asset submitted to typst/packages.
#
#   make package-tarball PACKAGE_TARBALL=$(PACKAGE_NAME)-$(VERSION).tar.gz
package-tarball: ## build the release tarball from the staged package
	@test -n "$(PACKAGE_TARBALL)" || { echo "package-tarball: PACKAGE_TARBALL=/path.tar.gz required" >&2; exit 2; }
	tar czf "$(PACKAGE_TARBALL)" $(PACKAGE_FILES)

# Also removes tracked renders (examples/cv.png, thumbnail.png, the
# fixture PDFs, …); `git checkout` restores them.
clean: ## remove generated PDFs and PNGs
	rm -f $(PDFS) $(PNGS) $(TEST_PDFS) examples/cv.pdf examples/cv.png examples/preview.gif examples/.preview-gif-frame-*.png examples/example_full-*.png thumbnail.png $(TEMPLATE_SRC)

help: ## list these targets and the variables you can override
	@awk -F':[^=]*## ' '/^[a-zA-Z0-9_.-]+:[^=]*## /{printf "  %-22s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo 'Overrides (make VAR=value):'
	@awk -F' *[?]= *| *## ' '/^[A-Z_]+ *[?]=.*## /{printf "  %-22s %s (default %s)\n", $$1, $$3, $$2}' $(MAKEFILE_LIST)

# Regenerate every committed PDF/PNG fixture inside the pinned CI
# image. Use before committing any change that affects rendering
# (icon glyphs, lib.typ, sections/*.typ, font setup) — the CI's
# "examples/tests/*.pdf in sync" guard fails otherwise. `-B` because
# a merge or checkout gives tracked outputs fresh mtimes, so make
# would skip them and the stale bytes surface later as CI drift.
# `-u` keeps outputs owned by the host user rather than root on Linux.
docker-pdfs: ## regenerate every committed render in the pinned CI image
	$(DOCKER_RUN) -u "$(shell id -u):$(shell id -g)" $(DOCKER_IMAGE) make -B all

# Just the two tracked preview PNGs. Raster output is
# environment-sensitive (unlike the fixture PDFs), so the pinned image
# is their only canonical source; the `preview-images-in-sync` CI gate
# runs this same target. `-B` for the same mtime reason as above.
docker-preview-images: ## regenerate cv.png + thumbnail.png in the pinned image
	$(DOCKER_RUN) -u "$(shell id -u):$(shell id -g)" $(DOCKER_IMAGE) make -B cv thumbnail

# Interactive shell in the CI image. Runs as root (no `-u`) so you can
# `apk add` debugging tools.
docker-shell: ## open a shell in the pinned CI image
	$(DOCKER_RUN) -it --entrypoint bash $(DOCKER_IMAGE)
