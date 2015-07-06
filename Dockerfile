# docker-xbmc-server
#
# Setup: Clone repo then checkout appropriate version
#   For stable (Helix)
#     $ git checkout master
#   For experimental (master development)
#     $ git checkout experimental
#
# Create your own Build:
# 	$ docker build --rm=true -t $(whoami)/docker-xbmc-server .
#
# Run your build:
# There are two choices   
#   - UPnP server and webserver in the background: (replace ip and xbmc data location)
#	  $ docker run -d --net=host --privileged -v /directory/with/xbmcdata:/opt/xbmc-server/portable_data $(whoami)/docker-xbmc-server
#
#   - Run only the libraryscan and quit: 
#	  $ docker run -v /directory/with/xbmcdata:/opt/xbmc-server/portable_data --entrypoint=/opt/xbmc-server/xbmcVideoLibraryScan $(whoami)/docker-xbmc-server --no-test --nolirc -p
#
# See README.md.
# Source: https://github.com/wernerb/docker-xbmc-server

from ubuntu:14.04
maintainer Werner Buck "email@wernerbuck.nl"

# Set locale to UTF8
RUN locale-gen --no-purge en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
RUN dpkg-reconfigure locales
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Set Terminal to non interactive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install java, git wget and supervisor
RUN apt-get update && \
	apt-get -y install git xmlstarlet

# Download XBMC, pick version from github
RUN git clone --depth 1 --branch "14.0-Helix" https://github.com/xbmc/xbmc.git 

# Add patches and xbmc-server files
ADD src/fixcrash.diff xbmc/fixcrash.diff
ADD src/5071.patch xbmc/5071.patch
ADD src/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Apply patches:
#	fixrash.diff : Fixes crashing in UPnP 
RUN cd xbmc && \
 git apply fixcrash.diff && \
 git apply 5071.patch

RUN mkdir -p /opt/kodi-server/share/kodi/portable_data/

ENV MYSQL_IP **ChangeMe**
ENV MYSQL_PORT 3306
ENV MYSQL_USER xbmc
ENV MYSQL_PASS xbmc

ADD xbmcdata/userdata/advancedsettings.xml /opt/kodi-server/share/kodi/portable_data/advancedsettings.xml

RUN xmlstarlet ed -L -u "//advancedsettings/videodatabase/host" -v "{$MYSQL_IP}" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
RUN xmlstarlet ed -L -u "//advancedsettings/videodatabase/port" -v "{$MYSQL_PORT}" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
RUN xmlstarlet ed -L -u "//advancedsettings/videodatabase/user" -v "{$MYSQL_USER}" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
RUN xmlstarlet ed -L -u "//advancedsettings/videodatabase/pass" -v "{$MYSQL_PASS}" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml

RUN xmlstarlet ed -L -u "//advancedsettings/musicdatabase/host" -v "{$MYSQL_IP}" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
RUN xmlstarlet ed -L -u "//advancedsettings/musicdatabase/port" -v "{$MYSQL_PORT}" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
RUN xmlstarlet ed -L -u "//advancedsettings/musicdatabase/user" -v "{$MYSQL_USER}" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
RUN xmlstarlet ed -L -u "//advancedsettings/musicdatabase/pass" -v "{$MYSQL_PASS}" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml

#Eventserver and webserver respectively.
EXPOSE 9777/udp 8089/tcp
