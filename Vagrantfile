# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile for the Mojolicious::Plugin::Restify example.
#
# This is distributed with the example to make it easier for people to spin up
# a fully working development environment to see it in action. If you have any
# issues with it, please let me know.

# Optionally expose the VM's morbo port 3000 as something else on localhost
unless ENV.has_key? "VAGRANT_RESTIFY_MORBO_PORT"
  ENV["VAGRANT_RESTIFY_MORBO_PORT"] = "3333"
end

# Optionally expose the Postgres port on the VM. Defaults to 5437. (This is
# a non-standard Postgres port as developers will most likely already have
# Postgres instance installed and running on their machine using port 5432.)
unless ENV.has_key? "VAGRANT_RESTIFY_POSTGRES_PORT"
  ENV["VAGRANT_RESTIFY_POSTGRES_PORT"] = "5437"
end

Vagrant.configure("2") do |config|
  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  #
  # This is a vanilla Debian 8 "Jessie" build with contrib vboxsf kernel module.
  config.vm.box = "debian/contrib-jessie64"

  # Create forwarded port mappings which allow access to a specific port within
  # the VM from a port on the host machine. In the example below, accessing
  # "localhost:3333" will access port 3000 on the VM.
  if ENV.has_key? "VAGRANT_RESTIFY_MORBO_PORT"
    config.vm.network "forwarded_port", guest: 3000, host: ENV["VAGRANT_RESTIFY_MORBO_PORT"]
  end

  if ENV.has_key? "VAGRANT_RESTIFY_POSTGRES_PORT"
    config.vm.network "forwarded_port", guest: 5432, host: ENV["VAGRANT_RESTIFY_POSTGRES_PORT"]
  end

  # Allow ssh agent forwarding (see https://coderwall.com/p/p3bj2a/cloning-from-github-in-vagrant-using-ssh-agent-forwarding)
  config.ssh.forward_agent = true

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

  # Provisioning with a shell script as a privileged user.
  config.vm.provision "pre", type: "shell", inline: <<-'SHELL'
    apt-get update && apt-get install --no-install-recommends -yq python-git
  SHELL

  # See https://github.com/mitchellh/vagrant/pull/6073
  config.vm.provision :salt do |salt|
    salt.bootstrap_options = "-F -P -c /tmp"  # mitchellh/vagrant/pull/6073
    salt.masterless = true
    salt.minion_config = "saltstack/etc/minion"
    salt.run_highstate = true

    # Logging output control
    salt.colorize = true
    salt.log_level = "info"
    salt.verbose = true
  end

  config.vm.provision "post", type: "shell", inline: <<-'SHELL'
    systemctl restart postgresql
  SHELL

  # I'm leaving this section below for posterity as it's what I used before I
  # gained more experience provisioning using vagrant and saltstack.
  #
  # # Provisioning with a shell script as a privileged user.
  # config.vm.provision "shell", inline: <<-'SHELL'
  #   apt-get update
  #   apt-get install --no-install-recommends -yq build-essential libpq-dev postgresql-9.4 postgresql-client-9.4 postgresql-contrib-9.4 tmux
  #   wget --quiet -O - https://cpanmin.us | perl - App::cpanminus
  #   cpanm Carton
  # SHELL
  #
  # # Provisioning with a shell script as a non-privileged user.
  # #
  # # I've written this so it will provision a fresh install, so running `vagrant
  # # provision` will be destructive to an already provisioned machine. The upside
  # # is it allows you to refresh the build without recreating the guest.
  # config.vm.provision "shell", privileged: false, inline: <<-'SHELL'
  #   sudo su -c 'dropdb scrabblicious --if-exists' postgres
  #   sudo su -c 'psql -tc "DROP USER IF EXISTS vagrant"' postgres
  #   sudo su -c 'psql -tc "CREATE USER vagrant WITH PASSWORD \$\$password\$\$"' postgres
  #   sudo su -c 'psql -tc "CREATE DATABASE scrabblicious OWNER=vagrant"' postgres
  #   sudo su -c 'psql -tc "CREATE EXTENSION IF NOT EXISTS pgcrypto" scrabblicious' postgres
  #   sudo su -c 'PGPASSWORD=password psql -U vagrant -h localhost scrabblicious < /home/vagrant/restify/migrations/scrabblicious.sql' postgres
  #   cp -a ~/restify/scrabblicious.sample.conf ~/restify/scrabblicious.development.conf
  #   cp -a ~/restify/scrabblicious.sample.conf ~/restify/scrabblicious.production.conf
  # SHELL

end
