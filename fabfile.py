from __future__ import with_statement
from fabric.api import env, local, settings, abort, run, cd
from fabric.contrib.console import confirm


def v():
    # change from the default user to 'vagrant'
    env.user = 'vagrant'
    env.site_user = 'django'
    # connect to the port-forwarded ssh
    env.hosts = ['127.0.0.1:2222']
    # Set the site path
    env.site_path = '/webapps/django/'
    env.vagrant_folder = '/vagrant/'

    # use vagrant ssh key
    result = local('vagrant ssh-config | grep IdentityFile', capture=True)
    env.key_filename = result.split()[1]


def test():
    with cd(env.vagrant_folder):
        run('fig run web /env/bin/python app/manage.py test')


def testapp(app):
    with cd(env.vagrant_folder):
        run('fig run web /env/bin/python app/manage.py test %s' % app)


def commit():
    local('git add -p && git commit')


def push():
    local("git push")


def deploy():
    """Deploy the site."""
    test()
    migrate()
    collectstatic()
    restart()


def uname():
    """Run uname on the server."""
    with cd(env.vagrant_folder):
        run('fig run web uname -a')


def up():
    """Bring up the docker containers using fig"""
    with cd(env.vagrant_folder):
        run("fig up -d")


def stop():
    """Stop the docker containers using fig"""
    with cd(env.vagrant_folder):
        run("fig stop")


def collectstatic():
    """Collect static media."""
    with cd(env.vagrant_folder):
        run('fig run web /env/bin/python app/manage.py collectstatic --noinput')


def syncdb():
    """Sync the database."""
    with cd(env.vagrant_folder):
        run('fig run web /env/bin/python app/manage.py syncdb')


def migrate():
    """Run migrate on the db"""
    with cd(env.vagrant_folder):
        run('fig run web /env/bin/python app/manage.py migrate')


def restart():
    """Restart the web app"""
    with cd(env.vagrant_folder):
        run('fig restart web')


def manage(command):
    """Run the passed manage command"""
    with cd(env.vagrant_folder):
        run("fig run web /env/bin/python app/manage.py %s" % command)


def makemigrations(app):
    """Run makemigrations on the django app"""
    with cd(env.vagrant_folder):
        run("fig run web /env/bin/python app/manage.py makemigrations %s" % app)


def startapp(app):
    """Run manage.py startapp for the passed app"""
    with cd(env.vagrant_folder):
        run("fig run web /env/bin/python app/manage.py startapp app/%s" % app)


def installrequirements():
    """Installs the pip requirements for the appropriate environment"""
    with cd(env.vagrant_folder):
        run("fig run web /webapps/django/install_requirements.sh")


def dshell():
    """Run manage.py shell"""
    with cd(env.vagrant_folder):
        run("fig run web /env/bin/python app/manage.py shell")


def runserver():
    """Run the django development web server"""
    with cd(env.vagrant_folder):
        run("docker exec -d vagrant_web_1 /env/bin/python app/manage.py runserver 0.0.0.0:8000")


def status():
    """Check the docker container status"""
    run("docker ps")


def sshweb():
    """SSH connect to the web server"""
    local("ssh -i id_rsa -l root -p 2223 33.33.33.33")


def build():
    """Build the docker images."""
    with cd(env.vagrant_folder):
        run("fig build")


def figrun(command):
    """Run the passed fig command"""
    with cd(env.vagrant_folder):
        run("fig %s" % command)
