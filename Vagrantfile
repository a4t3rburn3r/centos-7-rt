# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "centos-7-rt" do |vm1|
    vm1.vm.box = "a4t3rburn3r/centos-7-rt"
    vm1.vm.define "centos-7-rt"
    vm1.vm.hostname = "centos-7-rt"
# Sample network and shared folder part
#    vm1.vm.network "private_network", ip: "10.0.51.103"
#    vm1.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
#    vm1.vm.synced_folder "./html", "/var/www/html"

    vm1.vm.provider "virtualbox" do |vb|
      vb.name = "centos-7-rt"
      vb.gui = false
      vb.memory = "1024"
    end

    vm1.vm.provision "shell", inline: <<-SHELL
      yum update -y
# Sample web-server install part
#      yum install httpd -y
#      systemctl enable httpd
#      systemctl start httpd
    SHELL

    vm1.vm.provision "shell", run: "always", inline: <<-SHELL
      echo "-= Vagrant provisioned centos server with real time kernel =-"
    SHELL
  end
end
