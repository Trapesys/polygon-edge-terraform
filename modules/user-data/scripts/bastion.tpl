#!/bin/bash

## Create private key that we use to login to Polygon-SDK instances
## Not a security issue as this key is used only to login from Bastion to edge nodes without a password
## and the edge nodes are not exposed publicly
cat > /home/ubuntu/.ssh/id_ecdsa << EOF
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAArAAAABNlY2RzYS
1zaGEyLW5pc3RwNTIxAAAACG5pc3RwNTIxAAAAhQQBxOceErElhWT4BzzpA0VBqY4VBxcI
Hgl5BAEvEGXyVCzM0bkNsbfc3xU2pjRAgMFc6g+DH9WZk9gOVJb1CGxOIE8BThIk3JcDm2
9eSxSIPFHp/s2Sh5SnouGQziYi00GnJs6MBSmBhTS5KxpXGgv2qScrCLBOSrT0z87fulyH
cDwtDQ8AAAEYBBYIOQQWCDkAAAATZWNkc2Etc2hhMi1uaXN0cDUyMQAAAAhuaXN0cDUyMQ
AAAIUEAcTnHhKxJYVk+Ac86QNFQamOFQcXCB4JeQQBLxBl8lQszNG5DbG33N8VNqY0QIDB
XOoPgx/VmZPYDlSW9QhsTiBPAU4SJNyXA5tvXksUiDxR6f7NkoeUp6LhkM4mItNBpybOjA
UpgYU0uSsaVxoL9qknKwiwTkq09M/O37pch3A8LQ0PAAAAQgFwFTbeS60RgZNnX86OH5v6
ZZAMLB9PEU6UGEQZMNZJTiOOkerots93P2xIg5laWpkx7E8hOPFux++aTVxvV5MHxgAAAB
h1YnVudHVAaXAtMTAtMjUwLTI1MS0yMzMBAg==
-----END OPENSSH PRIVATE KEY-----
EOF

# wait for the system to fully boot
sleep 30

# get polygon-edge binary from github releases
sudo apt update && sudo apt install -y jq
mkdir /tmp/polygon-edge
wget -q -O /tmp/polygon-edge/polygon-edge.tar.gz $(curl -s https://api.github.com/repos/0xPolygon/polygon-edge/releases/latest | jq .assets[3].browser_download_url  | tr -d '"')
tar -xvf /tmp/polygon-edge/polygon-edge.tar.gz -C /tmp/polygon-edge
sudo mv /tmp/polygon-edge/polygon-edge /usr/local/bin/
rm -R /tmp/polygon-edge

## Polygon Edge controller - it gets info from nodes when they are initialized and generates genesis.json
sudo snap install go --classic --channel=1.17
git clone https://github.com/Trapesys/polygon-edge-assm /tmp/edge-assm
cd /tmp/edge-assm && sudo go build -o artifacts/edge-assm . && sudo mv artifacts/edge-assm /usr/local/bin/ && cd -
edge-assm -chain-name "${chain_name}" -chain-id "${chain_id}" -block-gas-limit "${block_gas_limit}" -premine "${premine}" -epoch-size "${epoch_size}" &