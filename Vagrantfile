VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network :private_network, ip: "33.33.33.33"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.provision "file", source: "bash_aliases.sh", destination: ".bash_aliases"

  config.vm.provision :shell, :path => "install-fig.sh"

  config.vm.provision "docker"
end
