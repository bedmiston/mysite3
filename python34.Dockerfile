from python:3.4

maintainer Reynolds

ENV USER django
ENV GROUP webapps
ENV CODE /webapps/django

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
run groupadd --gid 9999 $GROUP && useradd --gid 9999 --shell /bin/bash --home $CODE $USER

#run apt-get update && apt-get install -y git build-essential python libpq-dev \
#python-dev python-setuptools python-pip nginx supervisor \
#sqlite3
run apt-get update && apt-get install -y nano nginx supervisor \
&& rm -rf /var/lib/apt/lists/* && apt-get autoremove -y && apt-get clean -y

# install our requirements before we add our code because it takes a while. We don't want to have
# to do thi step every time we rebuild our docker image when the code is updated.
add requirements.txt $CODE/requirements.txt
add requirements $CODE/requirements
run python -m pip install -r $CODE/requirements.txt

# install our code
add . $CODE
run chown -R 9999:9999 $CODE
run chmod -R g+w $CODE
run chmod u+x $CODE/install_requirements.sh

# setup all the config files
run echo "daemon off;" >> /etc/nginx/nginx.conf
run rm /etc/nginx/sites-enabled/default
run ln -s $CODE/nginx-app.conf /etc/nginx/sites-enabled/
run ln -s $CODE/supervisor-app.conf /etc/supervisor/conf.d/

WORKDIR $CODE

expose 80
cmd ["supervisord", "-n"]
