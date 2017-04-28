neutron:
  underlay:
    enabled: true
    debug: true
    provision_address: 10.0.175.1
    provision_netmask: 24
    provision_interface: ==IRONIC_PXE_INTERFACE==
    file_url_port: 8080
    bridge_name: brbm
    inspector_range:
      start: 10.0.175.10
      end: 10.0.175.100
      prefix: 24
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
