#!/bin/sh
exec /sbin/setuser django /usr/local/bin/uwsgi -H /env --ini /webapps/django/uwsgi.ini:$RACK_ENV >>/var/log/uwsgi.log 2>&1
