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
#   make release-artifacts # build everything CI uploads / releases
#                    # (cv + example-full + thumbnail)
#   make test        # compile every example + fixture + the template
#                    # starter (output discarded)
#   make test-template # compile-check template/cv.typ on its own
#   make check-drift DRIFT_PATHS='<pathspec>' DRIFT_FIX='<cmd>'
#                    # fail if tracked renders differ from HEAD
#   make fmt         # format every tracked .typ in place (typstyle)
#   make fmt-check   # check formatting without writing (CI gate)
#   make clean       # remove generated PDFs and PNGs
#
# Tool overrides:
#   make TYPST=/path/to/typst    # use a non-default typst binary
#   make TYPSTYLE=/path/to/typstyle # use a non-default typstyle binary
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
TYPSTYLE  ?= typstyle
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
# locally without resolving the package against typst.app. The
# `[^"]*` wildcard tolerates whatever version-string release-please
# writes.
LOCAL_IMPORT_SED := s|@preview/altacv:[^"]*|/lib.typ|

# template/cv.typ uses `#import "@preview/altacv:<version>"` so it
# works after `typst init` on a user's machine, but that path doesn't
# resolve in this repo. Every recipe that renders or checks the
# template compiles this generated copy instead, with the import
# swapped to the in-tree `/lib.typ` — keeping template/cv.typ
# untouched on disk so it ships verbatim. It sits at the repo root so
# `--root $(ROOT)` resolves `/lib.typ` exactly as it would for the
# original. examples/_cv.typ imports the demo `cv` from it too, so the
# animated preview shares the template's data. A single file target
# that make builds once per run, so `make -j` consumers share it
# rather than racing on per-recipe temp copies. Gitignored; `make
# clean` removes it.
TEMPLATE_SRC  := .template-src.typ

# Render page 1 of a document straight to a PNG:
#   $(call render-page1,<src>,<ppi>,<out>)
# `--pages 1` exports only that page, so Typst needs no `{p}`
# placeholder in the output path and there are no per-page temp files
# to rename or clean up. The bytes match page 1 of a full render.
render-page1 = $(TYPST) compile --root $(ROOT) --format png --ppi $(2) --pages 1 $(1) $(3)

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
# Everything `lib.typ` reads at compile time — its transitive
# `#import`s under `internal/` and `sections/`, the default labels
# TOML, and the bundled avatar. Every rendered output (fixtures,
# examples, the cv preview, the thumbnail) depends on the whole set,
# so a renderer tweak invalidates all of them even though their own
# `.typ` source hasn't changed. Without it, a local `make` after
# editing e.g. `sections/skills.typ` leaves stale previews on disk
# that then get committed.
LIB_SOURCES   := lib.typ $(wildcard internal/*.typ) $(wildcard internal/*.toml) \
  $(wildcard sections/*.typ) $(wildcard assets/*)

# Files that ship to typst/packages. Single source of truth for the
# release tarball recipe AND the PR-time package-check stager — pulling
# the list here keeps them from drifting (the drift between the two
# is what slipped CONTRIBUTING.md past 1.4.1's typst-package-check).
PACKAGE_FILES := \
  typst.toml lib.typ internal sections assets template \
  thumbnail.png LICENSE README.md CONTRIBUTING.md \
  examples/preview.gif \
  examples/cv.png \
  examples/example_full.pdf \
  examples/example_full-1.png examples/example_full-2.png \
  examples/labels-ga.toml

.PHONY: all cv example-full thumbnail release-artifacts preview-gif pdfs previews test-pdfs test test-template check-drift fmt fmt-check check clean help docker-pdfs docker-preview-images docker-shell stage-package-dir package-tarball

# Pinned CI image. Built and published by .github/workflows/image.yml;
# bump the tag here when bumping Typst / FontAwesome / Lato versions
# in the Dockerfile (image.yml derives the same tag and pushes it).
DOCKER_IMAGE ?= ghcr.io/smur89/alta-typst-ci:typst-0.15.0-fa-7.0.0-lato-2.015-r0

# `--platform linux/amd64` is forced so output is byte-identical to
# CI regardless of the host (Apple Silicon falls back to emulation —
# slow but reproducible). The workspace is bind-mounted so generated
# PDFs/PNGs land in the host working tree.
#
# The image bakes no @preview cache and `-u` leaves HOME unwritable,
# so first-compile package downloads die with "Permission denied".
# Point the cache into the bind mount (`.typst-cache/`, gitignored) —
# writable by construction, persists across runs.
DOCKER_RUN = docker run --rm --platform linux/amd64 -v "$(CURDIR):/work" -w /work \
  -e TYPST_PACKAGE_CACHE_PATH=/work/.typst-cache

all: pdfs cv test-pdfs thumbnail

preview-gif: examples/preview.gif

# The canonical demo: template/cv.typ rendered as PDF + page-1 PNG.
# Used both as a workflow artifact (PR-reviewer download) and as the
# tracked README preview image. Both render from `$(TEMPLATE_SRC)`.
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
# Renders from `$(TEMPLATE_SRC)` (see its definition above).
THUMB_PPI  ?= 180

thumbnail: thumbnail.png

thumbnail.png: $(TEMPLATE_SRC) $(LIB_SOURCES)
	$(call render-page1,$<,$(THUMB_PPI),$@)

# Everything CI publishes: the build job's reviewer artifacts, the
# rendered files package-check stages, and the release assets. One
# name so the three CI jobs can't drift apart.
release-artifacts: cv example-full thumbnail

$(TEMPLATE_SRC): template/cv.typ
	sed '$(LOCAL_IMPORT_SED)' $< > $@

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

examples/tests/%.pdf: tests/%.typ $(LIB_SOURCES) | examples/tests
	$(TYPST) compile --creation-timestamp 0 --root $(ROOT) $< $@

# tests/fixtures/* isn't in $(LIB_SOURCES). Add as a universal extra
# prereq so any future fixture edit invalidates every test PDF (coarse
# but auto-extends — beats hand-maintaining a per-fixture list).
$(TEST_PDFS): $(wildcard tests/fixtures/*)

# Pattern rule: every examples/X.typ produces examples/X.pdf.
examples/%.pdf: examples/%.typ $(LIB_SOURCES)
	$(TYPST) compile --root $(ROOT) $< $@

# preview-frames.typ takes its CV from examples/_cv.typ, which imports
# it from `$(TEMPLATE_SRC)` — so the generated copy must exist before
# the sweep compiles it, and a template edit must re-render it. A
# recipe-less rule only adds prerequisites; the pattern rule above
# still supplies the recipe.
PREVIEW_FRAMES_DEPS := examples/_cv.typ $(TEMPLATE_SRC)
examples/preview-frames.pdf: $(PREVIEW_FRAMES_DEPS)

# Explicit rule for example_full: a single canonical target (the PDF)
# whose recipe also writes the per-page PNG gallery. The PNGs are
# side-effects — they don't appear as additional rule targets because
# pre-4.3 GNU Make would parse `A B C: deps` as N independent rules
# and race under `make -j`. `.DELETE_ON_ERROR:` (top of file) deletes
# partial outputs if either compile fails. `rm -f examples/example_full-*.png`
# pre-cleans stale page PNGs so a shrink (e.g. 3-page content trimmed
# to 2) doesn't leave an orphan example_full-3.png.
examples/example_full.pdf: examples/example_full.typ examples/_dates.typ $(LIB_SOURCES)
	rm -f examples/example_full-*.png
	$(TYPST) compile --creation-timestamp 0 --root $(ROOT) --format pdf $< $@
	$(TYPST) compile --root $(ROOT) --format png --ppi $(PPI) $< 'examples/example_full-{p}.png'

# Pattern rule: every examples/X.typ produces examples/X.png (page 1).
examples/%.png: examples/%.typ $(LIB_SOURCES)
	$(call render-page1,$<,$(PPI),$@)

# The canonical demo, derived from template/cv.typ via
# `$(TEMPLATE_SRC)`. The PDF is gitignored (workflow / release
# artifact); the PNG is tracked because the README references it via
# raw.githubusercontent without a local rebuild.
examples/cv.pdf: $(TEMPLATE_SRC) $(LIB_SOURCES)
	$(TYPST) compile --root $(ROOT) $< $@

examples/cv.png: $(TEMPLATE_SRC) $(LIB_SOURCES)
	$(call render-page1,$<,$(PPI),$@)

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
examples/preview.gif: examples/preview-frames.typ $(PREVIEW_FRAMES_DEPS) examples/labels-ga.toml $(LIB_SOURCES)
	$(TYPST) compile --root $(ROOT) --format png --ppi $(PPI) $< 'examples/.preview-gif-frame-{p}.png'
	$(FFMPEG) -framerate $(PREVIEW_FPS) -i 'examples/.preview-gif-frame-%d.png' \
	  -vf "split[s0][s1];[s0]palettegen=stats_mode=diff[p];[s1][p]paletteuse=dither=sierra2_4a" \
	  -loop 0 -y $@
	rm -f examples/.preview-gif-frame-*.png

# Compile each listed file to /dev/null, carrying on past failures so
# one run reports every broken file:
#   $(call compile-check,<files>)
# When `GITHUB_ACTIONS` is set (i.e. the recipe is running on a GitHub
# Actions runner) it also emits `::group::` / `::endgroup::` markers
# for collapsible per-file log sections and `::error file=<path>::`
# annotations for failing files, so failures surface in the PR file
# view. `$(TEMPLATE_SRC)` is reported as template/cv.typ — the file a
# contributor actually edits, so that's where the annotation belongs.
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
test: $(TEMPLATE_SRC)
	$(call compile-check,$(EXAMPLES) $(TESTS) $(TEMPLATE_SRC))

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
# DRIFT_PATHS is a git pathspec, so a glob like `*.pdf` filters out
# unrelated drift (an editor swap file) without a `grep`; each entry
# is single-quoted so git, not the shell, expands the glob (a shell
# glob only sees files on disk, missing deletions). `git status
# --porcelain` catches modified, untracked AND deleted files (`git
# diff --quiet` misses untracked); `--untracked-files=all` lists new
# files individually so they match the pathspec even inside a new
# directory. DRIFT_FIX is the command the error tells contributors to
# run before committing.
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

# Format every tracked Typst source in place with typstyle. `git
# ls-files` (not a recursive dir arg) so the sweep never descends into
# the gitignored `.typst-cache/`, which holds third-party @preview
# package sources we must not touch. Pin typstyle to the version the
# CI `typstyle` job uses (see build.yml) so local runs and CI agree.
fmt:
	$(TYPSTYLE) --inplace $(shell git ls-files '*.typ')

# Check mode — exits non-zero if any file isn't formatted. Same target
# the CI `typstyle` job runs; `make check` composes it so one local
# command mirrors every CI lint gate.
fmt-check:
	$(TYPSTYLE) --check $(shell git ls-files '*.typ')

# Alias for the CI lint gates — compiles everything including the
# `typst init` starter (`test`) and verifies formatting (`fmt-check`),
# so a green `make check` locally means the lint + typstyle CI jobs
# will pass too.
check: test fmt-check

# Stage every file that ships to typst/packages into PKG_DIR. Used by
# the CI package-check job (PR-time) to lay out the same file set the
# release tarball would publish — typst-package-check then validates
# THAT directory, so a missing file is caught at review time.
#
#   make stage-package-dir PKG_DIR=/tmp/.../altacv/0.0.0
#
# `bash -eo pipefail` so a missing file makes the tar producer fail
# the recipe — without pipefail the consumer's clean exit would
# silently mask a partial stage. Invoked explicitly (not via
# .SHELLFLAGS) so this works on Make < 3.82.
stage-package-dir:
	@test -n "$(PKG_DIR)" || { echo "stage-package-dir: PKG_DIR=/path required" >&2; exit 2; }
	@mkdir -p "$(PKG_DIR)"
	@bash -eo pipefail -c 'tar cf - $(PACKAGE_FILES) | tar xf - -C "$(PKG_DIR)"'

# Same file set, gzipped — the artifact attached to the GitHub Release
# and uploaded to typst/packages.
#
#   make package-tarball PACKAGE_TARBALL=$(PACKAGE_NAME)-$(VERSION).tar.gz
package-tarball:
	@test -n "$(PACKAGE_TARBALL)" || { echo "package-tarball: PACKAGE_TARBALL=/path.tar.gz required" >&2; exit 2; }
	tar czf "$(PACKAGE_TARBALL)" $(PACKAGE_FILES)

# Removes every generated artifact, including `examples/cv.png`. That
# file is tracked in git for stable README image hosting, but it's
# regenerated from `template/cv.typ` — run `make cv` (or
# `git checkout examples/cv.png`) after `make clean` to put it back.
clean:
	rm -f $(PDFS) $(PNGS) $(TEST_PDFS) examples/cv.pdf examples/cv.png examples/preview.gif examples/.preview-gif-frame-*.png examples/example_full-*.png thumbnail.png $(TEMPLATE_SRC)

help:
	@printf '%s\n' 'Targets: all (default) | cv | example-full | thumbnail | preview-gif' \
	  '         release-artifacts (cv + example-full + thumbnail)' \
	  '         pdfs | previews | test-pdfs | test | test-template | clean' \
	  '         fmt | fmt-check | check (test + fmt-check)' \
	  '         check-drift DRIFT_PATHS=<pathspec> DRIFT_FIX=<cmd>' \
	  '         docker-pdfs | docker-preview-images | docker-shell' \
	  'Per-target detail: see the header comment in this Makefile.' \
	  'Overrides: TYPST=path/to/typst TYPSTYLE=path/to/typstyle FFMPEG=path/to/ffmpeg' \
	  '           PPI=300 PREVIEW_FPS=1 DOCKER_IMAGE=ghcr.io/.../...:tag'

# Regenerate every committed PDF/PNG fixture inside the pinned CI
# image. Use before committing any change that affects rendering
# (icon glyphs, lib.typ, sections/*.typ, font setup) — the CI's
# "examples/tests/*.pdf in sync" guard fails otherwise. `all` already
# depends on test-pdfs, cv, pdfs (example-full and the rest), and
# thumbnail, so a single invocation refreshes everything.
# `-u "$(shell id -u):$(shell id -g)"` makes the container process
# match the host uid/gid so the regenerated PDFs/PNGs land in the
# checkout owned by the contributor, not root. Docker Desktop on
# macOS handles uid mapping transparently, but Linux hosts otherwise
# leave root-owned outputs behind.
docker-pdfs:
	$(DOCKER_RUN) -u "$(shell id -u):$(shell id -g)" $(DOCKER_IMAGE) make all

# Regenerate only the two tracked preview PNGs — examples/cv.png
# (README hero) and thumbnail.png (Universe card) — inside the pinned
# image. Both rasterise from template/cv.typ, and raster output is
# environment-sensitive (unlike the fixture PDFs, which match across
# setup-typst and this image), so the pinned image is their single
# canonical source. The `preview-images-in-sync` CI gate regenerates
# via this same target, so the gate environment matches the commit
# environment exactly. A faster path than `docker-pdfs` when only the
# preview images need refreshing. `-B` because both PNGs are tracked:
# on a fresh checkout their mtimes reflect checkout order, not
# history, so make could judge them up to date and the gate would
# compare the committed files against themselves.
docker-preview-images:
	$(DOCKER_RUN) -u "$(shell id -u):$(shell id -g)" $(DOCKER_IMAGE) make -B cv thumbnail

# Drop into a shell in the CI image with the workspace mounted —
# handy for one-off `typst compile` invocations, font listing
# (`typst fonts`), or debugging a rendering issue that only
# reproduces in the container. Stays as root (no `-u`) so the
# contributor can `apk add` ad-hoc tooling for debugging; bash is
# the Dockerfile-installed shell with line editing + history.
docker-shell:
	$(DOCKER_RUN) -it --entrypoint bash $(DOCKER_IMAGE)
