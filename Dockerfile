# syntax=docker/dockerfile:1
FROM node:22-bookworm-slim
ARG CODEX_VERSION
ARG GLAB_VERSION=1.51.0
ARG TARGETARCH=amd64
RUN test -n "$CODEX_VERSION" \
 && apt-get update \
 && apt-get install -y --no-install-recommends git jq curl ca-certificates bash python3 gh \
 && rm -rf /var/lib/apt/lists/* \
 && npm install --global "@openai/codex@${CODEX_VERSION}"
RUN case "$TARGETARCH" in amd64|arm64) GLAB_ARCH="$TARGETARCH" ;; *) exit 1 ;; esac \
 && curl -fsSL "https://gitlab.com/gitlab-org/cli/-/releases/v${GLAB_VERSION}/downloads/glab_${GLAB_VERSION}_linux_${GLAB_ARCH}.tar.gz" -o /tmp/glab.tar.gz \
 && tar -xzf /tmp/glab.tar.gz -C /tmp \
 && install /tmp/bin/glab /usr/local/bin/glab \
 && rm -rf /tmp/glab.tar.gz /tmp/bin
RUN useradd --create-home --shell /bin/bash codex
WORKDIR /opt/codex-flow
# Explicit copies exclude auth, history, vendor clones, local state and env files.
COPY --chown=codex:codex install.sh VERSION README.md LICENSE ./
COPY --chown=codex:codex config ./config
COPY --chown=codex:codex catalog ./catalog
COPY --chown=codex:codex scripts ./scripts
COPY --chown=codex:codex standards ./standards
COPY --chown=codex:codex skills ./skills
COPY --chown=codex:codex command-skills ./command-skills
COPY --chown=codex:codex codex-agents ./codex-agents
COPY --chown=codex:codex agents ./agents
COPY --chown=codex:codex docs ./docs
USER codex
RUN bash install.sh
WORKDIR /workspace
ENTRYPOINT ["codex"]
CMD ["--version"]
