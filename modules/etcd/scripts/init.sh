#!/usr/bin/env bash

curl -L https://github.com/etcd-io/etcd/releases/download/${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-amd64.tar.gz -o etcd-${ETCD_VERSION}-linux-amd64.tar.gz

tar xzvf etcd-${ETCD_VERSION}-linux-amd64.tar.gz
rm etcd-${ETCD_VERSION}-linux-amd64.tar.gz
cd etcd-${ETCD_VERSION}-linux-amd64
sudo cp etcd /usr/local/bin/
sudo cp etcdctl /usr/local/bin/

sudo mkdir /etc/etcd
sudo mkdir -p /var/lib/etcd/

sudo groupadd --system etcd
sudo useradd -s /sbin/nologin --system -g etcd etcd
sudo chown -R etcd:etcd /var/lib/etcd/

sudo sh -c '
cat > /etc/systemd/system/etcd.service <<EOF
[Unit] 
Description=etcd service 
Documentation=https://github.com/etcd-io/etcd 
After=network.target 

[Service] 
User=etcd 
Type=notify 
Environment=ETCD_DATA_DIR=/var/lib/etcd 
Environment=ETCD_NAME=%m 
Environment=ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379
Environment=ETCD_ADVERTISE_CLIENT_URLS=http://0.0.0.0:2379
ExecStart=/usr/local/bin/etcd 
Restart=always 
RestartSec=10s 
LimitNOFILE=40000 

[Install] 
WantedBy=multi-user.target
EOF
'

sudo systemctl daemon-reload
sudo systemctl start etcd.service
