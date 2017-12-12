# etcd 安装
## 设置环境变量
``` bash
export NODE_NAME=etcd-host0 # 当前部署的机器名称(随便定义，只要能区分不同机器即可)
export NODE_IP=192.168.1.13 # 当前部署的机器 IP
export NODE_IPS="192.168.1.13 192.168.1.14 192.168.1.15" # etcd 集群所有机器 IP
# etcd 集群间通信的IP和端口
export ETCD_NODES=etcd-host0=https://192.168.1.13:2380,etcd-host1=https://192.168.1.14:2380,etcd-host2=https://192.168.1.15:2380
# 导入用到的其它全局变量：ETCD_ENDPOINTS、FLANNEL_ETCD_PREFIX、CLUSTER_CIDR
source /root/local/bin/environment.sh

mkdir etcd ~/etcd
cd ~/etcd
wget https://github.com/coreos/etcd/releases/download/v3.2.11/etcd-v3.2.11-linux-amd64.tar.gz
tar -xvf etcd-v3.2.11-linux-amd64.tar.gz
sudo mv etcd-v3.2.11-linux-amd64/etcd* /root/local/bin

cat > etcd-csr.json <<EOF
{
  "CN": "etcd",
  "hosts": [
    "127.0.0.1",
    "${NODE_IP}"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "BeiJing",
      "L": "BeiJing",
      "O": "k8s",
      "OU": "System"
    }
  ]
}
EOF

cfssl gencert -ca=/etc/kubernetes/ssl/ca.pem \
  -ca-key=/etc/kubernetes/ssl/ca-key.pem \
  -config=/etc/kubernetes/ssl/ca-config.json \
  -profile=kubernetes etcd-csr.json | cfssljson -bare etcd

sudo mkdir -p /etc/etcd/ssl
sudo mv etcd*.pem /etc/etcd/ssl
rm -rf etcd.csr  etcd-csr.json

sudo mkdir -p /var/lib/etcd

cat > etcd.service <<EOF
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target
Documentation=https://github.com/coreos

[Service]
Type=notify
WorkingDirectory=/var/lib/etcd/
ExecStart=/root/local/bin/etcd \\
  --name=${NODE_NAME} \\
  --cert-file=/etc/etcd/ssl/etcd.pem \\
  --key-file=/etc/etcd/ssl/etcd-key.pem \\
  --peer-cert-file=/etc/etcd/ssl/etcd.pem \\
  --peer-key-file=/etc/etcd/ssl/etcd-key.pem \\
  --trusted-ca-file=/etc/kubernetes/ssl/ca.pem \\
  --peer-trusted-ca-file=/etc/kubernetes/ssl/ca.pem \\
  --initial-advertise-peer-urls=https://${NODE_IP}:2380 \\
  --listen-peer-urls=https://${NODE_IP}:2380 \\
  --listen-client-urls=https://${NODE_IP}:2379,http://127.0.0.1:2379 \\
  --advertise-client-urls=https://${NODE_IP}:2379 \\
  --initial-cluster-token=etcd-cluster-0 \\
  --initial-cluster=${ETCD_NODES} \\
  --initial-cluster-state=new \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

sudo mv etcd.service /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd
systemctl status etcd
```