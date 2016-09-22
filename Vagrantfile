# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile for the Mojolicious::Plugin::Restify example.
#
# This is distributed with the example to make it easier for people to spin up
# a fully working development environment to see it in action. If you have any
# issues with it, please let me know.

# Optionally expose the Postgres port on the host. Defaults to 5432.
ENV["VAGRANT_POSTGRES_PORT"] = "5432"

Vagrant.configure("2") do |config|
  # This is a vanilla Debian 8 "Jessie" build with contrib vboxsf kernel module.
  config.vm.box = "debian/contrib-jessie64"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:3333" will access port 3000 on the guest machine.
  config.vm.network "forwarded_port", guest: 3000, host: 3333

  # Conditionally expose the Postgresql port. N.B., this should probably be
  # removed as it's highly likely that someone will be hosting a local postgres
  # instance locally.
  if ENV.has_key? "VAGRANT_POSTGRES_PORT"
    config.vm.network "forwarded_port", guest: 5432, host: ENV["VAGRANT_POSTGRES_PORT"]
  end

  # I develop using Windows and unsuccessfully tried using both SMB and rsync.
  #
  # SMB worked fine but Mojolicious' morbo didn't pick up file changes
  # recursively. This meant folders had to be specifically watched, which was
  # not very not practical.
  #
  # I then tried rsync with 'vagrant auto-rsync' which worked fine, but it was
  # only one way (host to guest) and required me to have an extra windows CMD
  # window open which was cumbersome for dev work.
  #
  # I have settled using the default sync method which is virtualbox. This is
  # fine for development work, but just means that any guests that you use have
  # virtualbox additions, namely vboxsf file type.
  config.vm.synced_folder ".", "/home/vagrant/restify"

  # Don't bother mounting /vagrant folder as it's being synched above anyway.
  config.vm.synced_folder '.', "/vagrant", :disabled => true

  # Provisioning with a shell script as a privileged user.
  config.vm.provision "shell", inline: <<-'SHELL'
    apt-get update
    apt-get install --no-install-recommends -yq build-essential libpq-dev postgresql-9.4 postgresql-client-9.4 tmux
    wget --quiet -O - https://cpanmin.us | perl - App::cpanminus
    cpanm Carton
  SHELL

  # Provisioning with a shell script as a non-privileged user.
  config.vm.provision "shell", privileged: false, inline: <<-'SHELL'
    sudo su -c 'dropdb scrabblicious --if-exists' postgres
    sudo su -c 'psql -tc "DROP USER IF EXISTS vagrant"' postgres
    sudo su -c 'psql -tc "CREATE USER vagrant WITH PASSWORD \$\$password\$\$"' postgres
    sudo su -c 'psql -tc "CREATE DATABASE scrabblicious OWNER=vagrant"' postgres
    sudo su -c 'psql scrabblicious < /home/vagrant/restify/migrations/scrabblicious.sql' vagrant
    cp -a ~/restify/scrabblicious.sample.conf ~/restify/scrabblicious.development.conf
    cp -a ~/restify/scrabblicious.sample.conf ~/restify/scrabblicious.production.conf
  SHELL
end
