rabbitmq:
  server:
    enabled: true
    secret_key: rabbit_master_cookie
    memory:
      vm_high_watermark: 0.8
    bind:
      address: 127.0.0.1
      port: 5672
    management:
      bind:
        address: 127.0.0.1
        port: 15672
    plugins:
    - amqp_client
    - rabbitmq_management
    admin:
      name: openstack
      password: password
    host:
      '/openstack':
        enabled: true
        user: ironic
        password: password
