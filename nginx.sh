#!/bin/sh
exec /usr/sbin/nginx >>/var/log/uwsgi.log 2>&1
