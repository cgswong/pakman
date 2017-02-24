# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = "centos/7"
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false

    # Customize the amount of memory on the VM:
    vb.memory = "2048"
  end

  # Setup synced folder access
  config.vm.synced_folder "ansible/", "/vagrant"

  # Configure provisioning
  config.vm.provision "shell", inline: <<-SHELL
    yum -y  update
    update-ca-trust
    yum -y install epel-release ansible libselinux-python
    ## Kernel update
    rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
    yum -y install http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
    yum -y --enablerepo=elrepo-kernel install kernel-ml
    grub2-set-default 0
  SHELL
  # Run Ansible from the Vagrant VM
##  config.vm.provision "ansible_local" do |ansible|
##    provisioning_path = "/vagrant"
##    ansible.playbook = "playbooks/zookeeper.yml"
  config.vm.provision "ansible" do |ansible|
    ansible.config_file = "ansible/ansible.cfg"
    ansible.playbook = "ansible/playbooks/zookeeper.yml"
  end
##  Pathname.glob('*.json').sort.each do |template|
##    name = template.basename('.json').to_s
##    host = name.gsub(/[.]/, '_')
##    config.vm.define host do |c|
##      c.vm.box = name
##      c.vm.provider :virtualbox do |vbox|
##        vbox.name = name
##      end
##      c.vm.network :private_network, ip: '192.168.0.100'
##    end
##  end
end
