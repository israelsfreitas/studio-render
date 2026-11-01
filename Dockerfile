# The Studio's render machine for RunPod (D361): RunPod's Ubuntu 24.04 base (SSH from PUBLIC_KEY) with every tool a
# render needs already installed, so a new machine starts ready instead of installing them on each render.
# Only public tools: no project code, no keys. Built by GitHub Actions into ghcr.io (public).
FROM runpod/base:1.5.0-ubuntu2404

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq \
 && apt-get install -y -qq curl ca-certificates xz-utils ffmpeg fonts-dejavu-core fonts-liberation fonts-noto-color-emoji \
 && curl -fsSL -o /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
 && apt-get install -y -qq /tmp/chrome.deb \
 && rm -f /tmp/chrome.deb \
 && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://nodejs.org/dist/v22.12.0/node-v22.12.0-linux-x64.tar.xz | tar -xJ -C /usr/local --strip-components=1
RUN curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR=/usr/local/bin UV_NO_MODIFY_PATH=1 sh \
 && uv python install 3.12
# the Studio skips its own setup when it finds this mark (api/src/videoapp/cloud/remote.py)
RUN touch /opt/studio-ready
