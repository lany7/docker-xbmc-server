#!/bin/bash

xmlstarlet ed -L -u "//advancedsettings/videodatabase/host" -v "{$MYSQL_IP}" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
xmlstarlet ed -L -u "//advancedsettings/videodatabase/port" -v "{$MYSQL_PORT}" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
xmlstarlet ed -L -u "//advancedsettings/videodatabase/user" -v "{$MYSQL_USER}" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
xmlstarlet ed -L -u "//advancedsettings/videodatabase/pass" -v "{$MYSQL_PASS}" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml

xmlstarlet ed -L -u "//advancedsettings/musicdatabase/host" -v "{$MYSQL_IP}" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
xmlstarlet ed -L -u "//advancedsettings/musicdatabase/port" -v "{$MYSQL_PORT}" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
xmlstarlet ed -L -u "//advancedsettings/musicdatabase/user" -v "{$MYSQL_USER}" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
xmlstarlet ed -L -u "//advancedsettings/musicdatabase/pass" -v "{$MYSQL_PASS}" /opt/kodi-server/share/kodi/portable_data/userdata/advancedsettings.xml
