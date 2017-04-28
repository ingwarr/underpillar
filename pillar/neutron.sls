neutron:
  underlay:
    enabled: true
    debug: true
    provision_address: ==IRONIC_PXE_INTERFACE_ADDRESS==
    provision_netmask: ==IRONIC_DHCP_POOL_NETMASK_PREFIX==
    provision_interface: ==IRONIC_PXE_INTERFACE_NAME==
    file_url_port: 8080
    bridge_name: brbm
    inspector_range:
      start: ==IRONIC_DHCP_POOL_START==
      end: ==IRONIC_DHCP_POOL_END==
      prefix: ==IRONIC_DHCP_POOL_NETMASK_PREFIX==
    database:
      engine: mysql
      host: keystone
      port: 3306
      name: neutron
      user: neutron
      password: password
    enable_keystone: true
    identity:
      engine: keystone
      region: RegionOne
      host: keystone
      port: 35357
      user: neutron
      password: password
      tenant: service
    message_queue:
      engine: rabbitmq
      host: keystone
      port: 5672
      user: openstack
      password: password
      virtual_host: '/openstack'
