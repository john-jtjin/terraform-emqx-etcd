#!/bin/bash

# Install necessary dependencies
apt-get -y update

# system config
sysctl -w fs.file-max=2097152
sysctl -w fs.nr_open=2097152
echo 2097152 | tee /proc/sys/fs/nr_open
sh -c "ulimit -n 1048576"

echo 'fs.file-max = 1048576' | tee -a /etc/sysctl.conf
echo 'DefaultLimitNOFILE=1048576' | tee -a /etc/systemd/system.conf

tee -a /etc/security/limits.conf << EOF
root      soft   nofile      1048576
root      hard   nofile      1048576
EOF

# tcp config
sysctl -w net.core.somaxconn=32768
sysctl -w net.ipv4.tcp_max_syn_backlog=16384
sysctl -w net.core.netdev_max_backlog=16384

sysctl -w net.ipv4.ip_local_port_range='1024 65535'

sysctl -w net.core.rmem_default=262144
sysctl -w net.core.wmem_default=262144
sysctl -w net.core.rmem_max=16777216
sysctl -w net.core.wmem_max=16777216
sysctl -w net.core.optmem_max=16777216

sysctl -w net.ipv4.tcp_rmem='1024 4096 16777216'
sysctl -w net.ipv4.tcp_wmem='1024 4096 16777216'

modprobe ip_conntrack
sysctl -w net.nf_conntrack_max=1000000
sysctl -w net.netfilter.nf_conntrack_max=1000000
sysctl -w net.netfilter.nf_conntrack_tcp_timeout_time_wait=30
sysctl -w net.ipv4.tcp_max_tw_buckets=1048576
sysctl -w net.ipv4.tcp_fin_timeout=15

# install emqx
wget https://www.emqx.com/en/downloads/broker/${EMQX_VERSION}/emqx-${EMQX_VERSION}-ubuntu20.04-amd64.deb
apt install ./emqx-${EMQX_VERSION}-ubuntu20.04-amd64.deb

# add authorization (remove this after bug fix)
cat >> /etc/emqx/emqx.conf <<EOF
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
cat >> /etc/emqx/emqx.conf <<EOF
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

# add auto clustering (etcd)
cat >> /etc/emqx/emqx.conf <<EOF
cluster {
    discovery_strategy = etcd
    etcd {
        server = "${ETCD_URL}"
        prefix = emqcl
        node_ttl = 1m
    }
}
EOF

# modify node name
HOST=$(hostname -I)
echo "node.name = emqx@$HOST" >> /etc/emqx/emqx.conf

# start emqx
systemctl enable --now emqx

while true; do
    if [[ "$(emqx ctl status)" == *"started"* ]]; then
        break
    fi
    echo "waiting for emqx start..."
    sleep 1
done

# change default password
emqx ctl admins passwd admin ${NEW_PASSWORD}