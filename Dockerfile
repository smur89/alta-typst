# Layers the alta-typst toolchain on top of the official Typst image
# (Alpine + a statically-linked typst binary): Lato + FontAwesome 7
# OTFs, plus the fontconfig and make tooling the Makefile relies on.
# The image is the single source of truth for the alta-typst build
# environment — CI consumes it via `container:` and contributors
# regenerate PDF fixtures locally via `make docker-pdfs`, so the
# bytes that land in `examples/tests/` are identical wherever they
# were produced.
#
# Bumping versions:
#   1. Edit FA_VERSION / LATO_VERSION below and the tag in
#      `.github/workflows/image.yml`.
#   2. Edit the image reference (`container:`) in
#      `.github/workflows/build.yml` to the new tag.
#   3. Push to main — `image.yml` rebuilds and pushes the new tag,
#      then `build.yml` picks it up on the next run.
#
# Bumping the Typst version means picking a new upstream image tag
# below; the typst project publishes one per release.
FROM ghcr.io/typst/typst:0.14.2

ARG FA_VERSION=7.0.0
# Lato 2.015 — same upstream release Homebrew's `font-lato` cask
# ships. Pulled from Alpine edge's `font-lato` package; the package
# only exists in edge (not the stable Alpine repos), so we point at
# the edge community repo explicitly and pin the exact apk version
# so a rebuild fetches identical bytes.
ARG LATO_APK_VERSION=2.015-r0

# The upstream Typst image runs as the unprivileged `typst` user (uid
# 1000). Drop to root for package + font installation, then leave the
# image with no fixed user so consumers (CI's `container:` runner,
# `docker run` from a host) can mount their workspace and read/write
# without uid-mapping headaches.
USER root

# `git` is needed by GHA's `container:` jobs for the `git diff
# --exit-code -- examples/tests` step in `build.yml` (run inside the
# container after `make test-pdfs`). `bash` is the shell `actions/*`
# steps invoke; the rest is the install plumbing for Lato and FA.
RUN apk add --no-cache \
      bash \
      ca-certificates \
      curl \
      fontconfig \
      git \
      make \
      unzip

# Lato (OFL). The `font-lato` apk only exists in Alpine's edge
# community repo (not in stable releases), so we add the edge repo
# for this single install and pin the exact package version. The
# package drops the Lato TTFs into the system font path; fc-cache
# runs once after the FA install below picks them up.
RUN apk add --no-cache \
      --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
      font-lato=${LATO_APK_VERSION}

# FontAwesome 7 — desktop OTFs from the upstream GitHub release.
# Matches what `@preview/fontawesome:0.6.1` resolves against.
RUN curl -sSfL -o /tmp/fa.zip \
      "https://github.com/FortAwesome/Font-Awesome/releases/download/${FA_VERSION}/fontawesome-free-${FA_VERSION}-desktop.zip" \
    && unzip -q /tmp/fa.zip -d /tmp/fa \
    && mkdir -p /usr/share/fonts/fontawesome \
    && cp "/tmp/fa/fontawesome-free-${FA_VERSION}-desktop/otfs/"*.otf /usr/share/fonts/fontawesome/ \
    && rm -rf /tmp/fa /tmp/fa.zip

RUN fc-cache -f

# Upstream sets `ENTRYPOINT ["/bin/typst"]`. Clear it so consumers can
# run arbitrary commands (`make test-pdfs`, `sh`, etc.) without an
# `--entrypoint` override; typst is still on PATH for direct calls.
WORKDIR /work
ENTRYPOINT []
CMD ["typst", "--help"]
