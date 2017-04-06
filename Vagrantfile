# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure("2") do |config|

  MIGRATOR_COUNT = 1
  (1..MIGRATOR_COUNT).each do |migrator_id|
    config.vm.define "migrator-#{migrator_id}" do |migrator|
      migrator.vm.box = "ubuntu/xenial64"
      migrator.vm.network "public_network", bridge: 'en0: Wi-Fi (AirPort)'
      migrator.vm.hostname = "migrator-#{migrator_id}"
      migrator.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.memory = "1024"
        vb.cpus = 1
      end

      migrator.vm.provision "shell", inline: <<-SHELL
        sudo locale-gen en_AU.UTF-8
        sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common make git
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        sudo apt-get update
        sudo apt-get install -y docker-ce
        sudo usermod -a -G docker ubuntu
      SHELL
    end

    CONCOURSE_COUNT = 1
    (1..CONCOURSE_COUNT).each do |concourse_id|
      config.vm.define "concourse-#{concourse_id}" do |concourse|
        concourse.vm.box = "concourse/lite"
        concourse.vm.network "public_network", bridge: 'en0: Wi-Fi (AirPort)'
        concourse.vm.hostname = "concourse-#{concourse_id}"
        concourse.vm.provider "virtualbox" do |vb|
          vb.gui = false
          vb.memory = "1024"
          vb.cpus = 1
        end
      end
    end
  end
end
