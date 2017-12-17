``` bash
sudo mkdir -p /root/local/bin
sudo cp /vagrant/environment.sh /root/local/bin

wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
chmod +x cfssl_linux-amd64
sudo mv cfssl_linux-amd64 /root/local/bin/cfssl

wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod +x cfssljson_linux-amd64
sudo mv cfssljson_linux-amd64 /root/local/bin/cfssljson

wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64
chmod +x cfssl-certinfo_linux-amd64
sudo mv cfssl-certinfo_linux-amd64 /root/local/bin/cfssl-certinfo

export PATH=/root/local/bin:$PATH
mkdir ssl
cd ssl
cfssl print-defaults config > config.json
cfssl print-defaults csr > csr.json
```

``` bash
cat > ca-config.json << EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ],
        "expiry": "8760h"
      }
    }
  }
}
EOF
```

``` bash
cat > ca-csr.json << EOF
{
  "CN": "kubernetes",
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
```

``` bash
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
sudo mkdir -p /etc/kubernetes/ssl
sudo cp ca* /etc/kubernetes/ssl
```


etcd每个机器的证书都不一样


for ip in 192.168.100.101 192.168.100.102 192.168.100.103; do
  ETCDCTL_API=3 /usr/local/bin/etcdctl \
  endpoint health; done


sudo systemctl daemon-reload
sudo systemctl restart etcd

sudo systemctl stop etcd


sudo /usr/local/bin/etcd \
--name=etcd_node-2 \
--cert-file=/etc/etcd/ssl/etcd.pem \
--key-file=/etc/etcd/ssl/etcd-key.pem \
--peer-cert-file=/etc/etcd/ssl/etcd.pem \
--peer-key-file=/etc/etcd/ssl/etcd-key.pem \
--trusted-ca-file=/etc/kubernetes/ssl/ca.pem \
--peer-trusted-ca-file=/etc/kubernetes/ssl/ca.pem \
--initial-advertise-peer-urls=https://192.168.100.102:2380 \
--listen-peer-urls=https://192.168.100.102:2380 \
--listen-client-urls=https://192.168.100.102:2379,http://127.0.0.1:2379 \
--advertise-client-urls=https://192.168.100.102:2379 \
--initial-cluster-token=etcd-cluster-1 \
--initial-cluster=etcd_node-1=https://192.168.100.101:2380,etcd_node-2=https://192.168.100.102:2380,etcd_node-3=https://192.168.100.103:2380 \
--initial-cluster-state=new \
--data-dir=/var/lib/etcd
