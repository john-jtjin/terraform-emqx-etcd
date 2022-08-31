#!/usr/bin/env bash

HOME="/home/ubuntu"

# Install necessary dependencies
sudo apt-get -y update

# system config
sudo sysctl -w fs.file-max=2097152
sudo sysctl -w fs.nr_open=2097152
echo 2097152 | sudo tee /proc/sys/fs/nr_open
sudo sh -c "ulimit -n 1048576"

echo 'fs.file-max = 1048576' | sudo tee -a /etc/sysctl.conf
echo 'DefaultLimitNOFILE=1048576' | sudo tee -a /etc/systemd/system.conf

sudo tee -a /etc/security/limits.conf << EOF
root      soft   nofile      1048576
root      hard   nofile      1048576
ubuntu    soft   nofile      1048576
ubuntu    hard   nofile      1048576
EOF

# tcp config
sudo sysctl -w net.core.somaxconn=32768
sudo sysctl -w net.ipv4.tcp_max_syn_backlog=16384
sudo sysctl -w net.core.netdev_max_backlog=16384

sudo sysctl -w net.ipv4.ip_local_port_range='1024 65535'

sudo sysctl -w net.core.rmem_default=262144
sudo sysctl -w net.core.wmem_default=262144
sudo sysctl -w net.core.rmem_max=16777216
sudo sysctl -w net.core.wmem_max=16777216
sudo sysctl -w net.core.optmem_max=16777216

sudo sysctl -w net.ipv4.tcp_rmem='1024 4096 16777216'
sudo sysctl -w net.ipv4.tcp_wmem='1024 4096 16777216'

sudo modprobe ip_conntrack
sudo sysctl -w net.nf_conntrack_max=1000000
sudo sysctl -w net.netfilter.nf_conntrack_max=1000000
sudo sysctl -w net.netfilter.nf_conntrack_tcp_timeout_time_wait=30
sudo sysctl -w net.ipv4.tcp_max_tw_buckets=1048576
sudo sysctl -w net.ipv4.tcp_fin_timeout=15

# install emqx
wget https://www.emqx.com/en/downloads/broker/${EMQX_VERSION}/emqx-${EMQX_VERSION}-ubuntu20.04-amd64.tar.gz
mkdir -p emqx && tar -zxvf emqx-${EMQX_VERSION}-ubuntu20.04-amd64.tar.gz -C emqx

# remove default acl.conf
rm $HOME/emqx/etc/acl.conf

# add authorization (remove this after bug fix)
cat >> $HOME/emqx/etc/emqx.conf <<EOF

authorization {
    cache {
        enable = false
    }
    deny_action = ignore
    no_match = deny
    sources = [
        {
            type = http
            enable = true

            method = post
            url = "${AUTH_URL}"
            ssl {
                enable = true
            }
            body {
            }
            headers { 
            }
        }
    ]
}
EOF

# add exhook
cat >> $HOME/emqx/etc/emqx.conf <<EOF

exhook {
    servers = [
        {
            auto_reconnect = "10s"
            enable = true
            failed_action = "deny"
            name = "indochat"
            pool_size = 16
            request_timeout = "5s"
            url = "${EXHOOK_URL}"
            ssl {
                enable = true
            }
        }
    ]
}

EOF

# modify node name
echo "node.name = emqx@${LOCAL_IP}" >> $HOME/emqx/etc/emqx.conf 

# start emqx
$HOME/emqx/bin/emqx start

# change default password
$HOME/emqx/bin/emqx ctl admins passwd admin ${NEW_PASSWORD}