#!/bin/bash -x

set -ex

IRONIC_PXE_INTERFACE_NAME=${IRONIC_PXE_INTERFACE_NAME:-"ens7"}
IRONIC_PXE_INTERFACE_ADDRESS${IRONIC_PXE_INTERFACE_ADDRESS:-10.0.175.2}
IRONIC_DHCP_POOL_START=${IRONIC_DHCP_POOL_START:-10.0.175.100}
IRONIC_DHCP_POOL_END=${IRONIC_DHCP_POOL_END:-10.0.175.100}
IRONIC_DHCP_POOL_NETMASK=${IRONIC_DHCP_POOL_NETMASK:-255.255.255.0}

wget -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
sudo echo "deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main" >>  /etc/apt/sources.list.d/saltstack.list
sudo apt-get update
sudo apt-get install salt-minion

WORKDIR=$(pwd)

git clone https://github.com/ingwarr/underpillar.git
git clone https://review.gerrithub.io/ingwarr/salt-dnsmasq
git clone https://review.gerrithub.io/ingwarr/salt-ironic
git clone https://review.gerrithub.io/ingwarr/salt-tftpd-xinetd
git clone https://review.gerrithub.io/ingwarr/salt-nginx
git clone https://review.gerrithub.io/ingwarr/salt-neutron
git clone https://review.gerrithub.io/ingwarr/salt-keystone
git clone https://gerrit.mcp.mirantis.net/salt-formulas/apache
git clone https://gerrit.mcp.mirantis.net/salt-formulas/memcached
git clone https://gerrit.mcp.mirantis.net/salt-formulas/mysql
git clone https://gerrit.mcp.mirantis.net/salt-formulas/rabbitmq

mkdir -p /srv/pillar/
mkdir -p /srv/salt

cd /srv/salt
ln -s ${WORKDIR}/salt-dnsmasq/dnsmasq
ln -s ${WORKDIR}/apache/apache
ln -s ${WORKDIR}/mysql/mysql
ln -s ${WORKDIR}/rabbitmq/rabbitmq
ln -s ${WORKDIR}/salt-ironic/ironic
ln -s ${WORKDIR}/salt-neutron/neutron
ln -s ${WORKDIR}/salt-tftpd-xinetd/tftpd
ln -s ${WORKDIR}/memcached/memcached
ln -s ${WORKDIR}/salt-keystone/keystone
ln -s ${WORKDIR}/salt-nginx/nginx

cp ${WORKDIR}/underpillar/pillar/*.sls /srv/pillar/
cp ${WORKDIR}/underpillar/states/*.sls /srv/salt/

find /srv/pillar/ -type f -exec sed -i "s/==IRONIC_PXE_INTERFACE_NAME==/${IRONIC_PXE_INTERFACE_NAME}/g" {} +
find /srv/pillar/ -type f -exec sed -i "s/==IRONIC_PXE_INTERFACE_ADDRESS==/${IRONIC_PXE_INTERFACE_ADDRESS}/g" {} +
find /srv/pillar/ -type f -exec sed -i "s/==IRONIC_DHCP_POOL_START==/${IRONIC_DHCP_POOL_START}/g" {} +
find /srv/pillar/ -type f -exec sed -i "s/==IRONIC_DHCP_POOL_END==/${IRONIC_DHCP_POOL_END}/g" {} +
find /srv/pillar/ -type f -exec sed -i "s/==IRONIC_DHCP_POOL_NETMASK==/${IRONIC_DHCP_POOL_NETMASK}/g" {} +
