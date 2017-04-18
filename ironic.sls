ironic:
  server:
    enabled: true
    version: mitaka
    testing: false
    enabled_drivers: pxe_ipmitool,agent_ipmitool,agent_ssh,pxe_ssh
    deployment_address: 10.0.175.2
    file_url_port: 8080
    database:
      engine: mysql
      host: localhost
      port: 3306
      name: ironic
      user: ironic
      password: password
    enable_keystone: true
    identity:
      engine: keystone
      region: RegionOne
      host: localhost
      port: 35357
      user: ironic
      password: password
      tenant: service
    bind:
      address: 0.0.0.0
      port: 6385
    message_queue:
      engine: rabbitmq
      host: localhost
      port: 5672
      user: openstack
      password: password
      virtual_host: '/openstack'
    dhcp_provider: none
    ipxe_enabled: true
    webserver_use: true
    http_boot_folder: /httpboot
    enable_cors: false
    tftp:
      host: 0.0.0.0
      boot_directory: /tftpboot
    drivers:
      - engine: pxe_ipmitool
      - engine: agent_ipmitool
