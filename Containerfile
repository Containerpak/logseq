FROM ubuntu:26.04 AS source

ADD --checksum=sha256:49de367078b37670febdb987e562b75dee1e1ae96c28bfb8738779c42297dd0c https://github.com/logseq/logseq/releases/download/2.0.1/Logseq-linux-x86_64-2.0.1.AppImage /tmp/app.AppImage

RUN chmod 0755 /tmp/app.AppImage && \
    cd /tmp && \
    ./app.AppImage --appimage-extract >/dev/null && \
    mkdir -p /stage && \
    cp -a /tmp/squashfs-root/. /stage/

FROM ghcr.io/containerpak/gtk3:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/logseq"

RUN apt-get update && \
    apt-get install -y --no-install-recommends libnspr4 libnss3 libsecret-1-0 && \
    cpak-clean-junk

COPY --from=source /stage/ /opt/logseq/
COPY logseq /usr/bin/logseq
COPY logseq.desktop /usr/share/applications/logseq.desktop
COPY icon.png /usr/share/icons/hicolor/128x128/apps/logseq.png

RUN chmod 0755 /usr/bin/logseq && cpak-clean-junk
