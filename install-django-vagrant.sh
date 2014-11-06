 #!/usr/bin/env bash

apt-get update
apt-get install -y git build-essential python libpq-dev python-dev python-setuptools python-pip
pip install virtualenv
mkdir /reynolds
virtualenv /reynolds
cd /reynolds
source /reynolds/bin/activate
pip install -U fig
