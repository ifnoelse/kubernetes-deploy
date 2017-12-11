# -*- mode: ruby -*-
# vi: set ft=ruby :

vm_num = 3
vm_name_prefix = "node-"
vm_ip_prefix = "192.168.100.10"

Vagrant.configure("2") do |config|

  (1..vm_num).each do |i|

    vm_name = "#{vm_name_prefix}#{i}"
    vm_ip = "#{vm_ip_prefix}#{i}"

    config.vm.define vm_name do |node|

      node.vm.box = "bento/centos-7.4"
      node.vm.hostname = vm_name
      node.vm.network "private_network", ip: vm_ip
      # config.vm.synced_folder "../data", "/vagrant_data"

      node.vm.provider "virtualbox" do |v|
        # v.name = vm_name
        v.memory = 2048
        v.cpus = 1
      end

      node.vm.provision "shell", inline: <<-SHELL
        # 设置基本配置
        /vagrant/.setting/config.sh

        # 安装基本组件
        /vagrant/.setting/install.sh

        # 添加用户ifneolse
        /vagrant/.setting/add_user.sh ifnoelse ifnoelse

        # 设置用户ssh key登陆
        /vagrant/.setting/ssh_auth.sh ifnoelse

        # 修改hostname
        echo "#{vm_name}">/etc/hostname

        # 添加本地hosts解析
        for i in {1..#{vm_num}};do echo "#{vm_ip_prefix}${i}	#{vm_name_prefix}${i}">>/etc/hosts;done
      SHELL
      # node.ssh.private_key_path = ".setting/private_key"
      # node.ssh.username = "ifnoelse"
    end
  end
end