FROM ghcr.io/linuxserver/baseimage-rdesktop-web:3.16

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SQLITEB_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

# title
ENV TITLE=SQLiteBrowser

RUN \
  echo "**** install packages ****" && \
  if [ -z ${SQLITEB_VERSION+x} ]; then \
    SQLITEB_VERSION=$(curl -sL "http://dl-cdn.alpinelinux.org/alpine/v3.16/community/x86_64/APKINDEX.tar.gz" | tar -xz -C /tmp \
    && awk '/^P:sqlitebrowser$/,/V:/' /tmp/APKINDEX | sed -n 2p | sed 's/^V://'); \
  fi && \
  apk add --no-cache \
    sqlitebrowser==${SQLITEB_VERSION} && \
  sed -i 's|</applications>|  <application title="DB Browser for SQLite" type="normal">\n    <maximized>yes</maximized>\n  </application>\n</applications>|' /etc/xdg/openbox/rc.xml && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
