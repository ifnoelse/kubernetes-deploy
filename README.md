# Kubernetes 部署

## 介绍

本项目通过Ansible自动化脚本完成kubernetes集群的一键部署，降低安装成本，提高生产效率

##  快速体验

### 集群环境

**软件版本**

| 软件名称        | 版本           |
| ------------- |:-------------:|
| centos      | 7.4.1708 |
| docker      | 17.09.1   |
| kubernetes      | 1.8.6 |
| flannel      | 0.9.1    |
| etcd      | 3.2.11    |

**机器节点**

| 服务器名      | ip           | 安装的组件           |
| ------------- | ------------- |-------------|
| node-1      | 192.168.100.101 |kubernetes_master，kubernetes_client，flannel，etcd|
| node-2      | 192.168.100.102 |kubernetes_node，flannel，etcd，docker|
| node-3      | 192.168.100.103 |kubernetes_node，flannel，etcd，docker|

> 以上节点通过vagrant准备即可，Vagrantfile在项目根目录下

### 一键部署

**1 下载部署代码**

``` bash
git clone https://github.com/ifnoelse/kubernetes-deploy.git
```
>由于ide或者git工具有可能会自动转换换行符为用户PC平台的默认换行符，所以一定要确认git上拿下来的文件换行符为LF，也就是linux/unix下的标准换行符，以避免相关脚本在linux机器上无法执行

**2 启动虚拟机**

``` bash
cd kubernetes-deploy
vagrant up
```

**3 复制res文件夹到kubernetes-deploy目录**

res文件夹内的内容如下：
- cfssl-certinfo_linux-amd64
- cfssljson_linux-amd64
- cfssl_linux-amd64
- docker-17.09.1-ce.tgz
- etcd-v3.2.11-linux-amd64.tar.gz
- flannel-v0.9.1-linux-amd64.tar.gz
- kubernetes-server-linux-amd64.tar.gz

> 1、res 文件夹下载地址: 链接：https://pan.baidu.com/s/1eRWTWbC 密码：8f3b <br />
> 2、res 中的文件可以自行到官网下载

**4 一键安装kubernetes集群**

登录虚拟机（用户名：ifnoelse，密码：ifnoelse）执行以下命令
``` bash
cd /vagrant/ansible
ansible-playbook -i hosts.yaml install.yaml
```

> 虚拟机启动之后已经装好了ansible

**5 验证安装结果**
``` bash
[ifnoelse@node-1 ~]$ kubectl get nodes
NAME              STATUS    ROLES     AGE       VERSION
192.168.100.102   Ready     <none>    5m        v1.8.6
192.168.100.103   Ready     <none>    5m        v1.8.6

```

**6 一键卸载kubernetes集群**

登录虚拟机（用户名：ifnoelse，密码：ifnoelse）执行以下命令
``` bash
cd /vagrant/ansible
ansible-playbook -i hosts.yaml uninstall.yaml
```