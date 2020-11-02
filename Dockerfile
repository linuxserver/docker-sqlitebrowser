FROM ghcr.io/linuxserver/baseimage-rdesktop-web:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SQLITEB_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

RUN \
 echo "***** add ppa ****" && \
 apt-get update && \
 apt-get install -y \
	gnupg && \
 apt-key adv --keyserver hkp://keyserver.ubuntu.com:11371 --recv-keys 941353830DA80B6A06276736B0C3F48A7F2583EA && \
 echo "deb http://ppa.launchpad.net/linuxgndu/sqlitebrowser/ubuntu bionic main" >> /etc/apt/sources.list.d/sqlitebrowser.list && \
 echo "deb-src http://ppa.launchpad.net/linuxgndu/sqlitebrowser/ubuntu bionic main" >> /etc/apt/sources.list.d/sqlitebrowser.list && \
 if [ -z ${SQLITEB_VERSION+x} ]; then \
	SQLITEB_VERSION=$(curl -sX GET http://ppa.launchpad.net/linuxgndu/sqlitebrowser/ubuntu/dists/bionic/main/binary-amd64/Packages.gz | gunzip -c \
	|grep -A 7 -m 1 "Package: sqlitebrowser" | awk -F ": " '/Version/{print $2;exit}');\
 fi && \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y \
	sqlitebrowser=${SQLITEB_VERSION} && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000
VOLUME /config
