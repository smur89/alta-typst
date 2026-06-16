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
#   1. Edit FA_VERSION / FA_SHA256 / LATO_APK_VERSION below — and the
#      pinned tag in `Makefile`'s `DOCKER_IMAGE` (the tag in
#      `image.yml` is derived from these ARGs). Once the follow-up
#      PR lands that switches `build.yml` to `container:`, the same
#      tag also needs updating there.
#   2. Push to main — `image.yml` rebuilds and pushes the new tag.
#      Consumers (`make docker-pdfs` locally, the future
#      `container:` step in `build.yml`) pick up the new tag on next
#      run.
#
# Bumping the Typst version means picking a new upstream image tag
# below; the typst project publishes one per release.
#
# Bumping FA_VERSION also requires refreshing FA_SHA256: fetch the
# new desktop zip from the release page, run `sha256sum` on it, and
# paste the digest here.
FROM ghcr.io/typst/typst:0.14.2

ARG FA_VERSION=7.0.0
# SHA256 of `fontawesome-free-${FA_VERSION}-desktop.zip` from the
# upstream GitHub release. Verified at build time so a tampered or
# replaced upstream artifact fails the build loudly instead of
# silently shipping different glyph bytes.
ARG FA_SHA256=4409b8438d3b8382a502e59facc1d4ab5353b788943efaffb566a5682936c3fe
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
# package drops Lato TTFs into `/usr/share/fonts/lato/`; the single
# `fc-cache -f` call inside the FontAwesome RUN below sees both
# `/usr/share/fonts/lato/` and `/usr/share/fonts/fontawesome/`, so
# Lato gets registered by that one cache rebuild — no fc-cache call
# is needed here.
RUN apk add --no-cache \
      --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
      font-lato=${LATO_APK_VERSION}

# FontAwesome 7 — desktop OTFs from the upstream GitHub release.
# Matches what `@preview/fontawesome:0.6.1` resolves against.
# `sha256sum -c` aborts the build if the upstream artifact has been
# tampered with or replaced; the expected digest lives in the
# FA_SHA256 ARG above so bumps refresh it alongside FA_VERSION.
# `fc-cache -f` registers both font directories at once (Lato above,
# FontAwesome here). The trailing `git config --system safe.directory '*'`
# is folded in here rather than its own layer: CI jobs that use
# `container:` mount the workspace owned by the host runner uid (1001)
# but execute as root in the container, and recent git refuses to
# operate on the mismatch ("fatal: detected dubious ownership in
# repository at '/__w/...'"). A repo-wide opt-out is the right scope
# for a single-purpose image.
RUN curl -sSfL -o /tmp/fa.zip \
      "https://github.com/FortAwesome/Font-Awesome/releases/download/${FA_VERSION}/fontawesome-free-${FA_VERSION}-desktop.zip" \
    && echo "${FA_SHA256}  /tmp/fa.zip" | sha256sum -c - \
    && unzip -q /tmp/fa.zip -d /tmp/fa \
    && mkdir -p /usr/share/fonts/fontawesome \
    && cp "/tmp/fa/fontawesome-free-${FA_VERSION}-desktop/otfs/"*.otf /usr/share/fonts/fontawesome/ \
    && rm -rf /tmp/fa /tmp/fa.zip \
    && fc-cache -f \
    && git config --system --add safe.directory '*'

# Upstream sets `ENTRYPOINT ["/bin/typst"]`. Clear it so consumers can
# run arbitrary commands (`make test-pdfs`, `sh`, etc.) without an
# `--entrypoint` override; typst is still on PATH for direct calls.
WORKDIR /work
ENTRYPOINT []
CMD ["typst", "--help"]
