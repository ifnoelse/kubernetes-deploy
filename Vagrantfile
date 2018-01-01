# -*- mode: ruby -*-
# vi: set ft=ruby :

vms = {"192.168.100.101" => "node-1",
       "192.168.100.102" => "node-2",
       "192.168.100.103" => "node-3"}

Vagrant.configure("2") do |config|

  vms.each do |vm_ip, vm_name|

    config.vm.define vm_name do |node|

      node.vm.box_check_update = false
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
        chmod 755 /vagrant/.setting/*.sh

        # 设置基本配置
        /vagrant/.setting/config.sh

        # 安装基本组件
        /vagrant/.setting/install.sh

        # 添加用户ifneolse
        /vagrant/.setting/add_user.sh ifnoelse ifnoelse

        # 设置用户ssh key登陆
        /vagrant/.setting/ssh_auth.sh ifnoelse

        # 修改hostname       echo "#{vm_name}">/etc/hostname

        # 添加本地hosts解析
        for i in "#{vms.map{|k,v|"#{k}    #{v}"}.join('" "')}";do echo $i>>/etc/hosts;done

        sed -i '1d' /etc/hosts

        if [ "node-1" == "#{vm_name}" ];then wget -q -O - https://bootstrap.pypa.io/get-pip.py|python;pip install ansible;fi

        # rpm -ivh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
      SHELL
      # node.ssh.private_key_path = ".setting/private_key"
      # node.ssh.username = "ifnoelse"
    end
  end
end