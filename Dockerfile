# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.15

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
ENV USER django
ENV GROUP webapps
ENV CODE /webapps/django

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
run groupadd --gid 9999 $GROUP && useradd --gid 9999 --shell /bin/bash --home $CODE $USER

# add the pacakges that we need
run apt-get update \
&& apt-get install --no-install-recommends -y nano \
                                              nginx \
                                              curl \
                                              wget \
                                              libpq-dev \
                                              gcc \
                                              python3-dev \
                                              python3-pip \
&& rm -rf /var/lib/apt/lists/* && apt-get autoremove -y && apt-get clean -y

# install uwsgi
run pip3 install uwsgi==2.0.8

# install our requirements before we add our code because it takes a while. We don't want to have
# to do thi step every time we rebuild our docker image when the code is updated.
WORKDIR $CODE
add install-pip3.sh $CODE/install-pip3.sh
run chmod +x $CODE/install-pip3.sh
run $CODE/install-pip3.sh
# run cd /env && curl https://bootstrap.pypa.io/get-pip.py | /env/bin/python
add requirements.txt $CODE/requirements.txt
add requirements $CODE/requirements
run /env/bin/pip install -r $CODE/requirements.txt

# add our ssh key
add id_rsa.pub /tmp/id_rsa.pub
run cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys && rm -f /tmp/id_rsa.pub

# install our code
add . $CODE
run chown -R 9999:9999 $CODE
run chmod -R g+w $CODE
run chmod u+x $CODE/install_requirements.sh

# setup all the config files
run echo "daemon off;" >> /etc/nginx/nginx.conf
run rm /etc/nginx/sites-enabled/default
run ln -s $CODE/nginx-app.conf /etc/nginx/sites-enabled/

# setup out services
RUN mkdir /etc/service/nginx
ADD nginx.sh /etc/service/nginx/run
run chmod +x /etc/service/nginx/run
RUN mkdir /etc/service/uwsgi
ADD uwsgi.sh /etc/service/uwsgi/run
run chmod +x /etc/service/uwsgi/run

expose 80
