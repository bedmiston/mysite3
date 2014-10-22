# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "redis" do |v|
    v.vm.provider "docker" do |d|
      d.image = "dockerfile/redis"
      d.volumes = ["/var/docker/redis:/data"]
      d.ports = ["6379:6379"]
      d.vagrant_vagrantfile = "./Vagrantfile.proxy"
    end
  end

  config.vm.define "postgres" do |v|
    v.vm.provider "docker" do |d|
      d.image = "paintedfox/postgresql"
      d.volumes = ["/var/docker/postgresql:/data"]
      d.ports = ["5432:5432"]
      d.env = {
        USER: "root",
        PASS: "abcdEF123456",
        DB: "root"
      }
      d.vagrant_vagrantfile = "./Vagrantfile.proxy"
    end
  end

end
