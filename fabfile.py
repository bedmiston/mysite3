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
    with cd('/vagrant/'):
        with settings(warn_only=True):
            result = run('fig run web python app/manage.py test')
        if result.failed and not confirm("Tests failed. Continue anyway?"):
            abort("Aborting at user request.")


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


def collectstatic():
    """Collect static media."""
    with cd(env.vagrant_folder):
        run('fig run web python app/manage.py collectstatic --noinput')


def syncdb():
    """Sync the database."""
    with cd(env.vagrant_folder):
        run('fig run web python app/manage.py syncdb')


def migrate():
    """Run migrate on the db"""
    with cd(env.vagrant_folder):
        run('fig run web python app/manage.py migrate')


def restart():
    """Restart the web app"""
    with cd(env.vagrant_folder):
        run('fig restart web')

def manage(command):
    """Run the passed manage command"""
    with cd(env.vagrant_folder):
        run("fig run web python app/manage.py %s" % command)


def makemigrations(app):
    """Run makemigrations on the django app"""
    with cd(env.vagrant_folder):
        run("fig run web python app/manage.py makemigrations %s" % app)


def startapp(app):
    """Run manage.py startapp for the passed app"""
    with cd(env.vagrant_folder):
        run("fig run web python app/manage.py startapp app/%s" % app)


def dshell():
    """Run manage.py shell"""
    with cd(env.vagrant_folder):
        run("fig run web python app/manage.py shell")
