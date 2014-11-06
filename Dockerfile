
from ubuntu:14.04

maintainer Reynolds

run apt-get update && run apt-get install -y git build-essential \
python libpq-dev python-dev python-setuptools python-pip nginx supervisor \
sqlite3

# install uwsgi now because it takes a little while
run pip install uwsgi

# install our code
add . /home/docker/code/

# setup all the configfiles
run echo "daemon off;" >> /etc/nginx/nginx.conf
run rm /etc/nginx/sites-enabled/default
run ln -s /home/docker/code/nginx-app.conf /etc/nginx/sites-enabled/
run ln -s /home/docker/code/supervisor-app.conf /etc/supervisor/conf.d/

# run pip install
run pip install -r /home/docker/code/app/requirements.txt

# install django, normally you would remove this step because your project would already
# be installed in the code/app/ directory
# run django-admin.py startproject website /home/docker/code/app/

expose 80
cmd ["supervisord", "-n"]