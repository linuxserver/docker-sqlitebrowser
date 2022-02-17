FROM ghcr.io/linuxserver/baseimage-rdesktop-web:alpine

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
  apk add --no-cache \
    sqlitebrowser && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000
VOLUME /config
