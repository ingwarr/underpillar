Install standalone ironic using salt-minion
-------------------------------------------


Assume that 'ens4' is the interface connected to the PXE network, which
will be used for provisioning, and the address 10.0.175.2/24 is already
added to this interface.

There is possible to use dnsmasq or neutron as a PXE provider.

    # Login to the node which will be used for Ironic under 'root' user

    export IRONIC_PXE_MANAGER=dnsmasq
    export IRONIC_PXE_INTERFACE_NAME=ens4
    export IRONIC_PXE_INTERFACE_ADDRESS=10.0.175.2
    export IRONIC_DHCP_POOL_START=10.0.175.100
    export IRONIC_DHCP_POOL_END=10.0.175.200

    curl https://raw.githubusercontent.com/ingwarr/underpillar/master/bootstrap.sh -o ./bootstrap.sh && bash ./bootstrap.sh
