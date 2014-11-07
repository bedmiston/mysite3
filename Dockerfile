from python:3.4

maintainer Reynolds

ENV USER django
ENV GROUP webapps
ENV CODE /webapps/django

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
run groupadd --system $GROUP && useradd --system --gid $GROUP --shell /bin/bash --home $CODE $USER

#run apt-get update && apt-get install -y git build-essential python libpq-dev \
#python-dev python-setuptools python-pip nginx supervisor \
#sqlite3
run apt-get update && apt-get install -y nano nginx supervisor \
&& rm -rf /var/lib/apt/lists/* && apt-get autoremove -y && apt-get clean -y

# install uwsgi now because it takes a little while
run pip install uwsgi

# install our code
add . $CODE
run chown -R $USER:$GROUP $CODE
run chmod -R g+w $CODE

# setup all the configfiles
run echo "daemon off;" >> /etc/nginx/nginx.conf
run rm /etc/nginx/sites-enabled/default
run ln -s $CODE/nginx-app.conf /etc/nginx/sites-enabled/
run ln -s $CODE/supervisor-app.conf /etc/supervisor/conf.d/

# run pip install
run pip install -r $CODE/app/requirements.txt

WORKDIR $CODE

expose 80
cmd ["supervisord", "-n"]
