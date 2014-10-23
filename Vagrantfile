VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box_url = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vbox.box"
  config.vm.box = "phusiondevserver"

  config.vm.network :private_network, ip: "33.33.33.33"
  #config.vm.network :forwarded_port, guest: 8000, host: 8000
  #config.vm.network :forwarded_port, guest: 5432, host: 5432
  #config.vm.network :forwarded_port, guest: 6379, host: 6379

  config.vm.provider "virtualbox" do |vb|
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.provision "docker" do |d|
    d.pull_images "paintedfox/postgresql"
    d.run "paintedfox/postgresql",
        args: "-e USER=root",
        args: "-e PASS=abcdEF123456"
  end
end
