#!/usr/bin/env bash
#升级内核
#rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
#rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
#yum --enablerepo=elrepo-kernel install -y kernel-ml
#grub2-set-default 0

# 配合国内yum源
# yum install -y wget
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo
yum makecache

# 修改时区
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 关闭防火墙
systemctl stop firewalld
systemctl disable firewalld

# 关闭selinux
setenforce 0
sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config

# 禁用IPv6
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
echo "net.ipv6.conf.all.disable_ipv6 =1">>/etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 =1">>/etc/sysctl.conf