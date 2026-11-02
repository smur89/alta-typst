# The pinned render environment: official Typst image + Lato +
# FontAwesome 7, so `make docker-pdfs` output is byte-identical to CI.
#
# Bumping a version (FROM tag, FA_VERSION + FA_SHA256, LATO_APK_VERSION):
# also update the Makefile's DOCKER_IMAGE (image.yml derives the tag
# from these lines) and TYPST_VERSION / FA_VERSION in build.yml.
FROM ghcr.io/typst/typst:0.15.1

ARG FA_VERSION=7.0.0
# SHA256 of the upstream desktop zip, so a replaced artifact fails
# the build instead of silently changing glyphs.
ARG FA_SHA256=4409b8438d3b8382a502e59facc1d4ab5353b788943efaffb566a5682936c3fe
# Lato 2.015, the release Homebrew's `font-lato` cask ships, so local
# and CI renders match. Exact apk version so rebuilds fetch identical
# bytes.
ARG LATO_APK_VERSION=2.015-r0

# Upstream runs as `typst`; install as root. No USER is set back, so
# callers choose (`make docker-pdfs` passes `-u`).
USER root

# `bash` is `make docker-shell`'s shell; with `git` it also lets a GHA
# `container:` job run inside the image. The rest installs Lato and FA.
RUN apk add --no-cache \
      bash \
      ca-certificates \
      curl \
      fontconfig \
      git \
      make \
      unzip

# `font-lato` only exists in Alpine's edge community repo. The
# `fc-cache` in the next RUN registers it.
RUN apk add --no-cache \
      --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
      font-lato=${LATO_APK_VERSION}

# FontAwesome 7 desktop OTFs, as `@preview/fontawesome` expects.
# `safe.directory '*'`: a bind-mounted workspace owned by another uid
# (e.g. a GHA `container:` job running as root) otherwise trips git's
# "dubious ownership" check.
RUN curl -sSfL -o /tmp/fa.zip \
      "https://github.com/FortAwesome/Font-Awesome/releases/download/${FA_VERSION}/fontawesome-free-${FA_VERSION}-desktop.zip" \
    && echo "${FA_SHA256}  /tmp/fa.zip" | sha256sum -c - \
    && unzip -q /tmp/fa.zip -d /tmp/fa \
    && mkdir -p /usr/share/fonts/fontawesome \
    && cp "/tmp/fa/fontawesome-free-${FA_VERSION}-desktop/otfs/"*.otf /usr/share/fonts/fontawesome/ \
    && rm -rf /tmp/fa /tmp/fa.zip \
    && fc-cache -f \
    && git config --system --add safe.directory '*'

# Upstream's entrypoint is typst; clear it so `docker run <img> make …` works.
WORKDIR /work
ENTRYPOINT []
CMD ["typst", "--help"]
