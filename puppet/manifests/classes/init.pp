class init {

    group { "puppet":
        ensure => "present",
    }

    exec { "upgrade-yum":
        command => 'sudo yum -y update',
        timeout => 1800,
    }

    group { "webapps":
        ensure => present,
        system => true,
    }

    user { "django":
        ensure => present,
        system => true,
        home => "/webapps/django",
        shell => "/bin/bash",
        groups => webapps,
        require => Group["webapps"],
    }

    file { "/webapps":
        ensure => directory,
        owner => mysite,
        group => webapps,
        mode => 644,
        require => User["django"],
    }

    class { 'python':
        version    => 'system',
        pip        => true,
        dev        => true,
        virtualenv => true,
        gunicorn   => false,
    }

    python::virtualenv { '/webapps/django':
        ensure       => present,
        version      => 'system',
        requirements => '/webapps/django/requirements.txt',
        systempkgs   => true,
        venv_dir     => '/webapps/django',
        owner        => 'django',
        group        => 'webapps',
        cwd          => '/webapps/django',
        timeout      => 0,
    }

    class { 'postgresql::server':
    } ->
    postgresql::server::role {'django':
        password_hash => postgresql_password('django', '1234abcd'),
        createdb => true,
    } ->
    postgresql::server::database { 'django':
    }->
    postgresql::server::database_grant { 'django':
        privilege => 'ALL',
        db => 'django',
        role => 'django',
    }
}
