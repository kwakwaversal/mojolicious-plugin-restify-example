# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian/jessie64"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:3333" will access port 3000 on the guest machine.
  config.vm.network "forwarded_port", guest: 3000, host: 3333

  # I develop using Windows and decided to use SMB to save messing around with
  # getting vboxsf on the host system. I should make this conditional based on
  # an environmental variable as others probably won't be Windows users.
  config.vm.synced_folder ".", "/home/vagrant/restify", type: "smb"

  # Don't bother mounting /vagrant
  config.vm.synced_folder '.', '/vagrant', :disabled => true

  # Provisioning with a shell script as a privileged user.
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install --no-install-recommends -y build-essential libpq-dev postgresql-9.4
    wget --quiet -O - https://cpanmin.us | perl - App::cpanminus
    cpanm Carton
  SHELL

  # Provisioning with a shell script as a non-privileged user.
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
  SHELL
end
