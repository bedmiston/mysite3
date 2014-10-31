 #!/usr/bin/env bash

apt-get update
apt-get install -y git build-essential python libpq-dev python-dev python-setuptools python-pip
pip install virtualenv
virtualenv /vagrant
source /vagrant/bin/activate
pip install -r /vagrant/app/requirements.txt
